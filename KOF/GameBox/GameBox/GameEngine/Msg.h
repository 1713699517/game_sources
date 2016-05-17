//
//  Msg.h
//  GameBox
//
//  Created by Caspar on 2013-4-26.
//
//

#ifndef __GameBox__Msg__
#define __GameBox__Msg__

#include "cocos2d.h"
#include "BufferStream.h"
#include "DataReader.h"
#include "DataWriter.h"

#define NETWORK_MSG_MAX_LENGTH  102400U  //100K

USING_NS_CC;
using namespace ptola::io;

namespace ptola
{
namespace network
{
#pragma pack(1)

#define REQ_HEADER_LENGTH   6

    struct SReqHeader
    {
        unsigned int uLength;
        unsigned short ustChecksum;
        unsigned int uMsgId;
        unsigned short uHex;
        bool isValid();
    } ;

#define ACK_HEADER_LENGTH   5

    struct SAckHeader
    {
        unsigned int uLength;
        unsigned short ustChecksum;
        unsigned int uMsgId;
        bool bCompression;
        bool isValid();
    };

#pragma pack()

//    class CRequestMessage
    class CReqMessage : public CCObject
    {
    public:
        CReqMessage(unsigned int msgId=0U);
        ~CReqMessage();
    protected:
        SReqHeader header;
        CBufferStream<NETWORK_MSG_MAX_LENGTH> m_MsgBufferStream;
    public:
        SReqHeader *getHeader();
        virtual void serialize(CDataWriter *pWriter);
        IStream *getStreamData(){ return &m_MsgBufferStream; };
        void setLength(size_t len);
        size_t getLength();
    };

//    class CAcknowledgementMessage
    class CAckMessage : public CCObject
    {
    public:
        CAckMessage(unsigned int msgId=0U);
        ~CAckMessage();
    protected:
        SAckHeader header;
        CBufferStream<NETWORK_MSG_MAX_LENGTH> m_MsgBufferStream;
    public:
        SAckHeader *getHeader();
        virtual void deserialize(CDataReader *pReader);
        IStream *getStreamData(){ return &m_MsgBufferStream; };
        void resetStream(){ m_MsgBufferStream.seek(0, eSO_Begin); }
        size_t getLength();
        unsigned int getMsgID();
    };
}
}
#endif /* defined(__GameBox__Msg__) */
