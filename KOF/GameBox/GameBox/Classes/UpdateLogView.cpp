//
//  UpdateLogView.cpp
//  GameBox
//
//  Created by Caspar on 13-10-22.
//
//

#include "UpdateLogView.h"
#include "Device.h"
#include "Constant.h"
#include "Application.h"
#include "LoginVerifyLua.h"
#include "GameUpdateScene.h"

CUpdateLogView::CUpdateLogView()
: m_pWebView(NULL)
{

}

CUpdateLogView::~CUpdateLogView()
{
    if(m_pWebView != NULL)
    {
        removeChild( m_pWebView, true );
    }
    
    CCTexture2D *r = CCTextureCache ::sharedTextureCache()->textureForKey("loginResources/signs_word_yxgxgg.png");
    if (r != NULL)
    {
        CCSpriteFrameCache ::sharedSpriteFrameCache()->removeSpriteFramesFromTexture(r);
        CCTextureCache ::sharedTextureCache()->removeTexture(r);
        r = NULL;
    }
    
//    CC_SAFE_RELEASE_NULL(m_pWebView);
}


void __getUrl(char *lpszUrl)
{
    strcpy(lpszUrl, "http://");
    strcat(lpszUrl, SDK_HOST);
    strcat(lpszUrl, "/api/PhoneSDK/UpdateLogs");

    //cid
    strcat(lpszUrl, "?cid=");
    strcat(lpszUrl, CID_w_217);
    //os
    strcat(lpszUrl, "&os=");
#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    strcat(lpszUrl, "iOS");
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    strcat(lpszUrl, "Android");
#endif
    //source
    strcat(lpszUrl, "&source=");
    strcat(lpszUrl, SDK_SOURCE_FROM);
    //source_sub
    strcat(lpszUrl, "&source_sub=");
    strcat(lpszUrl, SDK_SOURCE_SUB_FROM);
    
    //versions
    strcat(lpszUrl, "&versions=");
    strcat(lpszUrl, CApplication::sharedApplication()->getBundleVersion());
    strcat(lpszUrl, ",");
    strcat(lpszUrl, LUA_GET_VERSION());
}


CUpdateLogView* CUpdateLogView::create(CGameUpdateScene *updataScene,bool isUpdate)
{
    CUpdateLogView* pRet = new CUpdateLogView();
    if(pRet&&pRet->init(updataScene,isUpdate))
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        delete pRet;
        pRet=NULL;
        return NULL;
    }
}


bool CUpdateLogView::init(CGameUpdateScene *updataScene,bool isUpdate)
{
    m_updataScene = updataScene;
    m_isUpdate    = isUpdate;
    
    if( !CContainer::init() )
        return onInitialized(false);

    CCSize winSize = CCDirector::sharedDirector()->getVisibleSize();

    CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("General.plist");
    CSprite *pBackground = CSprite::createWithSpriteFrameName("general_first_underframe.png", CCRectMake(75.0f, 75.0f, 25.0f, 25.0f));

    pBackground->setPreferredSize(CCSizeMake(600,500));
    pBackground->setPosition(ccp(winSize.width/2.0f+30.0f, winSize.height/2.0f + 50.0f));

    addChild(pBackground);
    
    CSprite *pTitleImg = CSprite::create("loginResources/signs_word_yxgxgg.png");
    pTitleImg->setControlName("this CUpdateLogView pTitleImg 81");
    pTitleImg->setPosition(ccp( winSize.width/2.0f+30.0f, winSize.height/2.0f + 255 ));
    addChild(pTitleImg);

    //webView
    CCSize screenSize = CDevice::sharedDevice()->getScreenSize();

    m_pWebView = CWebView::create();
    CCSize mySize;
#if( CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    mySize = CCSizeMake(screenSize.height, screenSize.width);
#elif( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    mySize = CCSizeMake(screenSize.width, screenSize.height);
#endif
    CCSize bgSize   = pBackground->getPreferredSize();
    CCSize viewSize = CCSizeMake(mySize.width / winSize.width * (bgSize.width-40) , mySize.height / 640 * bgSize.height*0.68f);
    
    m_pWebView->setPreferredSize(viewSize);
    m_pWebView->setPosition(ccp( mySize.width/2-viewSize.width/2+30.0f/winSize.width*mySize.width,100.0f/winSize.height*mySize.height ));
    
    addChild(m_pWebView);
    
    
    //添加 进入按钮 
    m_pGoInBtn = CButton::createWithSpriteFrameName("进入游戏", "general_button_normal.png");
    CCSize buttonSize = m_pGoInBtn->getPreferredSize();
    m_pGoInBtn->setPosition(ccp(winSize.width/2.0f+30.0f,winSize.height*0.25f));
    m_pGoInBtn->addEventListener("TouchBegan", this, eventhandler_selector(CUpdateLogView::onBeganTouchGoInButton));
    addChild(m_pGoInBtn);
    
    char szUrl[1024];
    __getUrl(szUrl);
    m_pWebView->loadGet(szUrl);
    if(m_isUpdate)
    {
        m_pGoInBtn->setTouchesEnabled( false );
        
        m_pWebView->loadGet(szUrl, NULL, NULL, 0U, this , eventhandler_selector(CUpdateLogView::onUpdateLogLoaded));
        CCLOG(" CUpdateLogView   %s",szUrl);
    }

    

    
    
    return onInitialized(true);
}

void CUpdateLogView::onUpdateLogLoaded(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    m_updataScene->continueUpdate();
}

void CUpdateLogView::endUpdata()
{
    m_pGoInBtn->setTouchesEnabled(true);
}

void CUpdateLogView::onBeganTouchGoInButton(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("GoToGame form CUpdateLogView");
    
    m_updataScene->scheduleOnce(schedule_selector(CGameUpdateScene::updataEndBtnCallBack), 0.01);
    
}