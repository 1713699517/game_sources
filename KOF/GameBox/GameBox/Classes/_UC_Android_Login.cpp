//
//  Login.cpp
//  GameBox
//
//  Created by Mac on 13-12-6.
//
//


#include "Device.h"
#include "CCCrypto.h"
#include "MD5Crypto.h"
#include "DateTime.h"
#include "json.h"
#include "Application.h"
#include "LoginHttpApi.h"
#include "cocos-ext.h"
#include "AWebView.h"

#include "RechargeScene.h"

#include "UserCache.h"
#include "ptola.h"
#include "_UC_Android_Login.h"

#if (AGENT_SDK_CODE == 10)

using namespace ptola;
using namespace ptola::gui;

bool UC_Android_Login::init()
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

CCScene *UC_Android_Login::scene()
{
    CCScene *pScene = CCScene::create();
    if( pScene != NULL )
    {
        UC_Android_Login *pLogin = UC_Android_Login::create();
        if( pLogin != NULL )
        {
            pScene->addChild(pLogin);
        }
        else
        {
            CC_SAFE_DELETE(pScene);
        }
    }
    return pScene;
}

#endif