//
//  UUID.cpp
//  GameBox
//
//  Created by Caspar on 13-8-27.
//
//
#include "cocos2d.h"

#if( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
#include "UUID.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

USING_NS_CC;
using namespace ptola;

static char g_szUUIDBuffer[64];

const char *CUUID::create()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameUUID", "create", "()Ljava/lang/String;") )
    {
        jobject jStringResult = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID);
        std::string strResult = JniHelper::jstring2string((jstring)jStringResult);
        strcpy( g_szUUIDBuffer, strResult.c_str());
        methodInfo.env->DeleteLocalRef( jStringResult );
    }
    else
    {
        CCLOG("GameUUID::create method missed!");
    }
    return g_szUUIDBuffer;
}


#endif