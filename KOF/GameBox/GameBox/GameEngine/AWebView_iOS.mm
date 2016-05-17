//
//  AWebView_iOS.mm
//  GameBox
//
//  Created by Caspar on 2013-5-29.
//
//

#include "AWebView.h"

#if( CC_TARGET_PLATFORM == CC_PLATFORM_IOS )

#include "Event.h"
#include "EAGLView.h"
#include "MemoryAllocator.h"
#import "UIWebViewBridge.h"

using namespace ptola::gui;
using namespace ptola::event;
using namespace ptola::memory;

MEMORY_MANAGE_OBJECT_IMPL(CWebView);

CWebView::CWebView()
: m_pWebViewBridge(0)
, m_pEventHandler(NULL)
{
    
}

CWebView::~CWebView()
{
    UIWebViewBridge *pBridge = (UIWebViewBridge *)m_pWebViewBridge;
    if( pBridge != NULL )
    {
        //[[pBridge getWebView] removeFromSuperview];
        [pBridge dealloc];
    }
    CC_SAFE_DELETE(m_pEventHandler);
}

CWebView *CWebView::create()
{
    CWebView *pRet = new CWebView;
    if( pRet != NULL && pRet->init() )
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CC_SAFE_DELETE(pRet);
        return NULL;
    }
}

bool CWebView::init()
{
    if( !CUserControl::init() )
    {
        return onInitialized(false);
    }

    
    UIWebViewBridge *pBridge = [[UIWebViewBridge alloc] init];
    [[EAGLView sharedEGLView] addSubview: [pBridge getWebView] ];
    m_pWebViewBridge = (size_t)pBridge;
    return onInitialized(true);
}



const char *CWebView::getResponseText()
{
    UIWebViewBridge *pBridge = (UIWebViewBridge *)m_pWebViewBridge;
    if( pBridge == NULL )
        return NULL;
    else
        return [[[pBridge getWebView] stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"] UTF8String];
}

const char *CWebView::getResponseHTML()
{
    UIWebViewBridge *pBridge = (UIWebViewBridge *)m_pWebViewBridge;
    if( pBridge == NULL )
        return NULL;
    else
        return [[[pBridge getWebView] stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"] UTF8String];
}


void CWebView::setPreferredSize(const CCSize &value)
{
    UIWebViewBridge *pBridge = (UIWebViewBridge *)m_pWebViewBridge;
    if( pBridge != NULL )
    {
        [pBridge setPreferredSize:CGSizeMake(value.width, value.height)];
    }
}

CCSize CWebView::getPreferredSize()
{
    UIWebViewBridge *pBridge = (UIWebViewBridge *)m_pWebViewBridge;
    if( pBridge != NULL )
    {
        CGSize _tSize = [pBridge getPreferredSize];
        return CCSizeMake(_tSize.width, _tSize.height);
    }
    else
    {
        return CCSizeZero;
    }
}

void CWebView::setOverrideCallBack(CCObject *pTarget, LP_OVERRIDE_WEBVIEW_URL_CALLBACK callBack)
{
    UIWebViewBridge *pBridge = (UIWebViewBridge *)m_pWebViewBridge;
    if( pBridge != NULL )
    {
        [pBridge setOverrideCallBack:pTarget overrideCallBack:callBack];
    }
}

void CWebView::webViewCallBack()
{
    if( m_pEventHandler != NULL )
    {
        CEvent evt("WebViewCallBack", this, NULL);
        m_pEventHandler->invoke(this, &evt);
    }
}

void CWebView::loadGet(const char *lpcszUrl, CCDictionary *pHttpHeaders, const char *lpcData, unsigned int uDataLength, CCObject *pTarget , SEL_PtolaEventHandler eventHandler)
{
    CC_SAFE_DELETE(m_pEventHandler);
    if( pTarget != NULL && eventHandler != NULL )
    {
        m_pEventHandler = CEventHandler::create(pTarget, eventHandler);
        CC_SAFE_RETAIN(m_pEventHandler);
    }
    UIWebViewBridge *pBridge = (UIWebViewBridge *)m_pWebViewBridge;
    if( pBridge != NULL )
    {
        NSMutableDictionary *headers = nil;
        if (pHttpHeaders != NULL)
        {
            headers = [[NSMutableDictionary alloc] initWithCapacity:pHttpHeaders->count()];
            CCDictElement *pElement = NULL;
            CCDICT_FOREACH(pHttpHeaders, pElement)
            {
                CCString *pstrValue = dynamic_cast<CCString *>(pElement->getObject());
                if( pstrValue == NULL )
                    continue;
                [headers setValue:[[NSString alloc] initWithUTF8String:pElement->getStrKey()] forKey:[[NSString alloc] initWithUTF8String:pstrValue->getCString()]];
            }
        }

        NSData *pRequestData = nil;
        if( lpcData != NULL )
        {
            if( uDataLength > 0U )
            {
                pRequestData = [[NSData alloc] initWithBytes:(const void *)lpcData length:uDataLength];
            }
            else
            {
                pRequestData = [[NSString stringWithUTF8String:lpcData] dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
        [pBridge loadGet:[NSString stringWithUTF8String:lpcszUrl] httpHeaders:headers requestBuffer:pRequestData target:this handler:(LP_WEBVIEW_CALLBACK)(&CWebView::webViewCallBack)];
    }
    
}

void CWebView::loadPost(const char *lpcszUrl, CCDictionary *pHttpHeaders, const char *lpcData, unsigned int uDataLength, CCObject *pTarget , SEL_PtolaEventHandler eventHandler)
{
    CC_SAFE_DELETE(m_pEventHandler);
    if( pTarget != NULL && eventHandler != NULL )
    {
        m_pEventHandler = CEventHandler::create(pTarget, eventHandler);
        CC_SAFE_RETAIN(m_pEventHandler);
    }
    UIWebViewBridge *pBridge = (UIWebViewBridge *)m_pWebViewBridge;
    if( pBridge != NULL )
    {
        NSMutableDictionary *headers = nil;
        if (pHttpHeaders != NULL)
        {
            headers = [[NSMutableDictionary alloc] initWithCapacity:pHttpHeaders->count()];
            CCDictElement *pElement = NULL;
            CCDICT_FOREACH(pHttpHeaders, pElement)
            {
                CCString *pstrValue = dynamic_cast<CCString *>(pElement->getObject());
                if( pstrValue == NULL )
                    continue;
                [headers setValue:[[NSString alloc] initWithUTF8String:pElement->getStrKey()] forKey:[[NSString alloc] initWithUTF8String:pstrValue->getCString()]];
            }
        }

        NSData *pRequestData = nil;
        if( lpcData != NULL )
        {
            if( uDataLength > 0U )
            {
                pRequestData = [[NSData alloc] initWithBytes:(const void *)lpcData length:uDataLength];
            }
            else
            {
                pRequestData = [[NSString stringWithUTF8String:lpcData] dataUsingEncoding:NSUTF8StringEncoding];
            }
        }
        [pBridge loadPost:[NSString stringWithUTF8String:lpcszUrl] httpHeaders:headers requestBuffer:pRequestData target:this handler:(LP_WEBVIEW_CALLBACK)(&CWebView::webViewCallBack)];
    }

}

void CWebView::setPosition(const cocos2d::CCPoint &pos)
{
    UIWebViewBridge *pBridge = (UIWebViewBridge *)m_pWebViewBridge;
    [pBridge setPosition:CGPointMake(pos.x, pos.y)];
    CUserControl::setPosition(pos);
}

const CCPoint &CWebView::getPosition()
{
    return CUserControl::getPosition();
}

const char *CWebView::urlEncode(const char *lpcszUrl)
{
    NSString *pStr = [[[NSString alloc] initWithUTF8String:lpcszUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [pStr UTF8String];
}

const char *CWebView::urlDecode(const char *lpcszUrl)
{
    NSString *pStr = [[[NSString alloc] initWithUTF8String:lpcszUrl] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [pStr UTF8String];
}

#endif