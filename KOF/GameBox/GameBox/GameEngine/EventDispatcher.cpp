//
//  EventDispatcher.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-10.
//
//

#include "EventDispatcher.h"
#include "MemoryAllocator.h"
using namespace ptola::event;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CEventDispatcher);

CEventDispatcher::CEventDispatcher()
: m_pDict(NULL)
{

}

CEventDispatcher::~CEventDispatcher()
{
    CC_SAFE_RELEASE(m_pDict);
}

void CEventDispatcher::addEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector)
{
    CEventHandler *pHandler = CEventHandler::create(pTarget, selector);
    if( m_pDict == NULL )
    {
        m_pDict = CCDictionary::create();
        CC_SAFE_RETAIN(m_pDict);
    }
    CCObject *pArrayObject = m_pDict->objectForKey(lpcszEventName);
    if( pArrayObject == NULL )
    {
        CCArray *pArray1 = CCArray::create(pHandler, NULL);
        m_pDict->setObject(pArray1, lpcszEventName);
    }
    else
    {
        CCArray *pArray2 = dynamic_cast<CCArray *>(pArrayObject);
        if( pArray2 == NULL )
        {
            pArray2 = CCArray::create(pHandler, NULL);
            m_pDict->setObject(pArray2, lpcszEventName);
        }
        else
        {
            if(!pArray2->containsObject(pHandler))
            {
                pArray2->addObject(pHandler);
            }
        }
    }    
}

void CEventDispatcher::removeEventListener(const char *lpcszEventName, cocos2d::CCObject *pTarget, SEL_PtolaEventHandler selector)
{
    if( m_pDict == NULL )
        return;
    CCObject *pArrayObject = m_pDict->objectForKey(lpcszEventName);
    if( pArrayObject == NULL )
        return;
    CCArray *pArray = dynamic_cast<CCArray *>(pArrayObject);
    if( pArray == NULL )
        return;
    CCObject *pObject = NULL;
    CCARRAY_FOREACH(pArray, pObject)
    {
        CEventHandler *pHandler = dynamic_cast<CEventHandler *>(pObject);
        if( pHandler == NULL )
            continue;
        if( pHandler->isEqual(pTarget, selector))
        {
            pArray->removeObject(pHandler);
            break;
        }
    }
    if( pArray->count() == 0 )
    {
        m_pDict->removeObjectForKey(lpcszEventName);
    }
    if( m_pDict->count() == 0 )
    {
        CC_SAFE_RELEASE_NULL(m_pDict);
    }
}

void CEventDispatcher::removeEventListeners(const char *lpcszEventName)
{
    if( m_pDict == NULL )
        return;
    CCObject *pArrayObject = m_pDict->objectForKey(lpcszEventName);
    if( pArrayObject == NULL )
        return;
    m_pDict->removeObjectForKey(lpcszEventName);
    if( m_pDict->count() == 0 )
    {
        CC_SAFE_RELEASE_NULL(m_pDict);
    }
}

void CEventDispatcher::removeAllEventListener()
{
    CC_SAFE_RELEASE_NULL(m_pDict);
}

void CEventDispatcher::dispatchEvent(CCObject *pSender, CEvent *pEvent)
{
    if( pEvent == NULL )
        return;
    if( m_pDict == NULL )
        return;
    CCObject *pArrayObject = m_pDict->objectForKey(pEvent->getEventName());
    if( pArrayObject == NULL )
        return;
    CCArray *pArray = dynamic_cast<CCArray *>(pArrayObject);
    if( pArray == NULL )
        return;
    CCObject *pObject = NULL;
    CCARRAY_FOREACH(pArray, pObject)
    {
        if( pEvent->getHandled() )
        {
            break;
        }
        CEventHandler *pHandler = dynamic_cast<CEventHandler *>(pObject);
        if( pHandler == NULL )
        {
            continue;
        }
        pHandler->invoke(pSender, pEvent);
    }
}

bool CEventDispatcher::hasEventListener(const char *lpcszEventName)
{
    do
    {
        CC_BREAK_IF(m_pDict == NULL);

        CCObject *pArrayObject = m_pDict->objectForKey(lpcszEventName);
        CC_BREAK_IF(pArrayObject == NULL);

        CCArray *pArray = dynamic_cast<CCArray *>(pArrayObject);
        CC_BREAK_IF(pArray == NULL);

        return pArray->count() > 0;
    }
    while (0);
    return false;
}

