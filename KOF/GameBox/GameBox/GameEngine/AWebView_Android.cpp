//
//  AWebView_Android.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-29.
//
//

#include "AWebView.h"

#if( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
#include "Device.h"
#include "MemoryAllocator.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>
#include <map>

using namespace ptola;
using namespace ptola::gui;
using namespace ptola::memory;

static int s_nWebViewIdCreator = 0;

MEMORY_MANAGE_OBJECT_IMPL(CWebView);


static std::map<int, CWebView *> s_mapWebViews;
CWebView *CWebView::getWebViewById(int nId)
{
    std::map<int, CWebView *>::iterator it = s_mapWebViews.find(nId);
    return it != s_mapWebViews.end() ? it->second : NULL;
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

CWebView::CWebView()
: m_pEventHandler(NULL)
, m_pWebViewBridge(0)
, m_webViewPosition(CCPointZero)
, m_webViewPreferredSize(CDevice::sharedDevice()->getScreenSize())
, m_pOverrideTarget(NULL)
, m_pOverrideCallback(NULL)
, m_pResponseText(NULL)
, m_pResponseHTML(NULL)
{
}

CWebView::~CWebView()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameWebViewBridge", "destoryWebView", "(I)V") )
    {
        methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, (int)m_pWebViewBridge);
    }
    else
    {
        CCLOG("GameWebViewBridge::destoryWebView method missed!");
    }
    CC_SAFE_DELETE(m_pEventHandler);
}

bool CWebView::init()
{
    if( !CUserControl::init() )
        return onInitialized(false);
    do
    {
        JniMethodInfo methodInfo;
        if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameWebViewBridge", "createWebView", "()I"))
        {
            jint jWebView = methodInfo.env->CallStaticIntMethod(methodInfo.classID, methodInfo.methodID);

            CC_BREAK_IF( jWebView == 0 );
            s_nWebViewIdCreator++;
            m_pWebViewBridge = (size_t)s_nWebViewIdCreator;
            s_mapWebViews[ s_nWebViewIdCreator ] = this;
            return onInitialized(true);
        }
    }
    while(0);
    CCLOG("GameWebViewBridge::createWebView method missed!");
    return onInitialized(false);
}

bool CWebView::shouldOverrideUrl(const char *lpcszUrl)
{
    if( m_pOverrideTarget == NULL || m_pOverrideCallback == NULL )
        return false;
    return (m_pOverrideTarget->*m_pOverrideCallback)(lpcszUrl);
}

void CWebView::onLoadCallBack(const char *lpcszUrl, const char *lpcszText, const char *lpcszHTML)
{
    m_pResponseText = lpcszText;
    m_pResponseHTML = lpcszHTML;
    if( m_pEventHandler != NULL )
    {
        CEvent evt("WebViewCallBack", this, NULL);
        m_pEventHandler->invoke(this, &evt);
    }
}

void CWebView::setOverrideCallBack(cocos2d::CCObject *pTarget, LP_OVERRIDE_WEBVIEW_URL_CALLBACK callBack)
{
    m_pOverrideTarget = pTarget;
    m_pOverrideCallback = callBack;
}

void CWebView::setPreferredSize(const cocos2d::CCSize &value)
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameWebViewBridge", "setPerferredSize", "(IFF)V") )
    {
        methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, (int)m_pWebViewBridge, value.width, value.height );
        m_webViewPreferredSize = value;
    }
    else
    {
        CCLOG("GameWebViewBridge::setPreferredSize method missed!");
    }
}

CCSize CWebView::getPreferredSize()
{
    return m_webViewPreferredSize;
}

void CWebView::loadGet(const char *lpcszUrl, CCDictionary *pHttpHeaders, const char *lpcData, unsigned int uDataLength, CCObject *pTarget , SEL_PtolaEventHandler eventHandler)
{
//loadGet(int nId, String url)
    CC_SAFE_DELETE(m_pEventHandler);
    m_pEventHandler = new CEventHandler(pTarget, eventHandler);
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameWebViewBridge", "loadGet", "(ILjava/lang/String;)V") )
    {
        jint _id = (jint)m_pWebViewBridge;
        jstring _url = methodInfo.env->NewStringUTF( lpcszUrl );
        methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, _id, _url);
        methodInfo.env->DeleteLocalRef(_url);
    }
    else
    {
        CCLOG("GameWebViewBridge::loadGet method missed!");
    }
}

void CWebView::loadPost(const char *lpcszUrl, CCDictionary *pHttpHeaders, const char *lpcData, unsigned int uDataLength, CCObject *pTarget , SEL_PtolaEventHandler eventHandler)
{
    CC_SAFE_DELETE(m_pEventHandler);
    m_pEventHandler = new CEventHandler(pTarget, eventHandler);
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameWebViewBridge", "loadPost", "(ILjava/lang/String;[B)V") )
    {
        jint _id = (jint)m_pWebViewBridge;
        jstring _url = methodInfo.env->NewStringUTF( lpcszUrl );
        jbyteArray _data = methodInfo.env->NewByteArray( uDataLength );
        methodInfo.env->SetByteArrayRegion( _data, (jsize)0, (jsize)uDataLength, (jbyte *)lpcData);
        methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, _id, _url, _data);
        //post data
        methodInfo.env->DeleteLocalRef(_url);
        methodInfo.env->DeleteLocalRef(_data);
    }
    else
    {
        CCLOG("GameWebViewBridge::loadGet method missed!");
    }
}

void CWebView::setPosition(const CCPoint &pos)
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameWebViewBridge", "setPosition", "(IFF)V") )
    {
        methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, (int)m_pWebViewBridge, pos.x, pos.y );
        m_webViewPosition = pos;
    }
    else
    {
        CCLOG("GameWebViewBridge::setPosition method missed!");
    }
}

const CCPoint &CWebView::getPosition()
{
    return m_webViewPosition;
}

const char *CWebView::getResponseText()
{
    return m_pResponseText;
}

const char *CWebView::getResponseHTML()
{
    return m_pResponseHTML;
}

static std::string __urlcodebuff;

const char *CWebView::urlEncode(const char *lpcszUrl)
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameWebViewBridge", "urlEncode", "(Ljava/lang/String;)Ljava/lang/String;") )
    {
        jstring jInput = methodInfo.env->NewStringUTF(lpcszUrl);
        jobject jOutput = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID, jInput );
        __urlcodebuff = JniHelper::jstring2string((jstring)jOutput);
        methodInfo.env->DeleteLocalRef( jOutput );
        return __urlcodebuff.c_str();
    }
    else
    {
        CCLOG("GameWebViewBridge::urlEncode method missed!");
        return NULL;
    }
}

const char *CWebView::urlDecode(const char *lpcszUrl)
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameWebViewBridge", "urlDecode", "(Ljava/lang/String;)Ljava/lang/String;") )
    {
        jstring jInput = methodInfo.env->NewStringUTF(lpcszUrl);
        jobject jOutput = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID, jInput );
        __urlcodebuff = JniHelper::jstring2string((jstring)jOutput);
        methodInfo.env->DeleteLocalRef( jOutput );
        return __urlcodebuff.c_str();
    }
    else
    {
        CCLOG("GameWebViewBridge::urlDecode method missed!");
        return NULL;
    }
}
#endif