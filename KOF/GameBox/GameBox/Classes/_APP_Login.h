//
//  _APP_Login.h
//  GameBox
//
//  Created by Mac on 13-12-4.
//
//

#ifndef __GameBox___APP_Login__
#define __GameBox___APP_Login__

#include "AWebView.h"
#include "Constant.h"
#include "Container.h"
#include "EditBox.h"
#include "Button.h"

#if (AGENT_SDK_CODE == 3)

USING_NS_CC;
using namespace ptola::gui;

class CAppLoginBehavior : public CCObject
{
public:
    void defaultHttpVerify(CCObject *pSender, void *pData);
};

class CAppRegisterBehavior : public CCObject
{
public:
    void defaultHttpVerify(CCObject *pSender, void *pData);
};

class CAPP_Login : public CCLayer
{
public:
    CAPP_Login();
    ~CAPP_Login();
    
    CREATE_FUNC(CAPP_Login);
    
    bool init();
    bool RegistInit();
    bool LoginInit();
    
    static CCScene *scene();
    
    void getUrl(char *lpszUrl, size_t uLength);
    
    bool shouldOverrideUrl(const char *lpcszUrl);
    
    static CAPP_Login* getInstance()    {return instance;}
    
private:
    std::string urlDecode(const std::string& strToDecode);
    
    void init_onBeganTouchLoginBtn(CCObject *pSender, CEvent *pEvent);
    void init_onBeganTouchRegistBtn(CCObject *pSender, CEvent *pEvent);
    
    void LoginInit_onBeganTouchLoginBtn(CCObject *pSender, CEvent *pEvent);
    void LoginInit_onBeganTouchregistBtn(CCObject *pSender, CEvent *pEvent);    
    void LoginInit_onBeganTouchforgetBtn(CCObject *pSender, CEvent *pEvent);
    
    void RegistInit_onBeganTouchReturnBtn(CCObject *pSender, CEvent *pEvent);
    void RegistInit_onBeganTouchSubmitBtn(CCObject *pSender, CEvent *pEvent);
    void RegistInit_onBeganTouchWebViewCloseBtn(CCObject *pSender, CEvent *pEvent);
    void parseJsonResultData(const char *lpcszJsonData);
    void onJJAPIResponsed(CCNode *pSender, void *pResponseData);
    
    void HttpLogin(std::string cid, int type, std::string account, std::string passwd, std::string session, std::string version,
                               std::string source, std::string source_sub, int time);
    
    void HttpRegister(std::string cid, std::string account, std::string passwd, std::string version,
                      std::string source, std::string source_sub, int time);
    CButton *m_pwebViewCloseBtn;
    CWebView *m_pWebView;
    CContainer *m_pContainer;
    
    CEditBox *AccountEditBox;
    CEditBox *PasswordEditBox;
    
    CEditBox *RegisterAccountEditBox;
    CEditBox *RegisterPasswordEditBox;
    CEditBox *RegisterPassword2EditBox;
    
    static CAPP_Login *instance;
};

#endif

#endif /* defined(__GameBox___APP_Login__) */
