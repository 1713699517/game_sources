//
//  TcpClient.h
//  GameBox
//
//  Created by Caspar on 2013-4-26.
//
//

#ifndef __GameBox__TcpClient__
#define __GameBox__TcpClient__

#include <pthread.h>
#include "Msg.h"
#include "misc/socketcc.h"
#if( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <fcntl.h>
#else
#include <sys/fcntl.h>
#endif
namespace ptola
{

namespace network
{

    class CTcpClient : public CCObject
    {
    public:
        static CTcpClient *sharedTcpClient();
    public:
        //2 ipv4   30 ipv6
        CTcpClient(int nTag, int nAddressFamily=AF_INET);
        ~CTcpClient();

        int connect( IPAddress &address , unsigned short ustPort );
        int connect( const char *lpcszHost, unsigned short ustPort);
        void close();
        void send(CReqMessage *pReq);
        int getTag();

        void setPauseProcess(bool bPause);
        bool getPauseProcess();
        void mainThreadProcess(float dt);

        bool isConnected();
    protected:
        void onProcessMessage(CAckMessage *pAckMsg );
        void onDisconnected();
        void onConnected();
    private:
        void configurationSocket();
        static void *_thread_work_(void *data);

        void pushReceiveData( char *pData, int len );
        void createReceiveMessage( char *pData, int len );
        void fillReceiveMessage( char *pData, int len );
        void onDisconnectedMain(float dt);
        //socket
        int m_nTag;
        TCPSocket *m_pSocket;
        bool m_bConnected;
        
        //receive data
//        SAckHeader m_header;
        size_t m_recvHeaderRest;
        size_t m_recvSizeRest;
//        CAckMessage *m_pMsg;
        CAckMessage *m_ackMsg;
        unsigned char m_uchSocketHex;

        //thread
        pthread_t m_Thread;
        bool m_ThreadExit;
        bool m_bPauseProcess;

        //cache
        MutualExclusion m_AckMsgLocker;
        std::list<CAckMessage *> m_AckMsgCaches;
    };

}
}
#endif /* defined(__GameBox__TcpClient__) */
