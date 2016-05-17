//
//  JNI_WebView.h
//  GameBox
//
//  Created by wrc on 13-6-6.
//
//

#ifndef GameBox_JNI_WebView_h
#define GameBox_JNI_WebView_h

#include "cocos2d.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>

#ifdef __cplusplus
extern "C"{
#endif  //end __cplusplus


    JNIEXPORT bool JNICALL Java_com_ptola_GameWebViewClient_nativeShouldOverrideUrl(JNIEnv *env, jobject thiz, jint nId ,jstring url);

    JNIEXPORT void JNICALL Java_com_ptola_GameWebViewClient_nativeWebViewPageLoaded(JNIEnv *env, jobject thiz, jint nId ,jstring url, jstring responseText, jstring responseHTML);

#ifdef __cplusplus
}
#endif  //end __cplusplus


#endif  //end CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID

#endif
