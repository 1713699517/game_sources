//
//  LuaEventDispatcher.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-10.
//
//

#include "LuaEventDispatcher.h"
#include "LuaScriptFunctionInvoker.h"
#include "MemoryAllocator.h"

using namespace ptola::event;
using namespace ptola::script;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CLuaEventDispatcher);

CLuaEventDispatcher::CLuaEventDispatcher()
: m_pDict(NULL)
{

}

CLuaEventDispatcher::~CLuaEventDispatcher()
{
    CC_SAFE_RELEASE_NULL(m_pDict);
}

void CLuaEventDispatcher::addEventListener(const char *lpcszEventName, int selector)
{
    CCInteger *pHandler = CCInteger::create(selector);
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
            if( !pArray2->containsObject(pHandler) )
            {
                pArray2->addObject(pHandler);
            }
        }
    }
}

void CLuaEventDispatcher::removeEventListener(const char *lpcszEventName, int selector)
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
        CCInteger *pHandler = dynamic_cast<CCInteger *>(pObject);
        if( pHandler == NULL )
            continue;
        if( pHandler->getValue() == selector )
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

void CLuaEventDispatcher::removeEventListeners(const char *lpcszEventName)
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

void CLuaEventDispatcher::removeAllEventListener()
{
    CC_SAFE_RELEASE_NULL(m_pDict);
}

void CLuaEventDispatcher::dispatchEvent(const char *lpcszEventName, ...)
{
    if( m_pDict == NULL )
        return;
    CCObject *pArrayObject = m_pDict->objectForKey(lpcszEventName);
    if( pArrayObject == NULL )
        return;
    CCArray *pArray = dynamic_cast<CCArray *>(pArrayObject);
    if( pArray == NULL || pArray->count() == 0 )
        return;
    std::vector<SLuaEventArg *> vecArgs;

    va_list args;
    va_start(args, lpcszEventName);
    SLuaEventArg *i = va_arg(args, SLuaEventArg*);
    while(i != NULL)
    {
        vecArgs.push_back(i);
        i = va_arg(args, SLuaEventArg*);
    }
    va_end(args);

    dispatchEvent(lpcszEventName, &args);
}

void CLuaEventDispatcher::dispatchEvent(const char *lpcszEventName, std::vector<SLuaEventArg *> *vecArgs)
{
    if( m_pDict == NULL )
        return;
    CCObject *pArrayObject = m_pDict->objectForKey(lpcszEventName);
    if( pArrayObject == NULL )
        return;
    CCArray *pArray = dynamic_cast<CCArray *>(pArrayObject);
    if( pArray == NULL || pArray->count() == 0 )
        return;

    CCObject *pObject = NULL;
    CCARRAY_FOREACH(pArray, pObject)
    {
        CCInteger *pHandler = dynamic_cast<CCInteger *>(pObject);
        if( pHandler == NULL )
            continue;
        if( CLuaScriptFunctionInvoker::executeDispatchEvent(pHandler->getValue(), lpcszEventName, vecArgs) )
        {
            break;
        }
    }

}

void CLuaEventDispatcher::dispatchEvent(const char *lpcszEventName, int nLuaTable)
{
    if( m_pDict == NULL )
        return;
    CCObject *pArrayObject = m_pDict->objectForKey(lpcszEventName);
    if( pArrayObject == NULL )
        return;
    CCArray *pArray = dynamic_cast<CCArray *>(pArrayObject);
    if( pArray == NULL || pArray->count() == 0 )
        return;

    CCScriptEngineProtocol *pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
    if( pEngine == NULL )
        return;
    CCLuaEngine *pLuaEngine = dynamic_cast<CCLuaEngine *>(pEngine);
    if( pLuaEngine == NULL )
        return;
    CCLuaStack *pLuaStack = pLuaEngine->getLuaStack();
    if( pLuaStack == NULL )
        return;
    lua_State *L = pLuaStack->getLuaState();
    if( L == NULL )
        return;
    bool isNil = lua_isnil(L, -1);
    std::map< std::string, SLuaEventArg > args;
    if( !isNil && lua_istable(L, -1) )
    {
        int nStackTop = lua_gettop(L);
        lua_pushnil(L);

        while( lua_next(L, nStackTop) )
        {
            const char *lpKey = lua_tostring(L, -2);
            if( lua_isstring(L, -1) )
            {
                SLuaEventArg arg( lua_tostring(L, -1) );
                args[ lpKey ] = arg;
            }
            else if( lua_isnumber(L, -1) )
            {
                SLuaEventArg arg( lua_tonumber(L, -1) );
                args[ lpKey ] = arg;
            }
            lua_pop(L, 1);
        }
    }

    
    CCObject *pObject = NULL;
    CCARRAY_FOREACH(pArray, pObject)
    {
        CCInteger *pHandler = dynamic_cast<CCInteger *>(pObject);
        if( pHandler == NULL )
            continue;
        if( CLuaScriptFunctionInvoker::executeDispatchEventTable(pHandler->getValue(), lpcszEventName, &args) )
        {
            break;
        }
    }
}

bool CLuaEventDispatcher::hasEventListener(const char *lpcszEventName)
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





