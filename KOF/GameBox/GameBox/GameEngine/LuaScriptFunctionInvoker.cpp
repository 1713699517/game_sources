//
//  LuaScriptFunctionInvoker.cpp
//  GameBox
//
//  Created by Caspar on 13-5-7.
//
//

#include "LuaScriptFunctionInvoker.h"
#include "CCTouchSet.h"

using namespace ptola::event;
using namespace ptola::script;


bool CLuaScriptFunctionInvoker::executeTouchScript(cocos2d::CCScriptHandlerEntry *pEntry, const char *lpcszTouchType, CCObject *myObject, const char *lpcszMyObjectType, float fTouchX, float fTouchY)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
        return false;
    CCScriptEngineProtocol *pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
    if( pEngine == NULL )
        return false;
    CCLuaEngine *pLuaEngine = dynamic_cast<CCLuaEngine *>(pEngine);
    if( pLuaEngine == NULL )
        return false;
    CCLuaStack *pLuaStack = pLuaEngine->getLuaStack();
    if( pLuaStack == NULL )
        return false;

    lua_State *L = pLuaStack->getLuaState();
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString(lpcszTouchType);
    pLuaStack->pushCCObject(myObject, lpcszMyObjectType);
    pLuaStack->pushFloat(fTouchX);
    pLuaStack->pushFloat(fTouchY);
    bool bRet = pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 4) != 0;
    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
    return bRet;
}

bool CLuaScriptFunctionInvoker::executeTouchesScript(CCScriptHandlerEntry *pEntry, const char *lpcszTouchesType, CCObject *myObject, const char *lpcszMyObjectType, CCSet *pTouches)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
        return false;
    CCScriptEngineProtocol *pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
    if( pEngine == NULL )
        return false;
    CCLuaEngine *pLuaEngine = dynamic_cast<CCLuaEngine *>(pEngine);
    if( pLuaEngine == NULL )
        return false;
    CCLuaStack *pLuaStack = pLuaEngine->getLuaStack();
    if( pLuaStack == NULL )
        return false;


    lua_State *L = pLuaStack->getLuaState();
    int nStart = lua_gettop(L);
    
    CCTouchSet touchSet(pTouches);
    pLuaStack->pushString(lpcszTouchesType);
    pLuaStack->pushCCObject(myObject, lpcszMyObjectType);
    pLuaStack->pushCCObject(&touchSet, "CCTouchSet");

    bool bRet = pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 3) != 0;
    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
    return bRet;
}

void CLuaScriptFunctionInvoker::executePageScrolledScript(CCScriptHandlerEntry *pEntry, CCObject *myObject, const char *lpcszMyObjectType, int nPage)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString("PageScrolled");
    pLuaStack->pushCCObject(myObject, lpcszMyObjectType);
    pLuaStack->pushInt(nPage);
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 3);
    
    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }

    
}

void CLuaScriptFunctionInvoker::executeAnimationCompleteScript(cocos2d::CCScriptHandlerEntry *pEntry,  const char *lpcszAnimationName)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString("AnimationComplete");
    pLuaStack->pushString(lpcszAnimationName);
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 2);

    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
}

void CLuaScriptFunctionInvoker::executeLoadScript(cocos2d::CCScriptHandlerEntry *pEntry, cocos2d::CCNode *pNode)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString("Load");
    pLuaStack->pushCCObject(pNode, "CCNode");
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 2);

    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
}

void CLuaScriptFunctionInvoker::executeNodeEnterScript(CCScriptHandlerEntry *pEntry, CCNode *pNode)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString("Enter");
    pLuaStack->pushCCObject(pNode, "CCNode");
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 2);

    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }

}


void CLuaScriptFunctionInvoker::executeNodeExitScript(CCScriptHandlerEntry *pEntry, CCNode *pNode)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString("Exit");
    pLuaStack->pushCCObject(pNode, "CCNode");
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 2);


    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
}


void CLuaScriptFunctionInvoker::executeTransitionStartScript(CCScriptHandlerEntry *pEntry, CCNode *pNode)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);

    pLuaStack->pushString("TransitionStart");
    pLuaStack->pushCCObject(pNode, "CCNode");
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 2);


    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
}


void CLuaScriptFunctionInvoker::executeTransitionFinishScript(CCScriptHandlerEntry *pEntry, CCNode *pNode)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);

    pLuaStack->pushString("TransitionFinish");
    pLuaStack->pushCCObject(pNode, "CCNode");
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 2);


    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
}

void CLuaScriptFunctionInvoker::executeEditBoxReturnScript(CCScriptHandlerEntry *pEntry, CCNode *pNode, const char *lpcszMyObjectType, const char *lpcszString)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString("EditBoxReturn");
    pLuaStack->pushCCObject(pNode,lpcszMyObjectType);
    pLuaStack->pushString(lpcszString);
    
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 3);

    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
    
}

void CLuaScriptFunctionInvoker::executeTabPageChangedScript(CCScriptHandlerEntry *pEntry, CCNode *pNode)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString("TabPageChanged");
    pLuaStack->pushCCObject(pNode, "CCNode");
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 2);

    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
}

void CLuaScriptFunctionInvoker::executeJoyStickCallback(cocos2d::CCScriptHandlerEntry *pEntry, float fRadian, float fRadius)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString("JoyStickCallBack");
    pLuaStack->pushFloat(fRadian);
    pLuaStack->pushFloat(fRadius);
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 3);

    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
}

void CLuaScriptFunctionInvoker::executeConnectionDisconnectedScript(cocos2d::CCScriptHandlerEntry *pEntry)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);

    pLuaStack->pushString("ConnectionDisconnected");
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 1);

    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
}

void CLuaScriptFunctionInvoker::executeJoyStickEnded(cocos2d::CCScriptHandlerEntry *pEntry)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString("JoyStickEnded");
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 1);

    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
}

bool CLuaScriptFunctionInvoker::executeDispatchEvent(int nHandler,const char *lpcszEventName, std::vector<SLuaEventArg *> *args)
{
    if( nHandler == 0 )
        return false;
    CCScriptEngineProtocol *pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
    if( pEngine == NULL )
        return false;
    CCLuaEngine *pLuaEngine = dynamic_cast<CCLuaEngine *>(pEngine);
    if( pLuaEngine == NULL )
        return false;
    CCLuaStack *pLuaStack = pLuaEngine->getLuaStack();
    if( pLuaStack == NULL )
        return false;


    lua_State *L = pLuaStack->getLuaState();
    int nStart = lua_gettop(L);
    
    pLuaStack->pushString(lpcszEventName);
    //
    int nArgCount = 1;
    if( args != NULL )
    {
        nArgCount += args->size();
        for( std::vector<SLuaEventArg *>::iterator it = args->begin();
            it != args->end(); it++ )
        {
            SLuaEventArg *pArg = *it;
            switch( pArg->argType )
            {
                case eLEAT_Int:
                    pLuaStack->pushInt(pArg->nIntValue);
                    break;
                case eLEAT_Number:
                    pLuaStack->pushFloat((float)pArg->dNumberValue);
                    break;
                case eLEAT_String:
                    pLuaStack->pushString(pArg->lpcszStringValue);
                    break;
            }
        }
    }
    bool bRet = pLuaStack->executeFunctionByHandler(nHandler, nArgCount) != 0;
    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", nHandler, __FUNCTION__, __LINE__);
    }
    return bRet;
}


bool CLuaScriptFunctionInvoker::executeDispatchEventTable(int nHandler, const char *lpcszEventName, std::map<std::string, SLuaEventArg> *args)
{
    if( nHandler == 0 )
        return false;
    CCScriptEngineProtocol *pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
    if( pEngine == NULL )
        return false;
    CCLuaEngine *pLuaEngine = dynamic_cast<CCLuaEngine *>(pEngine);
    if( pLuaEngine == NULL )
        return false;
    CCLuaStack *pLuaStack = pLuaEngine->getLuaStack();
    if( pLuaStack == NULL )
        return false;

    lua_State *L = pLuaStack->getLuaState();
    if( L == NULL )
        return false;

    int nStart = lua_gettop(L);
    
    bool isNil = (args == NULL);

    int nArgCount = 1;
    lua_pushstring(L, lpcszEventName);
    if( !isNil && !args->empty() )
    {
        nArgCount++;
        lua_newtable(L);
        for(std::map<std::string, SLuaEventArg>::iterator it = args->begin();
            it != args->end(); it++)
        {
            lua_pushstring(L, it->first.c_str());
            switch( it->second.argType )
            {
                case eLEAT_Int:
                    lua_pushinteger(L, it->second.nIntValue);
                    break;
                case eLEAT_Number:
                    lua_pushnumber(L, it->second.dNumberValue);
                    break;
                case eLEAT_String:
                    lua_pushstring(L, it->second.lpcszStringValue);
                    break;
            }
            lua_settable(L, -3);
        }
    }
    bool bRet = pLuaStack->executeFunctionByHandler(nHandler, nArgCount) != 0;
    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", nHandler, __FUNCTION__, __LINE__);
    }
    return bRet;
}

void CLuaScriptFunctionInvoker::executeHttpResponseCallback(int nHandler, cocos2d::extension::CCHttpResponse *pResponse)
{
    if( nHandler == 0 )
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
    int nStart = lua_gettop(L);
    
    pLuaStack->pushCCObject(pResponse, "CCHttpResponse");
    pLuaStack->executeFunctionByHandler(nHandler, 1);

    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", nHandler, __FUNCTION__, __LINE__);
    }
}

void CLuaScriptFunctionInvoker::executeRichTextScript(cocos2d::CCScriptHandlerEntry *pEntry, const char *lpcszActionName, const std::vector<std::string> *args)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);

    int nArgCount = 2;
    pLuaStack->pushString("RichTextBoxCallBack");
    pLuaStack->pushString(lpcszActionName);
    if( args != NULL && !args->empty() )
    {
        for( std::vector<std::string>::const_iterator it = args->begin();
            it != args->end(); it++ )
        {
            pLuaStack->pushString( (*it).c_str() );
            nArgCount++;
        }
    }
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), nArgCount);

    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }

}




void CLuaScriptFunctionInvoker::executeMemoryWarn(CCScriptHandlerEntry *pEntry, cocos2d::CCObject *myObject, const char *lpcszMyObjectType, float fPercent)
{
    if( pEntry == NULL || pEntry->getHandler() == 0 )
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
    int nStart = lua_gettop(L);

    pLuaStack->pushString("MemoryWarn");
    pLuaStack->pushCCObject(myObject, lpcszMyObjectType);
    pLuaStack->pushFloat(fPercent);
    pLuaStack->executeFunctionByHandler(pEntry->getHandler(), 3);
    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", pEntry->getHandler(), __FUNCTION__, __LINE__);
    }
}

const char *CLuaScriptFunctionInvoker::executeVersionCallback(int nHandler)
{
    if( nHandler == 0 )
        return NULL;
    CCScriptEngineProtocol *pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
    if( pEngine == NULL )
        return NULL;
    CCLuaEngine *pLuaEngine = dynamic_cast<CCLuaEngine *>(pEngine);
    if( pLuaEngine == NULL )
        return NULL;
    CCLuaStack *pLuaStack = pLuaEngine->getLuaStack();
    if( pLuaStack == NULL )
        return NULL;


    lua_State *L = pLuaStack->getLuaState();
    int nStart = lua_gettop(L);

    pLuaStack->executeFunctionByHandler(nHandler, 0);

    const char *ret = NULL;
    if (lua_isstring(L, -1))
    {
        ret = lua_tostring(L, -1);
    }
    int nEnd = lua_gettop(L);
    if( nEnd != nStart )
    {
        CCLOG("[%d] stack not the same. %s %d", nHandler, __FUNCTION__, __LINE__);
    }
    return ret;

}

//bool CLuaScriptFunctionInvoker::executeDispatchEventTable(int nHandler, const char *lpcszEventName, int nTable)
//{
//    if( nHandler == 0 )
//        return false;
//    CCScriptEngineProtocol *pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
//    if( pEngine == NULL )
//        return false;
//    CCLuaEngine *pLuaEngine = dynamic_cast<CCLuaEngine *>(pEngine);
//    if( pLuaEngine == NULL )
//        return false;
//    CCLuaStack *pLuaStack = pLuaEngine->getLuaStack();
//    if( pLuaStack == NULL )
//        return false;
//
//    lua_State *L = pLuaStack->getLuaState();
//    if( L == NULL )
//        return false;
//
//    bool isNil = lua_isnil(L, -1);
//
//    std::map< std::string, SLuaEventArg > args;
//    if( !isNil && lua_istable(L, -1) )
//    {
//        int nStackTop = lua_gettop(L);
//        lua_pushnil(L);
//
//        while( lua_next(L, nStackTop) )
//        {
//            const char *lpKey = lua_tostring(L, -2);
//            if( lua_isstring(L, -1) )
//            {
//                SLuaEventArg arg( lua_tostring(L, -1) );
//                args[ lpKey ] = arg;
//            }
//            else if( lua_isnumber(L, -1) )
//            {
//                SLuaEventArg arg( lua_tonumber(L, -1) );
//                args[ lpKey ] = arg;
//            }
//            lua_pop(L, 1);
//        }
//    }
//
//    int nArgCount = 1;
//    lua_pushstring(L, lpcszEventName);
//    if( !isNil && !args.empty() )
//    {
//        nArgCount++;
//        lua_newtable(L);
//        for(std::map<std::string, SLuaEventArg>::iterator it = args.begin();
//            it != args.end(); it++)
//        {
//            lua_pushstring(L, it->first.c_str());
//            switch( it->second.argType )
//            {
//                case eLEAT_Int:
//                    lua_pushinteger(L, it->second.nIntValue);
//                    break;
//                case eLEAT_Number:
//                    lua_pushnumber(L, it->second.dNumberValue);
//                    break;
//                case eLEAT_String:
//                    lua_pushstring(L, it->second.lpcszStringValue);
//                    break;
//            }
//            lua_settable(L, -3);
//        }
//    }
//    return pLuaStack->executeFunctionByHandler(nHandler, nArgCount) != 0;
//
//}
//
