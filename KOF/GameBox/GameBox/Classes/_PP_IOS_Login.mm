//
//  _PP_IOS_Login.cpp
//  GameBox
//
//  Created by Caspar on 13-9-27.
//
//

#include "_PP_IOS_Login.h"

#if(AGENT_SDK_CODE == 5)
#import "RootViewController.h"
#import <PPAppPlatformKit/PPAppPlatformKit.h>

bool CPP_IOS_Login::init()
{
    if( !CCLayer::init() )
        return false;
    //[[RootViewController sharedInstance] view]

    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    CCSprite *pBackground = CCSprite::create("Loading/loading2_underframe.jpg");
    pBackground->setPosition(ccp(visibleSize.width/2, visibleSize.height/2));
    addChild(pBackground);
    
    [[PPAppPlatformKit sharedInstance] setAppId:1699 AppKey:@"da020d7a96177964296c26234d7ba855"];
    [[PPAppPlatformKit sharedInstance] setIsNSlogData:YES];
    [[PPAppPlatformKit sharedInstance] setRechargeAmount:10];
    [[PPAppPlatformKit sharedInstance] setIsLongComet:YES];
    [[PPAppPlatformKit sharedInstance] setIsLogOutPushLoginView:YES];
    [[PPAppPlatformKit sharedInstance] setIsOpenRecharge:NO];
    [[PPAppPlatformKit sharedInstance] setCloseRechargeAlertMessage:@"关闭充值提示语"];
    [PPUIKit sharedInstance];

    return true;
}

CCScene *CPP_IOS_Login::scene()
{
    CCScene *pScene = CCScene::create();
    if( pScene != NULL )
    {
        CPP_IOS_Login *pLogin = CPP_IOS_Login::create();
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