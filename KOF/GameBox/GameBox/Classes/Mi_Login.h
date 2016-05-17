//
//  Mi_Login.h
//  GameBox
//
//  Created by Mac on 13-10-22.
//
//

#ifndef __GameBox__Mi_Login__
#define __GameBox__Mi_Login__

#include "AWebView.h"
#include "Constant.h"

#if (AGENT_SDK_CODE == 7)

USING_NS_CC;
using namespace ptola::gui;

class CMi_Login : public CCLayer
{
public:
    CMi_Login();
    
    CREATE_FUNC(CMi_Login);
    
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

#endif /* defined(__GameBox__Mi_Login__) */
