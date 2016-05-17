//
//  Event.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-10.
//
//

#include "Event.h"
#include "MemoryAllocator.h"

using namespace ptola::event;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CEvent);

CEvent::CEvent(const char *lpcszEventName, CCObject *lpTarget, CCObject *lpData)
{
    init( lpcszEventName, lpTarget, lpData );
};

CEvent::~CEvent()
{

};

CEvent *CEvent::create(const char *lpcszEventName, CCObject *lpTarget, CCObject *lpData)
{
    CEvent *pRet = new CEvent(lpcszEventName, lpTarget, lpData);
    if( pRet != NULL && pRet->init(lpcszEventName, lpTarget, lpData) )
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

bool CEvent::init(const char *lpcszEventName, CCObject *lpTarget, CCObject *lpData)
{
    m_strEventName = lpcszEventName;
    m_lpTarget = lpTarget;
    m_lpData = lpData;
    m_bHandled = false;
    return true;
}

const char *CEvent::getEventName()
{
    return m_strEventName.c_str();
}

bool CEvent::getHandled()
{
    return m_bHandled;
}

void CEvent::stopPropagation()
{
    m_bHandled = true;
}

CCObject *CEvent::getData()
{
    return m_lpData;
}

CCObject *CEvent::getTarget()
{
    return m_lpTarget;
}



MEMORY_MANAGE_OBJECT_IMPL(CProgressEvent);

CProgressEvent::CProgressEvent(CCObject *lpTarget, float fLoaded, float fTotal)
: CEvent( "LoadProgress", lpTarget, NULL )
, m_fLoaded(fLoaded)
, m_fTotal(fTotal)
{

}

CProgressEvent::~CProgressEvent()
{
    
}

CProgressEvent *CProgressEvent::create(CCObject *lpTarget, float fLoaded, float fTotal)
{
    CProgressEvent *pRet = new CProgressEvent(lpTarget, fLoaded, fTotal);
    if( pRet != NULL && pRet->init(lpTarget, fLoaded, fTotal))
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

bool CProgressEvent::init(CCObject *lpTarget, float fLoaded, float fTotal)
{
    m_fLoaded = fLoaded;
    m_fTotal = fTotal;
    return true;
}

float CProgressEvent::getLoaded()
{
    return m_fLoaded;
}

float CProgressEvent::getTotal()
{
    return m_fTotal;
}




