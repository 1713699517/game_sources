//
//  _OPPO_Android_Login.h
//  GameBox
//
//  Created by Mac on 13-11-28.
//
//

#ifndef __GameBox___OPPO_Android_Login__
#define __GameBox___OPPO_Android_Login__

#include <iostream>

#include "AWebView.h"
#include "Constant.h"

#if (AGENT_SDK_CODE == 8)

USING_NS_CC;
using namespace ptola::gui;

class COppo_Login : public CCLayer
{
public:
    COppo_Login();
    
    CREATE_FUNC(COppo_Login);
    
    bool init();
    
    static CCScene *scene();
    
    void getUrl(char *lpszUrl, size_t uLength);
    
    bool shouldOverrideUrl(const char *lpcszUrl);
    
private:
    std::string urlDecode(const std::string& strToDecode);
    
    void parseJsonResultData(const char *lpcszJsonData);
    void onJJAPIResponsed(CCNode *pSender, void *pResponseData);
    
    CWebView *m_pWebView;
};

#endif

#endif /* defined(__GameBox___OPPO_Android_Login__) */
