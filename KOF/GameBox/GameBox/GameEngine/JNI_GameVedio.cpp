//
//  JNI_GameBox.c
//  GameBox
//
//  Created by Caspar on 2013-6-6.
//
//



#include "JNI_GameVedio.h"

using namespace cocos2d;

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "DateTime.h"
#include "UpdateDelay.h"
#include "Device.h"
#include "Application.h"
#include "misc/json.h"
#include "platform/android/jni/JniHelper.h"



USING_NS_CC;
using namespace ptola;

JNIEXPORT void JNICALL Java_com_ptola_GameVideoHandler_nativeFirstFinish(JNIEnv *env, jobject thiz)
{
    CUpdateDelay *delay = CUpdateDelay::create();
    CCDirector::sharedDirector()->getRunningScene()->addChild(delay);
    delay->delayGoToUpdate();
};

#endif  //end CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
