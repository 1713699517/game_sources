//
//  _553_Recharge.cpp
//  GameBox
//
//  Created by Caspar on 13-8-26.
//
//

#include "_553_Recharge.h"

#if (AGENT_SDK_CODE == 1 || AGENT_SDK_CODE == 4 )

#include "Device.h"
#include "CCCrypto.h"
#include "MD5Crypto.h"
#include "DateTime.h"
#include "json.h"
#include "Application.h"
#include "LoginHttpApi.h"
#include "Sprite.h"
#include "AWebView.h"


#include "RechargeScene.h"
#include "UUID.h"

using namespace cocos2d;
using namespace ptola::gui;
using namespace ptola;

C553_Recharge::C553_Recharge()
{

}

bool C553_Recharge::init()
{
    if( !CCNode::init() )
        return false;

    CCSize portaitDeviceSize = CDevice::sharedDevice()->getScreenSize();

    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();


    CSprite *m_background = CSprite::createWithSpriteFrameName("peneral_background.jpg");
    m_background->setPreferredSize(visibleSize);
    m_background->setPosition(ccp(visibleSize.width/2, visibleSize.height/2));
    addChild(m_background);


    m_pWebView = CWebView::create();
    m_pWebView->setOverrideCallBack(this, (LP_OVERRIDE_WEBVIEW_URL_CALLBACK)(&C553_Recharge::shouldOverrideUrl));


#if( CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    m_pWebView->setPreferredSize(CCSizeMake(portaitDeviceSize.height * 0.9,portaitDeviceSize.width - 40));
    m_pWebView->setPosition(ccp(portaitDeviceSize.height * 0.05, 30));
#elif( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    m_pWebView->setPreferredSize(CCSizeMake(portaitDeviceSize.width * 0.9,portaitDeviceSize.height - 70));
    m_pWebView->setPosition(ccp(portaitDeviceSize.width * 0.05, 60));
#endif
    char szUrl[1024] = {0};
    getUrl( szUrl, 1024);
    CCLOG("recharge url=%s", szUrl);
    m_pWebView->loadGet(szUrl);
    addChild(m_pWebView);

    m_pCloseButton = CButton::createWithSpriteFrameName("返回游戏", "general_button_normal.png");
    CCSize buttonSize = m_pCloseButton->getPreferredSize();
    m_pCloseButton->setPosition(ccp(visibleSize.width - buttonSize.width / 2,visibleSize.height - buttonSize.height / 2));
    m_pCloseButton->addEventListener("TouchBegan", this, eventhandler_selector(C553_Recharge::onBeganTouchCloseButton));
    addChild(m_pCloseButton);
    return true;
}


void C553_Recharge::getUrl(char *lpszUrl, size_t uLength)
{
    strcpy(lpszUrl, AGENT_553_SDK_RECHARGE_HOST);
    strcat(lpszUrl, "?username=");
    const char *userName = CRechargeScene::getRechargeData("username");
    if( userName != NULL )
    {
        strcat(lpszUrl, CWebView::urlEncode(userName));
    }
    strcat(lpszUrl, "&serverid=74&userdata=");

    const char *serverid = CRechargeScene::getRechargeData("serverid");
    if( serverid != NULL )
    {
        strcat(lpszUrl, serverid);
    }
    strcat(lpszUrl, ",");

    const char *uuid = CUUID::create();
    if( uuid != NULL )
    {
        strcat(lpszUrl, uuid);
    }
    strcat(lpszUrl, ",");

    const char *roleid = CRechargeScene::getRechargeData("roleid");
    if( roleid != NULL )
    {
        strcat(lpszUrl, roleid);
    }

    strcat(lpszUrl, "&fid=211000");
}


bool C553_Recharge::shouldOverrideUrl(const char *lpcszUrl)
{
    return false;
}

void C553_Recharge::onBeganTouchCloseButton(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("Recharge Closed");
    removeChild(m_pWebView, true);
    CCDirector::sharedDirector()->popScene();
}

#endif