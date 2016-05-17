//
//  UserCache.cpp
//  GameBox
//
//  Created by Caspar on 13-9-25.
//
//

#include "cocos2d.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "UserCache.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

using namespace ptola;
CUserCache *CUserCache::sharedUserCache()
{
    static CUserCache cache;
    return &cache;
}

void CUserCache::setObject(const char *key, const char *value)
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameUserData", "setValue", "(Ljava/lang/String;Ljava/lang/String;)V") )
    {
        jstring _jkey = methodInfo.env->NewStringUTF(key);
        jstring _jvalue = methodInfo.env->NewStringUTF(value);
        methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, _jkey, _jvalue);
        methodInfo.env->DeleteLocalRef( _jkey );
        methodInfo.env->DeleteLocalRef( _jvalue );
    }
    else
    {
        CCLOG("CUserCache::setObject method missed!");
    }
}

static std::string __usercacheoutput;

const char *CUserCache::getObject(const char *key)
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameUserData", "getValue", "(Ljava/lang/String;)Ljava/lang/String;") )
    {
        jstring _jkey = methodInfo.env->NewStringUTF(key);
        jobject jStringResult = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID, _jkey);
        __usercacheoutput = JniHelper::jstring2string((jstring)jStringResult);
        methodInfo.env->DeleteLocalRef( jStringResult );
        methodInfo.env->DeleteLocalRef( _jkey );
        return __usercacheoutput.c_str();
    }
    else
    {
        CCLOG("CUserCache::getObject method missed!");
        return NULL;
    }
}

void CUserCache::removeObject(const char *key)
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameUserData", "remove", "(Ljava/lang/String;)V") )
    {
        jstring _jkey = methodInfo.env->NewStringUTF(key);
        methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, _jkey);
        methodInfo.env->DeleteLocalRef( _jkey );
    }
    else
    {
        CCLOG("CUserCache::removeObject method missed!");
    }
}

#endif