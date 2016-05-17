//
//  Application_Android.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#include "cocos2d.h"

#if( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID )
#include "Application.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

USING_NS_CC;
using namespace ptola;
//using namespace ptola::io;

CApplication::CApplication()
{
    reInitializeStartupPath();
    reInitializeResourcePath();
    reInitializeBundleVersion();
}

CApplication::~CApplication()
{

}

void CApplication::reInitializeStartupPath()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GamePathResolver", "getApplicationStartupPath", "()Ljava/lang/String;") )
    {
        jobject jStringResult = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID);
        std::string strResult = JniHelper::jstring2string((jstring)jStringResult);
        m_strStartupPath = strResult;
        methodInfo.env->DeleteLocalRef( jStringResult );
    }
    else
    {
        CCLOG("CApplication::getApplicationStartupPath method missed!");
    }
}

void CApplication::reInitializeResourcePath()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GamePathResolver", "getApplicationResourcePath", "()Ljava/lang/String;") )
    {
        jobject jStringResult = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID);
        std::string strResult = JniHelper::jstring2string((jstring)jStringResult);
        m_strResourcePath = strResult;
        methodInfo.env->DeleteLocalRef( jStringResult );
    }
    else
    {
        CCLOG("CApplication::getApplicationResourcePath method missed!");
    }
}

void CApplication::reInitializeBundleVersion()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GamePathResolver", "getApplicationBundleVersion", "()Ljava/lang/String;") )
    {
        jobject jStringResult = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID);
        std::string strResult = JniHelper::jstring2string((jstring)jStringResult);
        m_strBundleVersion = strResult;
        methodInfo.env->DeleteLocalRef( jStringResult );
    }
    else
    {
        CCLOG("CApplication::getApplicationBundleVersion method missed!");
    }
}

#endif
