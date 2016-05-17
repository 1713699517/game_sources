//
//  EventHandler.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-10.
//
//

#include "EventHandler.h"
#include "MemoryAllocator.h"

using namespace ptola::event;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CEventHandler);

CEventHandler::CEventHandler(CCObject *pTarget, SEL_PtolaEventHandler eventHandler)
: m_pTarget(pTarget)
, m_pHandlerFunc(eventHandler)
{

}

CEventHandler::~CEventHandler()
{
    
}

CEventHandler *CEventHandler::create(CCObject *pTarget, SEL_PtolaEventHandler eventHandler)
{
    CEventHandler *pRet = new CEventHandler( pTarget, eventHandler );
    if( pRet != NULL )
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        return NULL;
    }
}

void CEventHandler::invoke(CCObject *pObject, CEvent *pEvent)
{
    if( m_pTarget != NULL && m_pHandlerFunc != NULL )
    {
        (m_pTarget->*m_pHandlerFunc)(pObject, pEvent);
    }
}

bool CEventHandler::operator==(const ptola::event::CEventHandler rhs)
{
    return m_pTarget == rhs.m_pTarget && m_pHandlerFunc == rhs.m_pHandlerFunc;
}

bool CEventHandler::isEqual(CCObject *pTarget, SEL_PtolaEventHandler pHandlerFunc)
{
    return m_pTarget == pTarget && m_pHandlerFunc == pHandlerFunc;
}