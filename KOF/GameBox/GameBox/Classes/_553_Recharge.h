//
//  _553_Recharge.h
//  GameBox
//
//  Created by Caspar on 13-8-26.
//
//

#ifndef __GameBox___553_Recharge__
#define __GameBox___553_Recharge__

#include "Constant.h"


#if (AGENT_SDK_CODE == 1 || AGENT_SDK_CODE == 4 )

#include "AWebView.h"
#include "Button.h"

using namespace cocos2d;
using namespace ptola::gui;

class C553_Recharge : public CCNode
{
public:
    C553_Recharge();
    
    CREATE_FUNC(C553_Recharge);
    bool init();
    void getUrl(char *lpszUrl, size_t uLength);

    bool shouldOverrideUrl(const char *lpcszUrl);

private:
    void onBeganTouchCloseButton(CCObject *pSender, CEvent *pEvent);

    std::string urlDecode(const std::string& strToDecode);

    void parseJsonResultData(const char *lpcszJsonData);
    void onJJAPIResponsed(CCNode *pSender, void *pResponseData);
    CWebView *m_pWebView;

    CButton *m_pCloseButton;
};
#endif

#endif /* defined(__GameBox___553_Recharge__) */
