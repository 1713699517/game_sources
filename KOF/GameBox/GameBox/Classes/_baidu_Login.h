//
//  _baidu_Login.h
//  GameBox
//
//  Created by Mac on 13-12-6.
//
//

#ifndef __GameBox___baidu_Login__
#define __GameBox___baidu_Login__

#include "AWebView.h"
#include "Constant.h"

#if (AGENT_SDK_CODE == 12)

USING_NS_CC;
using namespace ptola::gui;

class CBaidu_Login : public CCLayer
{
public:
    CBaidu_Login();
    
    CREATE_FUNC(CBaidu_Login);
    
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

#endif /* defined(__GameBox___baidu_Login__) */
