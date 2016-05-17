//
//  Platform.cpp
//  VedioTest
//
//  Created by Himi on 12-10-9.
//
//

#include "VideoPlatform.h"
#include "Launcher.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#include <android/log.h>
#else
#include "IOSPlayVedio.h"
#endif


bool VideoPlatform::isPlaying()
{
    bool isPlaying = false;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    CCLog("Android isPlaying()!!!");
    JniMethodInfo minfo;
    jobject i=NULL;
    bool isHave = JniHelper::getStaticMethodInfo(minfo,"com/ptola/GameVideoHandler","isPlaying", "()Ljava/lang/Object;");
    if (isHave)
    {
        CCLog("videoPlay Android isPlaying() has!!!!");
        i = minfo.env->CallStaticObjectMethod(minfo.classID, minfo.methodID);
        minfo.env->DeleteLocalRef(minfo.classID);
    }else
    {
        CCLog("videoPlay Android isPlaying() Nofound!!!!");
    }
    if(i != NULL)
    {
        isPlaying = true;
    }
#endif
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    CCLog("videoPlay IOS isPlaying()!!!");
    isPlaying = IOSPlayVedio::isPlaying();
    
#endif
    return isPlaying;
}


void VideoPlatform::playVedio(char *name)
{
  
    CCLog("videoPlay playVedio() ComeIn");
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    //Android视频播放代码
    int videoType = 1;
    if(ptola::update::CLauncher::hasVersionFile())
    {
        videoType = 2;
    }
    CCLog("videoPlay playVedio() ComeIn---->%d",videoType);
    jint jni_type      = videoType;
    
    JniMethodInfo minfo;//定义Jni函数信息结构体
    if ( JniHelper::getMethodInfo(minfo,"com/ptola/GameVideoHandler", "playVideo","(ILjava/lang/String;)V") )
    {
        jstring vedioName = minfo.env->NewStringUTF(name);
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID,jni_type,vedioName);
        
    }
    else
    {
        CCLOG("VideoPlatform::playVedio method missed!");
    }
#endif
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    //iOS视频播放代码
    CCLog("videoPlay IOS playVedio() ComeIn");
    IOSPlayVedio::playVedio4iOS(name);
#endif
    
}

void VideoPlatform::cancelPlaying()
{
    if (isPlaying())
    {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        //iOS视频播放代码
        CCLog("videoPlay IOS playVedio() ComeIn");
        IOSPlayVedio::cancelPlaying();
#endif
    }
}
