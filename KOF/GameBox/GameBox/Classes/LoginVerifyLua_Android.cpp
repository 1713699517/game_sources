#include "cocos2d.h"

#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "LoginVerifyLua.h"

#include "Constant.h"

#include "platform/android/jni/JniHelper.h"
#include <jni.h>
#include "../GameEngine/LuaClassSupport.h"
#include "GameUpdateScene.h"

USING_NS_CC;

void LUA_EXECUTE_COMMAND(int nCommand)
{
    if( nCommand == 12 )    //百度Android
    {
#if (AGENT_SDK_CODE == 12)
        JniMethodInfo methodInfo;
        if( JniHelper::getStaticMethodInfo(methodInfo, "com/haowan123/kof/bd/GameBox", "dkAccountManager", "()V") )
        {
            methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID );
        }
        else
        {
            CCLOG("GameBox::openDKAccountManager method missed!");
        }
#endif
    }
    else if( nCommand == 2 ) //360Android
    {
#if (AGENT_SDK_CODE == 2)
        JniMethodInfo methodInfo;
        if( JniHelper::getStaticMethodInfo(methodInfo, "com/haowan123/kof/qh/GameBox", "doSdkAccountManager", "()V") )
        {
            methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID );
        }
        else
        {
            CCLOG("GameBox::doSdkAccountManager method missed!");
        }
#endif
    }

    if( nCommand == 84 )
    {

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

        lua_getglobal(L, "g_resetAll");
        lua_call(L, 0, 1);
        lua_pop(L, 1);
        CCLOG("LLLLLLLL");
        
//        CCScriptEngineManager::sharedManager()->removeScriptEngine();
//        CCLOG("84-2");
//        CCLuaEngine *pEngine = CCLuaEngine::defaultEngine();
//        CCLOG("84-3");
//        CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);
//        CCLOG("84-4");
//        ptola::script::CLuaClassSupport::initialize(pEngine);
        //        CCLOG("84-5");
        CCDirector *pDirector = CCDirector::sharedDirector();
        CCLOG("84-1");
        int nLevelLimit = CCUserDefault::sharedUserDefault()->getIntegerForKey("LevelResource", 0);

        CCLOG("84-6");

        pDirector->popToRootScene();

        CCLOG("84-7");
        CCScene *pUpdateScene = CGameUpdateScene::scene(nLevelLimit);
        CCLOG("84-8 %d", pUpdateScene);
        pDirector->pushScene(pUpdateScene);

        CCLOG("84-9");
        pDirector->setShowBundleVersion(true);
        CCLOG("84-10");
    }
    CCLOG("EXECUTE_LUA_COMMAND: %d", nCommand);
    
    return;
}
#endif