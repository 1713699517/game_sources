//
//  LuaScriptFunctionInvoker.h
//  GameBox
//
//  Created by Caspar on 13-5-7.
//
//

#ifndef __GameBox__LuaScriptFunctionInvoker__
#define __GameBox__LuaScriptFunctionInvoker__

#include "CCLuaEngine.h"
#include "LuaEventDispatcher.h"
#include "HttpResponse.h"
#include <vector>

USING_NS_CC;
using namespace ptola::event;

namespace ptola
{

namespace script
{
    class CLuaScriptFunctionInvoker
    {
    public:
        static bool executeTouchScript(CCScriptHandlerEntry *pEntry, const char *lpcszTouchType, CCObject *myObject, const char *lpcszMyObjectType, float fTouchX, float fTouchY);
        
        static bool executeTouchesScript(CCScriptHandlerEntry *pEntry, const char *lpcszTouchesType, CCObject *myObject, const char *lpcszMyObjectType, CCSet *pTouches);

        static void executeAnimationCompleteScript(CCScriptHandlerEntry *pEntry, const char *lpcszAnimationName);

        static void executeConnectionDisconnectedScript(CCScriptHandlerEntry *pEntry);

        static void executeLoadScript(CCScriptHandlerEntry *pEntry, CCNode *pNode);

        static void executeNodeEnterScript(CCScriptHandlerEntry *pEntry, CCNode *pNode);

        static void executeNodeExitScript(CCScriptHandlerEntry *pEntry, CCNode *pNode);

        static void executeTransitionFinishScript(CCScriptHandlerEntry *pEntry, CCNode *pNode);

        static void executeTransitionStartScript(CCScriptHandlerEntry *pEntry, CCNode *pNode);

        static void executeTabPageChangedScript(CCScriptHandlerEntry *pEntry, CCNode *pNode);
        static void executePageScrolledScript(CCScriptHandlerEntry *pEntry, CCObject *myObject, const char *lpcszMyObjectType, int nPage);

        static void executeJoyStickCallback(CCScriptHandlerEntry *pEntry, float fRadian, float fRadius);
        static void executeJoyStickEnded(CCScriptHandlerEntry *pEntry);
        
        static bool executeDispatchEvent(int nHandler, const char *lpcszEventName, std::vector<SLuaEventArg *> *args);

        static bool executeDispatchEventTable(int nHandler, const char *lpcszEventName, std::map<std::string, SLuaEventArg> *args);

        static void executeHttpResponseCallback(int nHandler, cocos2d::extension::CCHttpResponse *pResponse);

        static void executeEditBoxReturnScript(CCScriptHandlerEntry *pEntry, CCNode *pNode, const char *lpcszMyObjectType, const char *lpcszString);

        static void executeRichTextScript(CCScriptHandlerEntry *pEntry, const char *lpcszActionName, const std::vector<std::string> *args);

        static void executeMemoryWarn(CCScriptHandlerEntry *pEntry, CCObject *myObject, const char *lpcszMyObjectType, float fPercent);

        static const char *executeVersionCallback(int nHandler);

    };
}

}

#endif /* defined(__GameBox__LuaScriptFunctionInvoker__) */
