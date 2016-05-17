//
//  JNI_GameBox.h
//  GameBox
//
//  Created by Caspar on 2013-6-6.
//
//

#ifndef GameBox_JNI_GameVedio_h
#define GameBox_JNI_GameVedio_h

#include "cocos2d.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "ptola.h"
#include <jni.h>

#ifdef __cplusplus
extern "C"{
#endif  //end __cplusplus

    JNIEXPORT void JNICALL Java_com_ptola_GameVideoHandler_nativeFirstFinish(JNIEnv *env, jobject thiz);
    
#ifdef __cplusplus
}
#endif  //end __cplusplus


#endif  //end CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID

void aaaaa();

#endif
