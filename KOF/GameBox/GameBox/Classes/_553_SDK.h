//
//  _553_SDK.h
//  GameBox
//
//  Created by wrc on 13-6-24.
//
//

#ifndef __GameBox___553_SDK__
#define __GameBox___553_SDK__

#include "AWebView.h"

USING_NS_CC;
using namespace ptola::gui;

class C553_SDK : public CCLayer
{
public:
    C553_SDK();

    CREATE_FUNC(C553_SDK);
    
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


#endif /* defined(__GameBox___553_SDK__) */
