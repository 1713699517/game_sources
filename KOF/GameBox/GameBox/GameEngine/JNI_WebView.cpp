//
//  JNI_WebView.cpp
//  GameBox
//
//  Created by wrc on 13-6-6.
//
//

#include "JNI_WebView.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "AWebView.h"

USING_NS_CC;
using namespace ptola::gui;

JNIEXPORT bool JNICALL Java_com_ptola_GameWebViewClient_nativeShouldOverrideUrl(JNIEnv *env, jobject thiz, jint nId ,jstring url)
{
    CWebView *pWebView = CWebView::getWebViewById((int)nId);
    if( pWebView == NULL )
        return false;
    const char *lpcszUrl = env->GetStringUTFChars(url, NULL);
//    CCLOG("test url= %s", lpcszUrl);
    return  pWebView->shouldOverrideUrl(lpcszUrl);
}

JNIEXPORT void JNICALL Java_com_ptola_GameWebViewClient_nativeWebViewPageLoaded(JNIEnv *env, jobject thiz, jint nId ,jstring url, jstring responseText, jstring responseHTML)
{
    CWebView *pWebView = CWebView::getWebViewById((int)nId);
    if( pWebView == NULL )
        return;
    const char *lpcszUrl = env->GetStringUTFChars(url, NULL);
    const char *lpcszResponseText = env->GetStringUTFChars(responseText, NULL);
    const char *lpcszResponseHTML = env->GetStringUTFChars(responseHTML, NULL);
    pWebView->onLoadCallBack(lpcszUrl, lpcszResponseText, lpcszResponseHTML);
//    CCLOG("page Loaded url= %s", lpcszUrl);
//    CCLOG("page Loaded text= %s", lpcszResponseText);
//    CCLOG("page Loaded html= %s", lpcszResponseHTML);
}

#endif  //end CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID