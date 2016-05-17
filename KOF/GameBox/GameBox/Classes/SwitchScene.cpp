//
//  SwitchScene.cpp
//  GameBox
//
//  Created by wrc on 13-8-30.
//
//

#include "SwitchScene.h"

#include "_553_SDK.h"
#include "_553_Login.h"


#include "Mi_Login.h"

#include "LoginHttpApi.h"


CSwitchScene::CSwitchScene()
{

}

CSwitchScene::~CSwitchScene()
{

}

bool CSwitchScene::init()
{
    if( !CCLayer::init() )
        return false;
    ;

    CCControlButton *_pInternalBtn = CCControlButton::create("内网登陆", "Arial", 30.0f);
    _pInternalBtn->setPosition(ccp(100.0f, 450.0f));
    _pInternalBtn->addTargetWithActionForControlEvents(this, cccontrol_selector(CSwitchScene::__internalhandle), CCControlEventTouchDown);
    addChild(_pInternalBtn);
    
    CCControlButton *_p553Btn = CCControlButton::create("7pk登陆", "Arial", 30.0f);
    _p553Btn->setPosition(ccp(100.0f, 280.0f));
    _p553Btn->addTargetWithActionForControlEvents(this, cccontrol_selector(CSwitchScene::__sdkhandle), CCControlEventTouchDown);
    addChild(_p553Btn);

    return true;
}

void CSwitchScene::__sdkhandle(cocos2d::CCObject *pObject, CCControlEvent event)
{
#if (AGENT_SDK_CODE == 1 || AGENT_SDK_CODE == 3)
    CCScene *pScene = C553_Login::scene();
    CLoginHttpApi::setInternalVerify(false);
    CCDirector::sharedDirector()->replaceScene(pScene);
#endif
}

void CSwitchScene::__internalhandle(cocos2d::CCObject *pObject, CCControlEvent event)
{
#if (AGENT_SDK_CODE == 1 || AGENT_SDK_CODE == 3)
    CCScene *pScene = C553_Login::scene();
    CLoginHttpApi::setInternalVerify(true);
    CCDirector::sharedDirector()->replaceScene(pScene);

#endif
}

CCScene *CSwitchScene::scene()
{
    CSwitchScene *pLayer = CSwitchScene::create();
    if( pLayer != NULL )
    {
        CCScene *pScene = CCScene::create();
        if( pScene != NULL )
        {
            pScene->addChild(pLayer);
        }
        return pScene;
    }
    else
    {
        return NULL;
    }
}