//
//  _553_Login.h
//  GameBox
//
//  Created by Caspar on 13-8-26.
//
//

#ifndef __GameBox___553_Login__
#define __GameBox___553_Login__

#include "AWebView.h"
#include "Constant.h"

#if (AGENT_SDK_CODE == 1 || AGENT_SDK_CODE == 6 || AGENT_SDK_CODE == 3)

USING_NS_CC;
using namespace ptola::gui;

class C553_Login : public CCLayer
{
public:
    C553_Login();

    CREATE_FUNC(C553_Login);

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

#endif /* defined(__GameBox___553_Login__) */
