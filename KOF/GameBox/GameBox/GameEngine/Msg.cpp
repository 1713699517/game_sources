//
//  Msg.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-26.
//
//

#include "Msg.h"

using namespace ptola::network;

bool SReqHeader::isValid()
{
    return (uHex + uMsgId + (uLength - sizeof(SReqHeader)) + 87) % 512 == ustChecksum;
}

bool SAckHeader::isValid()
{
    return (uLength + uMsgId) % 128 == ustChecksum;
}

SReqHeader *CReqMessage::getHeader()
{
    return &header;
}

SAckHeader *CAckMessage::getHeader()
{
    return &header;
}

void CReqMessage::serialize(ptola::io::CDataWriter *pWriter)
{
    //header
    pWriter->write(&header, 0, REQ_HEADER_LENGTH);
}

void CAckMessage::deserialize(ptola::io::CDataReader *pReader)
{
    //header
    pReader->read(&header, 0, ACK_HEADER_LENGTH);
}

void CReqMessage::setLength(size_t len)
{
    header.uLength = len;
}

size_t CReqMessage::getLength()
{
    return header.uLength;
}

CReqMessage::CReqMessage(unsigned int msgId)
{
    header.uMsgId = msgId;
}

CReqMessage::~CReqMessage()
{
    m_MsgBufferStream.close();
}

CAckMessage::CAckMessage(unsigned int msgId)
{
    header.uMsgId = msgId;
}

CAckMessage::~CAckMessage()
{
    m_MsgBufferStream.close();
}

size_t CAckMessage::getLength()
{
    return header.uLength;
}

unsigned int CAckMessage::getMsgID()
{
    return header.uMsgId;
}