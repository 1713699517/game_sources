//
//  DateTime.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-7.
//
//

#include "DateTime.h"
#include "MemoryAllocator.h"


USING_NS_CC;
using namespace ptola;
using namespace ptola::memory;

MEMORY_MANAGE_OBJECT_IMPL(CDateTime);

CDateTime::CDateTime()
{
    CCTime::gettimeofdayCocos2d(&m_DateTime, NULL);
}

CDateTime::~CDateTime()
{

}

void CDateTime::reset()
{
    CCTime::gettimeofdayCocos2d(&m_DateTime, NULL);
}

CDateTime *CDateTime::create()
{
    CDateTime *pRet = new CDateTime;
    if( pRet != NULL )
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CC_SAFE_DELETE(pRet);
        return NULL;
    }
}

long CDateTime::getTotalMilliseconds()
{
    return (m_DateTime.tv_sec % 86400) * 1000L + m_DateTime.tv_usec / 1000L;
}

long CDateTime::getMicroseconds()
{
    return m_DateTime.tv_usec;
}

int CDateTime::getTotalSeconds()
{
    return m_DateTime.tv_sec;
}