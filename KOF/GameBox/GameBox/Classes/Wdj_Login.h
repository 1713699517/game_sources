//
//  Wdj_Login.h
//  GameBox
//
//  Created by Mac on 13-10-22.
//
//

#ifndef __GameBox__Wdj_Login__
#define __GameBox__Wdj_Login__

#include "AWebView.h"
#include "Constant.h"

#if (AGENT_SDK_CODE == 13)

USING_NS_CC;
using namespace ptola::gui;

class CWdj_Login : public CCLayer
{
public:
    CWdj_Login();
    
    CREATE_FUNC(CWdj_Login);
    
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

#endif /* defined(__GameBox__Wdj_Login__) */
