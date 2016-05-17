//
//  _APP_Login.cpp
//  GameBox
//
//  Created by Mac on 13-12-4.
//
//


#include "_APP_Login.h"

#if (AGENT_SDK_CODE == 3)

#include "Device.h"
#include "CCCrypto.h"
#include "MD5Crypto.h"
#include "DateTime.h"
#include "json.h"
#include "Application.h"
#include "LoginHttpApi.h"
#include "cocos-ext.h"
#include "AWebView.h"
#include "UserCache.h"
#include "RechargeScene.h"
#include "GameUpdateScene.h"

#include "Sprite.h"
#include "ILabel.h"
#include "EditBox.h"
#include "CheckBox.h"

using namespace ptola;
using namespace cocos2d::extension;
using namespace Json;

CAPP_Login *CAPP_Login::instance = NULL;

CAPP_Login::CAPP_Login():
m_pContainer(NULL),
m_pwebViewCloseBtn(NULL),
m_pWebView(NULL)
{
    instance = this;
}

CAPP_Login::~CAPP_Login()
{
    if(m_pWebView!=NULL)
    {
        removeChild(m_pWebView);
        m_pWebView = NULL;
    }
}

CCScene *CAPP_Login::scene()
{
    CCScene *pScene = CCScene::create();
    if( pScene != NULL )
    {
        CAPP_Login *pLogin = CAPP_Login::create();
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

bool CAPP_Login :: init()
{
    if( !CCLayer::init() )
        return false;
    //背景图
    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    CCSprite *pBackground = CCSprite::create("AppLoginResource/account_background.jpg");
    pBackground->setPosition(ccp(visibleSize.width/2, visibleSize.height/2));
    addChild(pBackground);
    
    CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("AppLoginResource/AppLoginResource.plist");
    CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("General.plist");
    //界面容器    
    m_pContainer = CContainer::create();
    addChild(m_pContainer);
    //底图拼接
    CSprite *up_line   = CSprite::createWithSpriteFrameName("account_line.png");
    CSprite *line_back = CSprite::createWithSpriteFrameName("account_underframe2.png");
    CSprite *down_line = CSprite::createWithSpriteFrameName("account_line.png");
    
    float backdownSize = 80.0f;
    line_back -> setPreferredSize(CCSizeMake(visibleSize.width, backdownSize*2));
    CCSize line_backSize = line_back -> getPreferredSize();
    
    up_line->setPosition(ccp(visibleSize.width/2, visibleSize.height/2-backdownSize));
    line_back->setPosition(ccp(visibleSize.width/2, visibleSize.height/2-line_backSize.height/2-backdownSize));
    down_line->setPosition(ccp(visibleSize.width/2, visibleSize.height/2-line_backSize.height-backdownSize));
    m_pContainer->addChild(up_line);
    m_pContainer->addChild(line_back);
    m_pContainer->addChild(down_line);
    
    //登录 注册按钮
    CButton *RegistBtn  = CButton :: createWithSpriteFrameName("","account_button.png");
    CButton *LoginBtn   = CButton :: createWithSpriteFrameName("","account_button.png");
    CSprite *RegistName = CSprite::createWithSpriteFrameName("account_word_zc.png");
    CSprite *LoginName  = CSprite::createWithSpriteFrameName("account_word_dl.png");
    
    float btndownSize = 100.0f;
    RegistBtn->setPosition(ccp(btndownSize, 0.0f));
    LoginBtn->setPosition(ccp(-btndownSize, 0.0f));

    line_back->addChild(RegistBtn);
    line_back->addChild(LoginBtn);
    RegistBtn->addChild(RegistName);
    LoginBtn->addChild(LoginName);
    
    //回调
    LoginBtn->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Login::init_onBeganTouchLoginBtn));
    RegistBtn->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Login::init_onBeganTouchRegistBtn));
    return true;
}

//初始页面的登录按钮回调
void CAPP_Login::init_onBeganTouchLoginBtn(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("LoginBtn CallBack");
    if (m_pContainer != NULL) {
        m_pContainer->removeFromParentAndCleanup(true);
        m_pContainer = NULL;
    }
    //去到登录界面
    CAPP_Login::LoginInit();
}
//初始页面的注册按钮回调
void CAPP_Login::init_onBeganTouchRegistBtn(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("LoginBtn CallBack");
    if (m_pContainer != NULL) {
        m_pContainer->removeFromParentAndCleanup(true);
        m_pContainer = NULL;
    }
    //去到注册界面
    CAPP_Login::RegistInit();
}
/*****************************登录页面*************************************************************/
bool CAPP_Login :: LoginInit()
{
    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    //界面容器
    m_pContainer = CContainer::create();
    addChild(m_pContainer);
    
    //底图
    CCSize EditBoxSize = CCSizeMake(250.0f, 50.0f);
    CSprite *LoginBackground            = CSprite::createWithSpriteFrameName("account_underframe.png");
    //输入框
    CCLabelTTF *AccountLabel  = CCLabelTTF :: create("输入账号", "Arial", 24);
    CCLabelTTF *PasswordLabel = CCLabelTTF :: create("输入密码", "Arial", 24);
    CCScale9Sprite *EditBoxBackground1  = CCScale9Sprite::createWithSpriteFrameName("account_underframe2.png");
    CCScale9Sprite *EditBoxBackground2  = CCScale9Sprite::createWithSpriteFrameName("account_underframe2.png");
    AccountEditBox   = CEditBox ::create (EditBoxSize,EditBoxBackground1,20,"",kEditBoxInputFlagSensitive);
    PasswordEditBox  = CEditBox ::create (EditBoxSize,EditBoxBackground2,20,"",kEditBoxInputFlagPassword);
    
    std::string strUserName = CCUserDefault::sharedUserDefault()->getStringForKey("APP_USER_NAME", "");
    AccountEditBox->setTextString(strUserName.c_str());
    
    //登录按钮
    CButton *LoginBtn  = CButton :: createWithSpriteFrameName("","account_button.png");
    CSprite *LoginName = CSprite::createWithSpriteFrameName("account_word_dl.png");
    //注册账号 忘记密码
    CButton *registBtn = CButton :: create("注册账号","transparent.png");
    CButton *forgetBtn = CButton :: create("密码服务","transparent.png");
    //记住账号
    CCheckBox *checkbox = CCheckBox ::create("LuckyResources/general_pages_normal.png", "LuckyResources/general_pages_pressing.png", "");
    CCLabelTTF *checkboxLabel  = CCLabelTTF :: create("记住账号", "Arial", 24);
    
    float editboxleftSize = 190.0f;
    LoginBackground -> setPreferredSize(CCSizeMake(590.0f,350.0f));
    registBtn -> setPreferredSize(CCSizeMake(110.0f,30.0f));
    forgetBtn -> setPreferredSize(CCSizeMake(110.0f,30.0f));
    registBtn->setFontSize(24);
    forgetBtn->setFontSize(24);
    checkbox->setFontSize(24);
    
    LoginBackground->setPosition(ccp(visibleSize.width/2, visibleSize.height/2));
    AccountEditBox ->setPosition(ccp(-20.0f, 120.0f));
    PasswordEditBox->setPosition(ccp(-20.0f, 40.0f));
    AccountLabel ->setPosition(ccp(-editboxleftSize-20.0f, 120.0f));
    PasswordLabel->setPosition(ccp(-editboxleftSize-20.0f, 40.0f));
    LoginBtn ->setPosition(ccp(editboxleftSize, 80.0f));
    registBtn ->setPosition(ccp(-80.0f,-20.0f));
    forgetBtn ->setPosition(ccp(60.0f,-20.0f));
    checkbox      ->setPosition(ccp(-120.0f,-80.0f));
    checkboxLabel ->setPosition(ccp(70.0f,0.0f));
    
    m_pContainer->addChild(LoginBackground);
    LoginBackground->addChild(AccountEditBox);
    LoginBackground->addChild(PasswordEditBox);
    AccountEditBox->addChild(AccountLabel);
    PasswordEditBox->addChild(PasswordLabel);
    LoginBackground->addChild(LoginBtn);
    LoginBtn->addChild(LoginName);
    LoginBackground->addChild(registBtn);
    LoginBackground->addChild(forgetBtn);
    LoginBackground->addChild(checkbox);
    checkbox->addChild(checkboxLabel);
    
    //回调
    LoginBtn->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Login::LoginInit_onBeganTouchLoginBtn));
    registBtn->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Login::LoginInit_onBeganTouchregistBtn));
    forgetBtn->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Login::LoginInit_onBeganTouchforgetBtn));
    return true ;
}

void CAppLoginBehavior::defaultHttpVerify(CCObject *pSender, void *pData)
{
    // CCHttpResponse *pResponse = (CCHttpResponse *)pData;
    // if( pResponse == NULL || !pResponse->isSucceed() )
    // {
    //     CCMessageBox("Response faild!", "Error!");
    //     CAPP_Login::getInstance()->LoginInit();
    //     return;
    // }
    // 
    // CCHttpRequest *pRequest = pResponse->getHttpRequest();
    // if( pRequest == NULL || strcmp(pRequest->getTag(), "Caspar_Login_Request") != 0)
    // {
    //     CCLOG("Response Tag Error!");
    //     CAPP_Login::getInstance()->LoginInit();
    //     return;
    // }
    // 
    // std::vector<char> *pResponseBuffer = pResponse->getResponseData();
    // std::string strBuffer( pResponseBuffer->begin(), pResponseBuffer->end() );
   
    // CCLOG(strBuffer.c_str());
    
    /*
    Json::Value retJson;
    Json::Reader jsonReader;
    if( jsonReader.parse(strBuffer.c_str(), retJson) )
    {
        int nRef = retJson["ref"].asInt();
        if( nRef == 1 )
        {
            CCDirector *pDirector = CCDirector::sharedDirector();
            int nLevelLimit = CCUserDefault::sharedUserDefault()->getIntegerForKey("LevelResource", 0);
            CCScene *pUpdateScene = CGameUpdateScene::scene(nLevelLimit);
            pDirector->pushScene(pUpdateScene);
        }
        else
        {
            CCMessageBox(retJson["msg"].asCString(), "login valid!");
            
            CAPP_Login::getInstance()->LoginInit();
        }
    }
    */
    Json::Value retJson;
    Json::Reader jsonReader;

    retJson["ref"] = Json::Value(1);
    retJson["account"] = Json::Value("aaa");
    string strBuffer = "[{\"ref\":\"1\",\"account\":\"aaa\",\"uuid\":\"110\"}]";

    CCLOG("json:%s", strBuffer.c_str());

    // if( jsonReader.parse(strBuffer.c_str(), retJson) )
    {
        CCLOG("jsonReader.parse:%d", retJson["ref"].asInt());
        int nRef = retJson["ref"].asInt();
        if( nRef == 1 )
        {
            
            for( Value::iterator it = retJson.begin(); it != retJson.end(); it++ )
            {
                const char *lpcszMemberName = it.memberName();
                if( strcasecmp(lpcszMemberName, "account") == 0 )
                {
                    CCUserDefault::sharedUserDefault()->setStringForKey("APP_USER_NAME", (*it).asCString());
                    CCUserDefault::sharedUserDefault()->flush();
                    CUserCache::sharedUserCache()->setObject("userName", (*it).asCString());
                    CRechargeScene::setRechargeData("username", (*it).asCString());
                }
            }
            
            CLoginHttpApi::httpVerifyCallBack(pSender, NULL);
        }
        else
        {
            CCMessageBox(retJson["msg"].asCString(), "login valid!");
            
            CAPP_Login::getInstance()->LoginInit();
        }
    }
}

void CAppRegisterBehavior::defaultHttpVerify(CCObject *pSender, void *pData)
{
    CCHttpResponse *pResponse = (CCHttpResponse *)pData;
    if( pResponse == NULL || !pResponse->isSucceed() )
    {
        CCMessageBox("Response faild!", "Error!");
        
        CAPP_Login::getInstance()->RegistInit();
        return;
    }
    
    CCHttpRequest *pRequest = pResponse->getHttpRequest();
    if( pRequest == NULL || strcmp(pRequest->getTag(), "Caspar_Login_Request") != 0)
    {
        CCLOG("Response Tag Error!");
        CAPP_Login::getInstance()->RegistInit();
        return;
    }
    
    std::vector<char> *pResponseBuffer = pResponse->getResponseData();
    std::string strBuffer( pResponseBuffer->begin(), pResponseBuffer->end() );
    
    CCLOG(strBuffer.c_str());
    
    /*
    Json::Value retJson;
    Json::Reader jsonReader;
    if( jsonReader.parse(strBuffer.c_str(), retJson) )
    {
        int nRef = retJson["ref"].asInt();
        if( nRef == 1 )
        {
           
        }
        else
        {
            CCMessageBox(retJson["msg"].asCString(), "register valid!");
            
            CAPP_Login::getInstance()->RegistInit();
        }
    }
    */
    
    Json::Value retJson;
    Json::Reader jsonReader;
    if( jsonReader.parse(strBuffer.c_str(), retJson) )
    {
        int nRef = retJson["ref"].asInt();
        if( nRef == 1 )
        {
            
            for( Value::iterator it = retJson.begin(); it != retJson.end(); it++ )
            {
                const char *lpcszMemberName = it.memberName();
                if( strcasecmp(lpcszMemberName, "account") == 0 )
                {
                    CUserCache::sharedUserCache()->setObject("userName", (*it).asCString());
                    CRechargeScene::setRechargeData("username", (*it).asCString());
                }
            }
        }
        else
        {
            CCMessageBox(retJson["msg"].asCString(), "register valid!");
            
            CAPP_Login::getInstance()->RegistInit();
        }
    }
    CLoginHttpApi::httpVerifyCallBack(pSender, pResponse);
}

void CAPP_Login::HttpLogin(std::string cid, int type, std::string account, std::string passwd, std::string session, std::string version,
                    std::string source, std::string source_sub, int time)
{
    char szLocalTime[32]    = {0};
    sprintf(szLocalTime, "%d", time + 10);
    
    char szUrl[1024]     = {0};
    
    sprintf(szUrl, APP_LOGIN_URL, SDK_HOST);
    
    //cid
    char szParams[1024]  = {0};
    char szParams2[1024] = {0};
    char szParam3[254] = {0};
    strcat(szParams, "cid=");
    strcat(szParams, cid.c_str());
    //type
    strcat(szParams, "&type=");
    sprintf(szParam3, "%d", type);
    strcat(szParams, szParam3);
    //account
    strcat(szParams, "&account=");
    strcat(szParams, account.c_str());
    //passwd
    strcat(szParams, "&passwd=");
    strcat(szParams, passwd.c_str());
    //session
    strcat(szParams, "&session=");
    strcat(szParams, session.c_str());
    //versions
    strcat(szParams, "&versions=");
    strcat(szParams, version.c_str());
    //os
    strcat(szParams, "&os=");
    strcat(szParams, "ios");
    //source
    strcat(szParams, "&source=");
    strcat(szParams, source.c_str());
    //source_sub
    strcat(szParams, "&source_sub=");
    strcat(szParams, source_sub.c_str());
    //time
    strcat(szParams, "&time=");
    strcat(szParams, szLocalTime);
    
    strcpy(szParams2, szParams);
    
    //key
    strcat(szParams, "&key=");
    strcat(szParams, PRIVATEKEY_W_217);
    
    std::string strSign = CMD5Crypto::md5(szParams, strlen(szParams));
    
    strcat(szParams2, "&sign=");
    strcat(szParams2, strSign.c_str());
    
    CAppLoginBehavior *pSender = new CAppLoginBehavior;
    pSender->autorelease();

    CCLOG("%s %s", szUrl, szParams2);
    strcat(szUrl, "?");
    strcat(szUrl, szParams2);
    // CCHttpRequest *pRequest = new CCHttpRequest();
    // pRequest->setUrl(szUrl);
    // pRequest->setRequestType(CCHttpRequest::kHttpPost);
    // //pRequest->setRequestData(szParams2, strlen(szParams2));
    // pRequest->setResponseCallback(pSender, callfuncND_selector(CAppLoginBehavior::defaultHttpVerify));
    // pRequest->setTag("Caspar_Login_Request");
    // CCHttpClient::getInstance()->send(pRequest);
    // pRequest->release();
    pSender->defaultHttpVerify(pSender, NULL);
}

void CAPP_Login::HttpRegister(std::string cid, std::string account, std::string passwd, std::string version,
                           std::string source, std::string source_sub, int time)
{
    char szLocalTime[32]    = {0};
    sprintf(szLocalTime, "%d", time);
    
    char szUrl[1024]     = {0};
    
    sprintf(szUrl, APP_REGISTER_URL, SDK_HOST);
    
    //cid
    char szParams[1024]  = {0};
    char szParams2[1024] = {0};
    char szParam3[254] = {0};
    strcat(szParams, "cid=");
    strcat(szParams, cid.c_str());
    //account
    strcat(szParams, "&account=");
    strcat(szParams, account.c_str());
    //passwd
    strcat(szParams, "&passwd=");
    strcat(szParams, passwd.c_str());
    //mac
    strcat(szParams, "&mac=");
    strcat(szParams, CDevice::sharedDevice()->getDeviceIMEI());
    //versions
    strcat(szParams, "&versions=");
    strcat(szParams, version.c_str());
    //os
    strcat(szParams, "&os=");
    strcat(szParams, "ios");
    //source
    strcat(szParams, "&source=");
    strcat(szParams, source.c_str());
    //source_sub
    strcat(szParams, "&source_sub=");
    strcat(szParams, source_sub.c_str());
    //time
    strcat(szParams, "&time=");
    strcat(szParams, szLocalTime);
    
    strcpy(szParams2, szParams);
    
    //key
    strcat(szParams, "&key=");
    strcat(szParams, PRIVATEKEY_W_217);
    
    std::string strSign = CMD5Crypto::md5(szParams, strlen(szParams));
    
    strcat(szParams2, "&sign=");
    strcat(szParams2, strSign.c_str());
    
    CAppRegisterBehavior *pSender = new CAppRegisterBehavior;
    pSender->autorelease();
    
    CCLOG("%s %s", szUrl, szParams2);
    strcat(szUrl, "?");
    strcat(szUrl, szParams2);
    CCHttpRequest *pRequest = new CCHttpRequest();
    pRequest->setUrl(szUrl);
    pRequest->setRequestType(CCHttpRequest::kHttpPost);
    //pRequest->setRequestData(szParams2, strlen(szParams2));
    pRequest->setResponseCallback(pSender, callfuncND_selector(CAppRegisterBehavior::defaultHttpVerify));
    pRequest->setTag("Caspar_Login_Request");
    CCHttpClient::getInstance()->send(pRequest);
    pRequest->release();
}

//登录页面 登录按钮回调
void CAPP_Login::LoginInit_onBeganTouchLoginBtn(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("LoginInit_onBeganTouchLoginBtn CallBack");
    //进入了页面
    
    std::string account = AccountEditBox->getTextString();
    std::string passwd = PasswordEditBox->getTextString();
    
    std::string strSessionId = CCUserDefault::sharedUserDefault()->getStringForKey("sid", "");
    const char *lpcszSessionId  = strSessionId.c_str();
    
    // if (account.empty() || passwd.empty())
    // {
    //     CCMessageBox("账号或者密码不正确", "错误");
    // }
    // else
    {
        if (m_pContainer != NULL) {
            m_pContainer->removeFromParentAndCleanup(true);
            m_pContainer = NULL;
        }
        
        CDateTime nowTime;
        int nLocalTime          = nowTime.getTotalSeconds();
        
        HttpLogin(CID_w_217, 0, account, passwd, strSessionId, "1", SDK_SOURCE_FROM, SDK_SOURCE_SUB_FROM, nLocalTime);
    }
}
//登录页面 注册按钮回调
void CAPP_Login::LoginInit_onBeganTouchregistBtn(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("LoginInit_onBeganTouchLoginBtn CallBack");
    if (m_pContainer != NULL) {
        m_pContainer->removeFromParentAndCleanup(true);
        m_pContainer = NULL;
    }
    //进入了注册页面
    CAPP_Login :: RegistInit();
}

bool CAPP_Login::shouldOverrideUrl(const char *lpcszUrl)
{
    return false;
}

//登录页面 忘记按钮回调
void CAPP_Login::LoginInit_onBeganTouchforgetBtn(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("LoginInit_onBeganTouchLoginBtn CallBack");
//    if (m_pContainer != NULL) {
//        m_pContainer->removeFromParentAndCleanup(true);
//        m_pContainer = NULL;
//    }
    //进入了忘记密码页面
    
    CCSize portaitDeviceSize = CDevice::sharedDevice()->getScreenSize();
    
    CDateTime nowTime;
    int nLocalTime          = nowTime.getTotalSeconds();
    
    char szLocalTime[32]    = {0};
    sprintf(szLocalTime, "%d", nLocalTime);
    
    char szUrl[1024]     = {0};
    
    sprintf(szUrl, APP_FORGET_URL, SDK_HOST);
    
    std::string strSessionId = CCUserDefault::sharedUserDefault()->getStringForKey("sid", "");
    const char *lpcszSessionId  = strSessionId.c_str();
    
    //cid
    char szParams[1024]  = {0};
    char szParams2[1024] = {0};
    char szParam3[254] = {0};
    strcat(szParams, "cid=");
    strcat(szParams, CID_w_217);
    //uid
    strcat(szParams, "&uid=0");
    //os
    strcat(szParams, "&os=ios");
    //session
    strcat(szParams, "&session=");
    strcat(szParams, lpcszSessionId);
    //time
    strcat(szParams, "&time=");
    strcat(szParams, szLocalTime);
    
    //key
    strcat(szParams, "&key=");
    strcat(szParams, PRIVATEKEY_W_217);
    
    strcpy(szParams2, szParams);
    
    std::string strSign = CMD5Crypto::md5(szParams, strlen(szParams));
    
    strcat(szParams2, "&sign=");
    strcat(szParams2, strSign.c_str());
   
    CCLOG("%s %s", szUrl, szParams2);
    strcat(szUrl, "?");
    strcat(szUrl, szParams2);
    
    if(m_pwebViewCloseBtn != NULL)
    {
        m_pwebViewCloseBtn->removeFromParentAndCleanup(true);
        m_pwebViewCloseBtn = NULL;
    }
    CCSize winSize = CCDirector::sharedDirector()->getVisibleSize();
    m_pwebViewCloseBtn = CButton::createWithSpriteFrameName("返回", "general_button_normal.png");
    m_pwebViewCloseBtn ->setPosition(ccp( winSize.width-m_pwebViewCloseBtn->getPreferredSize().width/2.0f, winSize.height-m_pwebViewCloseBtn->getPreferredSize().height/2.0f));
    m_pwebViewCloseBtn->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Login::RegistInit_onBeganTouchWebViewCloseBtn));
    addChild(m_pwebViewCloseBtn,100);
    
    float height_sc = m_pwebViewCloseBtn->getPreferredSize().height/winSize.height;
    float width_sc = 0.0f;//m_pwebViewCloseBtn->getPreferredSize().width/winSize.width;
    
    m_pWebView = CWebView::create();
    m_pWebView->setOverrideCallBack(this, (LP_OVERRIDE_WEBVIEW_URL_CALLBACK)(&CAPP_Login::shouldOverrideUrl));
    m_pWebView->setPreferredSize(CCSizeMake(portaitDeviceSize.height*(1.0f-width_sc*2.0f),portaitDeviceSize.width*(1.0f-height_sc)));
    m_pWebView->setPosition(ccp(portaitDeviceSize.height*width_sc, portaitDeviceSize.width*height_sc));
    m_pWebView->loadGet(szUrl);
    addChild(m_pWebView);
}
/***************************注册页面***************************************************************/
bool CAPP_Login :: RegistInit()
{
    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    //界面容器
    m_pContainer = CContainer::create();
    addChild(m_pContainer);
    
    //底图
    CCSize EditBoxSize = CCSizeMake(250.0f, 50.0f);
    CSprite *LoginBackground            = CSprite::createWithSpriteFrameName("account_underframe.png");
    //输入框
    CCLabelTTF *AccountLabel    = CCLabelTTF :: create("输入账号", "Arial", 24);
    CCLabelTTF *PasswordLabel   = CCLabelTTF :: create("输入密码", "Arial", 24);
    CCLabelTTF *RePasswordLabel = CCLabelTTF :: create("确认密码", "Arial", 24);
    CCScale9Sprite *EditBoxBackground1  = CCScale9Sprite::createWithSpriteFrameName("account_underframe2.png");
    CCScale9Sprite *EditBoxBackground2  = CCScale9Sprite::createWithSpriteFrameName("account_underframe2.png");
    CCScale9Sprite *EditBoxBackground3  = CCScale9Sprite::createWithSpriteFrameName("account_underframe2.png");
    CEditBox *AccountEditBox    = CEditBox ::create (EditBoxSize,EditBoxBackground1,20,"",kEditBoxInputFlagSensitive);
    CEditBox *PasswordEditBox   = CEditBox ::create (EditBoxSize,EditBoxBackground2,20,"",kEditBoxInputFlagPassword);
    CEditBox *RePasswordEditBox = CEditBox ::create (EditBoxSize,EditBoxBackground3,20,"",kEditBoxInputFlagPassword);
    
    RegisterAccountEditBox = AccountEditBox;
    RegisterPasswordEditBox = PasswordEditBox;
    RegisterPassword2EditBox = RePasswordEditBox;
    
    //记住账号
    //CCheckBox *checkbox = CCheckBox ::create("LuckyResources/general_pages_normal.png", "LuckyResources/general_pages_pressing.png", "");
    //CCLabelTTF *checkboxLabel  = CCLabelTTF :: create("已阅读并同意用户协议", "Arial", 24);
    
    //登录按钮
    CButton *SubmitBtn  = CButton :: createWithSpriteFrameName("提交","general_button_click.png");
    CButton *ReturnBtn  = CButton :: createWithSpriteFrameName("返回","general_button_click.png");
    
    float editboxleftSize = 190.0f;
    LoginBackground -> setPreferredSize(CCSizeMake(590.0f,350.0f));
    SubmitBtn-> setPreferredSize(CCSizeMake(220.0f,50.0f));
    ReturnBtn-> setPreferredSize(CCSizeMake(220.0f,50.0f));
    SubmitBtn->setFontSize(24);
    ReturnBtn->setFontSize(24);
    //checkbox->setFontSize(24);
    
    LoginBackground->setPosition(ccp(visibleSize.width/2, visibleSize.height/2));
    AccountEditBox   ->setPosition(ccp(20.0f, 120.0f));
    PasswordEditBox  ->setPosition(ccp(20.0f, 50.0f));
    RePasswordEditBox->setPosition(ccp(20.0f, -20.0f));
    
    AccountLabel   ->setPosition(ccp(-editboxleftSize+10.0f, 120.0f));
    PasswordLabel  ->setPosition(ccp(-editboxleftSize+10.0f, 50.0f));
    RePasswordLabel->setPosition(ccp(-editboxleftSize+10.0f, -20.0f));
    
    SubmitBtn ->setPosition(ccp(-130.0f, -130.0f));
    ReturnBtn ->setPosition(ccp(130.0f,-130.0f));

    //checkbox      ->setPosition(ccp(-120.0f,-80.0f));
    //checkboxLabel ->setPosition(ccp(145.0f,0.0f));
    
    m_pContainer->addChild(LoginBackground);
    LoginBackground->addChild(AccountEditBox);
    LoginBackground->addChild(PasswordEditBox);
    LoginBackground->addChild(RePasswordEditBox);
    AccountEditBox   ->addChild(AccountLabel);
    PasswordEditBox  ->addChild(PasswordLabel);
    RePasswordEditBox->addChild(RePasswordLabel);
    LoginBackground->addChild(SubmitBtn);
    LoginBackground->addChild(ReturnBtn);
    //LoginBackground->addChild(checkbox);
    //checkbox->addChild(checkboxLabel);
    
    //回调
    ReturnBtn->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Login::RegistInit_onBeganTouchReturnBtn));
    SubmitBtn->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Login::RegistInit_onBeganTouchSubmitBtn));
    return true ;
}
//注册页面 的返回按钮回调
void CAPP_Login::RegistInit_onBeganTouchReturnBtn(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("LoginInit_onBeganTouchLoginBtn CallBack");
    if (m_pContainer != NULL) {
        m_pContainer->removeFromParentAndCleanup(true);
        m_pContainer = NULL;
    }
    //去到登录界面
    CAPP_Login::LoginInit();
}
//注册页面 的提交按钮回调
void CAPP_Login::RegistInit_onBeganTouchSubmitBtn(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("LoginInit_onBeganTouchLoginBtn CallBack");
    //进入游戏
    
    std::string account = RegisterAccountEditBox->getTextString();
    std::string passwd = RegisterPasswordEditBox->getTextString();
    std::string passwd2 = RegisterPassword2EditBox->getTextString();
    
    if (passwd != passwd2 || passwd.empty())
    {
        CCMessageBox("密码不正确", "register valid!");
    }
    else
    {
        if (m_pContainer != NULL) {
            m_pContainer->removeFromParentAndCleanup(true);
            m_pContainer = NULL;
        }
        
        std::string strSessionId = CCUserDefault::sharedUserDefault()->getStringForKey("sid", "");
        const char *lpcszSessionId  = strSessionId.c_str();
        
        CDateTime nowTime;
        int nLocalTime          = nowTime.getTotalSeconds();
        
        HttpRegister(CID_w_217, account, passwd, "1", SDK_SOURCE_FROM, SDK_SOURCE_SUB_FROM, nLocalTime);
    }
}

void CAPP_Login::RegistInit_onBeganTouchWebViewCloseBtn(CCObject *pSender, CEvent *pEvent)
{
    if(m_pwebViewCloseBtn != NULL)
    {
        removeChild(m_pwebViewCloseBtn);
        m_pwebViewCloseBtn = NULL;
    }
    
    if(m_pWebView != NULL)
    {
        removeChild(m_pWebView);
        m_pWebView = NULL;
    }
}
#endif