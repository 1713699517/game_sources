//
//  AWebView.h
//  GameBox
//
//  Created by Caspar on 2013-5-29.
//
//

#ifndef GameBox_AWebView_h
#define GameBox_AWebView_h

#include "UserControl.h"
#include "ptola.h"

USING_NS_CC;

typedef void (CCObject::*LP_WEBVIEW_CALLBACK)();
typedef bool (CCObject::*LP_OVERRIDE_WEBVIEW_URL_CALLBACK)(const char *lcpszUrl);

namespace ptola
{
namespace gui
{
 
    
    class CWebView : public CUserControl
    {
    public:
        static const char *urlEncode(const char *lpcszUrl);
        static const char *urlDecode(const char *lpcszUrl);

    public:
        MEMORY_MANAGE_OBJECT(CWebView);

        CWebView();
        ~CWebView();

        static CWebView *create();
        bool init();

        void setPreferredSize(const CCSize &value);
        CCSize getPreferredSize();

        void loadGet(const char *lpcszUrl, CCDictionary *pHttpHeaders = NULL, const char *lpcData=NULL, unsigned int uDataLength=0U, CCObject *pTarget = NULL, SEL_PtolaEventHandler eventHandler = NULL);
        
        void loadPost(const char *lpcszUrl, CCDictionary *pHttpHeaders = NULL, const char *lpcData=NULL, unsigned int uDataLength=0U, CCObject *pTarget = NULL, SEL_PtolaEventHandler eventHandler = NULL);


        const char *getResponseText();
        const char *getResponseHTML();

        void setOverrideCallBack(CCObject *pTarget, LP_OVERRIDE_WEBVIEW_URL_CALLBACK callBack);
    public:
        virtual void setPosition(const CCPoint &pos);
        virtual const CCPoint &getPosition();
        
    private:

        void webViewCallBack();

        CEventHandler *m_pEventHandler;

        size_t m_pWebViewBridge;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    public:
        static CWebView *getWebViewById(int nId);
        bool shouldOverrideUrl(const char *lpcszUrl);
        void onLoadCallBack(const char *lpcszUrl, const char *lpcszText, const char *lpcszHTML);

        const char *m_pResponseText;
        const char *m_pResponseHTML;
    private:
        CCPoint m_webViewPosition;
        CCSize m_webViewPreferredSize;
        
        CCObject *m_pOverrideTarget;
        LP_OVERRIDE_WEBVIEW_URL_CALLBACK m_pOverrideCallback;
#endif
    };

}
}


#endif
