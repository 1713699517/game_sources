//
//  TcpClient.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-26.
//
//

#include "cocos2d.h"
#include "TcpClient.h"
#include "NotificationConstant.h"
#include "Msg.h"

#define SOCKET_HEX_INIT_COUNT       13
#define SOCKET_REQ_CHECKSUM_DEFAULT 87
#define SOCKET_MESSAGE_CACHED_COUNT 1000    //ack 缓存条数

using namespace ptola::network;

void *CTcpClient::_thread_work_(void *data)
{
    CTcpClient *pThreadData = (CTcpClient *)data;
    int nBytesReceived = -1;
    char recvBuff[ NETWORK_MSG_MAX_LENGTH ];
    while( !pThreadData->m_ThreadExit )
    {
        nBytesReceived = -1;
        try
        {
            nBytesReceived = pThreadData->m_pSocket->RecvData(recvBuff, NETWORK_MSG_MAX_LENGTH);
        }
        catch (SocketException &e)
        {
            SocketException::ErrorCodes code = e;
            if( code == SocketException::errNotConnected )
            {
                CCLOG("Connection Closed!");
                break;
            }
            if( code == SocketException::errWouldBlock )
                continue;
        }
        if( nBytesReceived > 0 )
        {
            //push data
            CCLOG("network message received :%d bytes", nBytesReceived);
            pThreadData->pushReceiveData(recvBuff, nBytesReceived);
        }
        else
        {   //remote closed!//zero has been sent
            pThreadData->m_ThreadExit = true;
        }
    }
//    if( pThreadData->m_pMsg != NULL )
//    {
//        free(pThreadData->m_pMsg);
//        pThreadData->m_pMsg = NULL;
//    }

    if( pThreadData->m_pSocket != NULL )
    {
        delete pThreadData->m_pSocket;
        pThreadData->m_pSocket = NULL;
    }
    pThreadData->m_bConnected = false;
    pThreadData->onDisconnected();
    return NULL;
}

CTcpClient *CTcpClient::sharedTcpClient()
{
    static CTcpClient tcpClient(-1);
    return &tcpClient;
}

CTcpClient::CTcpClient(int nTag, int nAddressFamily)
: m_nTag(nTag)
, m_pSocket(NULL)
, m_Thread((pthread_t)NULL)
, m_ThreadExit(true)
, m_recvHeaderRest(0)
, m_recvSizeRest(0)
, m_AckMsgLocker(MutualExclusion::fastMutEx)
, m_bPauseProcess(false)
, m_bConnected(false)
//, m_pMsg(NULL)
{
    
}

CTcpClient::~CTcpClient()
{
    close();
}

void CTcpClient::configurationSocket()
{
    if( m_pSocket == NULL )
        return;
    //
    int nFlag = m_pSocket->FCntl(F_GETFL, 0);
    nFlag |= O_NONBLOCK;
    m_pSocket->FCntl(F_SETFL, nFlag);

    struct linger sLinger;
    sLinger.l_onoff = 1;
    sLinger.l_linger = 0;
    m_pSocket->SetSockOpt(SOL_SOCKET, SO_LINGER, &sLinger, sizeof(struct linger));

    //
}

void CTcpClient::close()
{
    m_ThreadExit = true;
}

int CTcpClient::getTag()
{
    return m_nTag;
}

int CTcpClient::connect(const char *lpcszHost, unsigned short ustPort)
{
    IPAddress ip;
    ip.SetHostName(lpcszHost, false);
    return connect(ip, ustPort);
}

int CTcpClient::connect(IPAddress &address, unsigned short ustPort)
{
    close();
    while( m_ThreadExit && m_pSocket != NULL )
    {
        sleep(1);
        //主线程等待,必须清空所以close逻辑后再继续执行后面的逻辑
    }
    m_pSocket = new TCPSocket( address.GetAddressFamily() == AF_INET6 );
    if( m_pSocket == NULL )
        return 0;
    try
    {
        m_pSocket->Connect(address, (unsigned int)ustPort);
        m_pSocket->SetLocal();
        m_pSocket->SetConnected();
        m_uchSocketHex = SOCKET_HEX_INIT_COUNT;
        configurationSocket();

        m_ThreadExit = false;
        if( pthread_create(&m_Thread, NULL, CTcpClient::_thread_work_, this) )
        {
            throw SocketException(SocketException::errInterrupted);
        }
        m_bConnected = true;
        onConnected();
        return 1;
    }
    catch(SocketException &e)
    {
        close();
        return 0;
    }
}

void CTcpClient::send(CReqMessage *pReq)
{
    if( m_pSocket != NULL )
    {
        //Req check sum
        SReqHeader *pReqHeader = pReq->getHeader();
        unsigned int len = pReqHeader->uLength - sizeof(unsigned short);
        unsigned int msgid = pReqHeader->uMsgId;
        unsigned int hex = (m_uchSocketHex + 1) & 0x7F;
        unsigned int checksum = (hex + msgid + (pReqHeader->uLength - REQ_HEADER_LENGTH) + SOCKET_REQ_CHECKSUM_DEFAULT ) & 0x1FF;
        //rewrite header
        char *lpData = (char *)pReq->getStreamData()->getData();
        *((unsigned short *)lpData) = htons(len);
        lpData += sizeof(unsigned short);
        *((unsigned int *)lpData) = htonl( ( (checksum<<23) | (msgid<<7) | (hex) ) );

        int uRest = (int)pReq->getHeader()->uLength;
        int uIndex = 0;
        while(uRest > 0)
        {
            int uSent = m_pSocket->SendData((char *)((size_t)pReq->getStreamData()->getData() + (size_t)uIndex), pReq->getHeader()->uLength);
            uIndex += uSent;
            uRest -= uSent;
        }
        m_uchSocketHex++;
    }

    // m_ackMsg = new CAckMessage;
    // CCLOG("[crm]=2");
    // memcpy( m_ackMsg->getHeader(), pData, ACK_HEADER_LENGTH);
    // CCLOG("[erm]=2");
        
    // onProcessMessage(m_ackMsg);
}

void CTcpClient::pushReceiveData(char *pData, int len)
{
    if( m_recvSizeRest == 0 )
    {
        createReceiveMessage(pData, len);
    }
    else
    {
        fillReceiveMessage(pData, len);
    }
}

void CTcpClient::createReceiveMessage(char *pData, int len)
{
    if( len == 0 )
        return;
    if( len < ACK_HEADER_LENGTH )
    {
        m_recvHeaderRest = ACK_HEADER_LENGTH - len;
//        char *pHeaderPos = (char *)&m_header;
        char *pHeaderPos = (char *)m_ackMsg->getHeader();
        CCLOG("[crm]=1");
        memcpy( pHeaderPos, pData, len );
        CCLOG("[erm]=1");
    }
    else
    {
        SAckHeader *pExFixedHeader = (SAckHeader *)pData;
        unsigned short headerLength = ntohs(pExFixedHeader->uLength) + sizeof(unsigned short);
        if( headerLength > NETWORK_MSG_MAX_LENGTH )
            return;
//        m_ackMsg = (CAckMessage *)malloc( headerLength );
//        memcpy( m_ackMsg->getHeader(), pData, ACK_HEADER_LENGTH);
//        m_pMsg = new CAckMessage;
//        memcpy( &m_header, pData, sizeof(SAckHeader) );
//        memcpy( (void *)m_pMsg->getHeader(), pData, sizeof(SAckHeader) );

        m_ackMsg = new CAckMessage;
        CCLOG("[crm]=2");
        memcpy( m_ackMsg->getHeader(), pData, ACK_HEADER_LENGTH);
        CCLOG("[erm]=2");
        
        m_recvHeaderRest = 0;
        m_recvSizeRest = headerLength - ACK_HEADER_LENGTH;
        char *lpOffset = (char *)pData + ACK_HEADER_LENGTH;
        fillReceiveMessage(lpOffset, len - ACK_HEADER_LENGTH);
    }
    
    if( m_recvSizeRest > NETWORK_MSG_MAX_LENGTH )
    {
        CCLOG("error!, receive rest error!");
        close();
        return;
    }
}

void CTcpClient::fillReceiveMessage(char *pData, int len)
{
    int currRest = len;
    
    if( m_recvSizeRest > NETWORK_MSG_MAX_LENGTH )
    {
        CCLOG("error!, receive rest error!");
        close();
        return;
    }
    
    if( m_recvHeaderRest > 0 )
    {
        char *lpHeaderOffset = (char *)(((char *)m_ackMsg->getHeader()) + ACK_HEADER_LENGTH - m_recvHeaderRest);
        if( len < m_recvHeaderRest )
        {
            CCLOG("[crm]=3");
            memcpy( lpHeaderOffset, pData, len );
            CCLOG("[erm]=3");
            m_recvHeaderRest -= len;
            return;
        }
        else
        {
            CCLOG("[crm]=4");
            memcpy( lpHeaderOffset, pData, m_recvHeaderRest );
            CCLOG("[erm]=4");
            pData += m_recvHeaderRest;
            m_recvHeaderRest = 0;
        }
    }
//    if( m_recvSizeRest > 0 )//&& m_recvHeaderRest == 0 )
//    {
//        
//        char *lpHeaderOffset = (char *)(((char *)&m_header) + sizeof(SAckHeader) - m_recvHeaderRest);
//        if( len < m_recvHeaderRest )
//        {
//            memcpy( lpHeaderOffset, pData, len );
//            m_recvHeaderRest -= len;
//            return;
//        }
//        else
//        {
//            memcpy( lpHeaderOffset, pData, m_recvHeaderRest );
//            pData = pData + m_recvHeaderRest;
//            currRest -= m_recvHeaderRest;
//            m_recvHeaderRest = 0;
//            unsigned short headerLength = ntohs(m_header.uLength) + sizeof(unsigned short);
//            if( headerLength > NETWORK_MSG_MAX_LENGTH )
//                return;
//            m_pMsg = (CAckMessage *)malloc( headerLength );
//            memcpy( (void *)m_pMsg->getHeader(), &m_header, sizeof(SAckHeader) );
//            m_recvSizeRest = headerLength - sizeof(SAckHeader);
//        }
//    }
    unsigned int headerLength = ntohs(m_ackMsg->getHeader()->uLength) + sizeof(unsigned short);
    if( m_recvSizeRest > 0 && currRest > 0 )
    {
        if( currRest >= m_recvSizeRest )
        {
            char *lpWritePos = (char *)m_ackMsg->getStreamData()->getData() + (headerLength - ACK_HEADER_LENGTH - m_recvSizeRest);
            CCLOG("[crm]=5");
            memcpy( lpWritePos, pData, m_recvSizeRest );
            CCLOG("[erm]=5");
            //process
//            onProcessMessage(m_pMsg);
            onProcessMessage(m_ackMsg);
            //
//            free( (void *)m_pMsg );
//            delete m_pMsg;
//            m_pMsg = NULL;
            pData = pData + m_recvSizeRest;
            currRest -= m_recvSizeRest;
            m_recvSizeRest = 0;
            createReceiveMessage(pData, currRest);
        }
        else
        {
            char *lpWritePos = (char *)m_ackMsg->getStreamData()->getData() + (headerLength - ACK_HEADER_LENGTH - m_recvSizeRest);
            CCLOG("[crm]=6");
            memcpy( lpWritePos, pData, m_recvSizeRest );
            CCLOG("[crm]=6");
            m_recvSizeRest -= currRest;
            currRest = 0;
        }
    }
    else
    {
        if( m_recvSizeRest == 0 )
        {
            //process
//            onProcessMessage(m_pMsg);
            onProcessMessage(m_ackMsg);
            //
//            free( (void *)m_pMsg );
//            delete m_pMsg;
//            m_pMsg = NULL;
        }
        if( currRest > 0 )
        {
            createReceiveMessage( pData, currRest );
        }
        else
        {
            return;
        }
    }
}

void CTcpClient::onProcessMessage(CAckMessage *pAckMsg)
{
    //re
    char *pAckHeader = (char *)pAckMsg->getHeader();
    //length 16
    unsigned short uLength = ntohs( *((unsigned short *)pAckHeader) );
    pAckHeader += sizeof(unsigned short);
    //checksum 7
    unsigned char uchChecksum = ((*(unsigned char *)pAckHeader) >> 1);
    //msg 1+15
    unsigned short uMsgIdL = (((*(unsigned char *)pAckHeader) & 0x1) << 15);
    pAckHeader += sizeof(unsigned char);
    unsigned short uMsgIdR = (ntohs((*(unsigned short *)pAckHeader)) >> 1);

    unsigned short uMsgId = ((uMsgIdL | uMsgIdR));

    pAckHeader += sizeof(unsigned char);
    //compress 1
    bool bCompressed = (*pAckHeader) & 0x1;
    pAckMsg->getHeader()->uLength = uLength;
    pAckMsg->getHeader()->ustChecksum = uchChecksum;
    pAckMsg->getHeader()->uMsgId = uMsgId;
    pAckMsg->getHeader()->bCompression = bCompressed;
    if( !pAckMsg->getHeader()->isValid() )
    {
        CCLOG("Message Valid! Len=%d Checksum=%d MsgId=%d Compress=%d", uLength, uchChecksum, uMsgId, bCompressed);
        return;
    }
//    int nTryTimes = 100;
//    while( nTryTimes-- > 0 )
//    {
//        try
//        {
//            m_AckMsgLocker.Lock();
//        }
//        catch (const ThreadException& e)
//        {
//            sleep(1);
//            continue;
//        }
//        break;
//    }
//    if( nTryTimes == 0 )    //if try times run out, return, and do not process this message
//        return;
    try
    {
        m_AckMsgLocker.Lock();
    }
    catch (const ThreadException& e)
    {
        CCLOG("[lock_01] if you seeing this message, please contact CasparWong.");
        throw e;
    }

    if( m_AckMsgCaches.size() < SOCKET_MESSAGE_CACHED_COUNT )
    {
        m_AckMsgCaches.push_back(pAckMsg);
        CCLOG("Msg pushed=%d len=%u this=%d cache=%d", uMsgId, pAckMsg->getLength(), this, &m_AckMsgCaches);
    }
//    try
//    {
//        m_AckMsgLocker.Unlock();
//    }
//    catch (const ThreadException &e)
//    {
//        CCLOG("[TCPClient] UnLock Error");
//    }
    try
    {
        m_AckMsgLocker.Unlock();
    }
    catch (const ThreadException& e)
    {
        CCLOG("[unlock_01] if you seeing this message, please contact CasparWong.");
        throw e;
    }
}

void CTcpClient::onDisconnected()
{
    CCLOG("Connection Disconnected");
    CCDirector::sharedDirector()->getScheduler()->unscheduleSelector(schedule_selector(CTcpClient::mainThreadProcess), this);
    CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(CTcpClient::onDisconnectedMain), this, 0.1f, 0, 0.1f, false);
}

void CTcpClient::onConnected()
{
    CCLOG("Connection Connected");
    CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(CTcpClient::mainThreadProcess), this, 0.0f, false);
}

void CTcpClient::onDisconnectedMain(float dt)
{
    CCLOG("Connection Closed * 2!");
    CCNotificationCenter::sharedNotificationCenter()->postNotification(NOTIFYCONST_NETWORK_DISCONNECT_MESSAGE);
    CCDirector::sharedDirector()->getScheduler()->unscheduleUpdateForTarget(this);
}

void CTcpClient::mainThreadProcess(float dt)
{
    if( getPauseProcess() )
        return;
    if(!m_AckMsgCaches.empty())
    {
        CCLOG("mainThreadProcess this=%ld cache=%ld", this, &m_AckMsgCaches);
        bool bLocked = false;
        try
        {
            bLocked = m_AckMsgLocker.TryLock();
        }
        catch (const ThreadException& e)
        {
            CCLOG("[trylock_02] if you seeing this message, please contact CasparWong.");
            throw e;
        }
        if( !bLocked )
            return;
        CCLOG("TCPClient = Locked!");
        for( int i = 0 ; i < 10 && !m_AckMsgCaches.empty() ; i++ )
        {
            CAckMessage *pAckMsg = m_AckMsgCaches.front();
            CCLOG("TCPClient = MessageProcess begin %d", pAckMsg->getMsgID());
            CCNotificationCenter::sharedNotificationCenter()->postNotification(NOTIFYCONST_NETWORK_MESSAGE, pAckMsg);
            m_AckMsgCaches.pop_front();
            delete pAckMsg;
            CCLOG("TCPClient = MessageProcess end");
        }
        try
        {
            m_AckMsgLocker.Unlock();
        }
        catch (const ThreadException& e)
        {
            CCLOG("[unlock_02] if you seeing this message, please contact CasparWong.");
            throw e;
        }
        CCLOG("TCPClient = UnLocked!");
    }
}

void CTcpClient::setPauseProcess(bool bPause)
{
    m_bPauseProcess = bPause;
}

bool CTcpClient::getPauseProcess()
{
    return m_bPauseProcess;
}

bool CTcpClient::isConnected()
{
    return m_bConnected;
}