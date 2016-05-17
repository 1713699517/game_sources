//
//  _553_Android_Login.cpp
//  GameBox
//
//  Created by Caspar on 13-9-25.
//
//

#include "_553_Android_Login.h"

#if (AGENT_SDK_CODE == 4)

#include "UserCache.h"
#include "DateTime.h"
#include "Device.h"
#include "Application.h"
#include "ptola.h"

#include "LoginHttpApi.h"
#include "AWebView.h"

using namespace ptola;
using namespace ptola::gui;

bool C553_Android_Login::init()
{
    if( !CCLayer::init() )
        return false;

    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    CCSprite *pBackground = CCSprite::create("Loading/loading2_underframe.jpg");
    pBackground->setPosition(ccp(visibleSize.width/2, visibleSize.height/2));
    addChild(pBackground);


    const char *_account = CUserCache::sharedUserCache()->getObject("userName");
    CCLOG("accountName = %s", _account);
    CDateTime nowTime;
    int nLocalTime          = nowTime.getTotalSeconds();
    char szLocalTime[32]    = {0};
    sprintf(szLocalTime, "%d", nLocalTime);


    std::string strSessionId = CCUserDefault::sharedUserDefault()->getStringForKey("sid", "");
    const char *lpcszSessionId  = strSessionId.c_str();
    
    CDefaultLoginBehavior *pSender = new CDefaultLoginBehavior;
    pSender->autorelease();

    CLoginHttpApi::setInternalVerify(true);

    CLoginHttpApi::httpVerify( CID_w_217, CWebView::urlEncode(_account), CDevice::sharedDevice()->getMAC(), CApplication::sharedApplication()->getBundleVersion(),
                              "Android", SDK_SOURCE_FROM, SDK_SOURCE_SUB_FROM, szLocalTime,
                              PRIVATEKEY_W_217, lpcszSessionId, pSender, callfuncND_selector(CDefaultLoginBehavior::defaultHttpVerify) );

    return true;
}

CCScene *C553_Android_Login::scene()
{
    C553_Android_Login *pLayer = C553_Android_Login::create();
    if( pLayer != NULL )
    {
        CCScene *pScene = CCScene::create();
        if( pScene != NULL )
        {
            pScene->addChild(pLayer);
            return pScene;
        }
        CC_SAFE_DELETE(pLayer);
        return NULL;
    }
    return NULL;
}

#endif