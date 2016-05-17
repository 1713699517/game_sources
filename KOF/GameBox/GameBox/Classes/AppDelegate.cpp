#include "cocos2d.h"
#include "AppDelegate.h"
#include "SimpleAudioEngine.h"
#include "script_support/CCScriptSupport.h"
#include "CCLuaEngine.h"
#include "LuaClassSupport.h"
#include "Device.h"
#include "Application.h"
#include "NotificationConstant.h"

#include "TestScene.h"
#include "GameUpdateScene.h"
//#include "HttpClientTest.h"
#include "LoginHttpApi.h"
#include "ptola.h"

#include "UUID.h"
#include "TcpClient.h"

#include "_APP_IOS_IAP.h"

#include "VideoPlatform.h"
#include "Launcher.h"
using namespace cocos2d;

USING_NS_CC;
using namespace CocosDenshion;
using namespace ptola;
using namespace ptola::network;
using namespace ptola::gui;

AppDelegate::AppDelegate()
{
    // fixed me
    //_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF|_CRTDBG_LEAK_CHECK_DF);
}

AppDelegate::~AppDelegate()
{
    // end simple audio engine here, or it may crashed on win32
    SimpleAudioEngine::sharedEngine()->end();
    //CCScriptEngineManager::purgeSharedManager();
}

bool AppDelegate::applicationDidFinishLaunching()
{

    CDevice *pDevice = CDevice::sharedDevice();
    pDevice->setDeviceSupportOrientation(LandscapeLeft|LandscapeRight);

    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    CCEGLView *pOpenGLView = CCEGLView::sharedOpenGLView();
    pDirector->setOpenGLView(pOpenGLView);

    CApplication *pApp = CApplication::sharedApplication();
    const char *lpcszResourcePath = pApp->getResourcePath();
    // adapter any size

    CCSize deviceScreenSize = pDirector->getWinSize();
    float fHeight = deviceScreenSize.height;
    float fRatio = deviceScreenSize.width / fHeight;


    if( !pDevice->isPad() )     //640
    {
        fHeight = 640.0f;
        pDevice->setCodeSizeRatio(1.0f);

        std::vector<std::string> searchPaths;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
        char szSearchPath[1024];
        sprintf(szSearchPath,"%s%s", lpcszResourcePath, "Image@640/");
        searchPaths.push_back(szSearchPath);
        sprintf(szSearchPath,"%s060/%s", lpcszResourcePath, "Image@640/");
        searchPaths.push_back(szSearchPath);
        searchPaths.push_back(lpcszResourcePath);
        searchPaths.push_back("Image@640/");
        searchPaths.push_back("");
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        char szSearchPath[1024];
        sprintf(szSearchPath,"%s%s", lpcszResourcePath, "Image@640/");
        searchPaths.push_back(szSearchPath);
        sprintf(szSearchPath,"%s060/%s", lpcszResourcePath, "Image@640/");
        searchPaths.push_back(szSearchPath);
        searchPaths.push_back(lpcszResourcePath);
        searchPaths.push_back("Image@640/");
        searchPaths.push_back("");
#endif
        CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);
    }
    else    //768
    {
        fHeight = 768.0f;
        pDevice->setCodeSizeRatio(1.2f);

        std::vector<std::string> searchPaths;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
        char szSearchPath[1024];
        sprintf(szSearchPath,"%s%s", pApp->getResourcePath(), "Image@768/");
        searchPaths.push_back(szSearchPath);
        sprintf(szSearchPath,"%s060/%s", pApp->getResourcePath(), "Image@768/");
        searchPaths.push_back(szSearchPath);
        searchPaths.push_back(lpcszResourcePath);
        searchPaths.push_back("Image@768/");
        searchPaths.push_back("");
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        char szSearchPath[1024];
        sprintf(szSearchPath,"%s%s", pApp->getResourcePath(), "Image@768/");
        searchPaths.push_back(szSearchPath);
        sprintf(szSearchPath,"%s060/%s", pApp->getResourcePath(), "Image@768/");
        searchPaths.push_back(szSearchPath);
        searchPaths.push_back(lpcszResourcePath);
        searchPaths.push_back("Image@768/");
        searchPaths.push_back("");
#endif
        CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);
    }

    //

    CCLOG("search path begin");
    for(std::vector<std::string>::const_iterator it = CCFileUtils::sharedFileUtils()->getSearchPaths().begin();
        it != CCFileUtils::sharedFileUtils()->getSearchPaths().end(); it++)
    {
        CCLOG("%s", (*it).c_str() );
    }
    CCLOG("search path end");

    //
    pOpenGLView->setDesignResolutionSize((fHeight * fRatio), fHeight, kResolutionShowAll);

    //
    // turn on display FPS
    pDirector->setDisplayStats(false);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);



    //ptola::CDevice *pDevice = ptola::CDevice::sharedDevice();
    //CCSize s = pDevice->getScreenSize();
    // register lua engine
    CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);
    ptola::script::CLuaClassSupport::initialize(pEngine);


    ///sdk request&&http request begin
    //////////////////////////////////////////////
//    ÷;
    //////////////////////////////////////////////

    //    CCScene *pScene = CCScene::create();
//    HttpClientTest *pLayer = new HttpClientTest();
//    pScene->addChild(pLayer);
//    pDirector->runWithScene(pScene);

//    CCScene *pScene = TestScene::scene();
//    pDirector->runWithScene(pScene);

//    CCScene *pScene = CLoginScene::scene();
//    pDirector->runWithScene(pScene);

//    CCScene *pSdkScene = C553_SDK::scene();
//    pDirector->runWithScene(pSdkScene);

    //IAPP_IOS_IAP iap;

//    CAPP_IOS_IAP cap;
//    cap.initialize(NULL);
    
    CCScene *pScene = CCScene::create();
    CCDirector::sharedDirector()->runWithScene(pScene);
    
    
    char vedioName[64] = "piantou.mp4";
    VideoPlatform::playVedio(vedioName);
    
    return true;
}


//static bool s_bNetworkConnected = false;

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
//    s_bNetworkConnected = CTcpClient::sharedTcpClient()->isConnected();
    CCDirector::sharedDirector()->stopAnimation();
    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
    SimpleAudioEngine::sharedEngine()->pauseAllEffects();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();
    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
    SimpleAudioEngine::sharedEngine()->resumeAllEffects();
//    if( s_bNetworkConnected )
//    {   // disconnected, post a disconnect message
//        if( !CTcpClient::sharedTcpClient()->isConnected() )
//        {
//            CCNotificationCenter::sharedNotificationCenter()->postNotification(NOTIFYCONST_NETWORK_DISCONNECT_MESSAGE);
//        }
//    }
}

void AppDelegate::goUpdateScene()
{
    CCDirector *pDirector = CCDirector::sharedDirector();
    int nLevelLimit = CCUserDefault::sharedUserDefault()->getIntegerForKey("LevelResource", 0);
    CCScene *pUpdateScene = CGameUpdateScene::scene(nLevelLimit);
    pDirector->runWithScene(pUpdateScene);
    
    pDirector->setShowBundleVersion(true);
}
