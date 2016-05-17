//
//  Device_Android.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-23.
//
//
#include "cocos2d.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "Device.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

using namespace ptola;

CDevice::CDevice()
{
    memset( m_szIMEI, 0, sizeof(m_szIMEI) );
    setDeviceSupportOrientation( LandscapeLeft | LandscapeRight );
    reInitializeScreenSize();
    reInitializeDeviceIMEI();
    reInitializeOSVersion();
    reInitializeModel();
    reInitializeMAC();
    m_fHeightRatio = 1.0f;
}

CDevice::~CDevice()
{

}

enumNetworkStatus CDevice::getNetworkStatus()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameDevice", "getNetworkStatus", "()I"))
    {
        jint ret = methodInfo.env->CallStaticIntMethod(methodInfo.classID, methodInfo.methodID);
        switch( ret )
        {
            case 1:
                return eNS_Wifi;
            case 2:
                return eNS_WWAN;
            default:
                return eNS_NotReachable;
        }
    }
    else
    {
        CCLOG("GameDevice::getNetworkStatus method missed!");
    }
    return eNS_NotReachable;
}

enumDeviceOrientation CDevice::getDeviceOrientation()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameDevice", "getDeviceOrientation", "()I"))
    {
        jint ret = methodInfo.env->CallStaticIntMethod(methodInfo.classID, methodInfo.methodID);
        switch( ret )
        {
            case 1:
                return LandscapeRight;
            case 2:
                return PortraitUpsideDown;
            case 3:
                return LandscapeLeft;
            default:
                return Portrait;
        }
    }
    else
    {
        CCLOG("GameDevice::getDeviceOrientation method missed!");
    }
    return Portrait;
};


void CDevice::reInitializeScreenSize()
{
    do
    {
        JniMethodInfo methodInfo;
        if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameDevice","getScreenSize","()Landroid/graphics/Point;") )
        {
            jobject jPointResult = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID);
            CC_BREAK_IF( jPointResult == NULL );

            jclass jPointClassId = JniHelper::getClassID("android/graphics/Point");
            CC_BREAK_IF( jPointClassId == NULL );
            jfieldID _x = methodInfo.env->GetFieldID(jPointClassId, "x","I");
            jfieldID _y = methodInfo.env->GetFieldID(jPointClassId, "y","I");
            CC_BREAK_IF( _x == NULL || _y == NULL );

            int _widthValue = methodInfo.env->GetIntField( jPointResult, _x );
            int _heightValue = methodInfo.env->GetIntField( jPointResult, _y );

            m_sScreenSize.setSize( _widthValue, _heightValue );
            return;
        }
    }
    while(0);
    CCLOG("GameDevice::getScreenSize method missed!");
    m_sScreenSize.setSize( 0.0f, 0.0f );
}

void CDevice::reInitializeDeviceIMEI()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameDevice", "getDeviceIMEI", "()Ljava/lang/String;") )
    {
        jobject jStringResult = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID);
        std::string strResult = JniHelper::jstring2string((jstring)jStringResult);
        strcpy( m_szIMEI, strResult.c_str() );
        methodInfo.env->DeleteLocalRef( jStringResult );
    }
    else
    {
        CCLOG("GameDevice::getDeviceIMEI method missed!");
    }
}

void CDevice::reInitializeMAC()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameDevice", "getDeviceMAC", "()Ljava/lang/String;") )
    {
        jobject jStringResult = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID);
        std::string strResult = JniHelper::jstring2string((jstring)jStringResult);
        strcpy( m_szMAC, strResult.c_str() );
        methodInfo.env->DeleteLocalRef( jStringResult );
    }
    else
    {
        CCLOG("GameDevice::getDeviceIMEI method missed!");
    }
}

void CDevice::reInitializeOSVersion()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameDevice", "getOSVersion", "()Ljava/lang/String;") )
    {
        jobject jStringResult = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID);
        std::string strResult = JniHelper::jstring2string((jstring)jStringResult);
        strcpy( m_szOSVersion, strResult.c_str() );
        methodInfo.env->DeleteLocalRef( jStringResult );
    }
    else
    {
        CCLOG("GameDevice::getOSVersion method missed!");
    }
}

void CDevice::reInitializeModel()
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameDevice", "getModel", "()Ljava/lang/String;") )
    {
        jobject jStringResult = methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID);
        std::string strResult = JniHelper::jstring2string((jstring)jStringResult);
        strcpy( m_szModel, strResult.c_str() );
        methodInfo.env->DeleteLocalRef( jStringResult );
    }
    else
    {
        CCLOG("GameDevice::getModel method missed!");
    }
}

void CDevice::setDeviceOrientation(enumDeviceOrientation orientation)
{
    if( (m_nDeviceSupportOrientation & orientation) == 0 )
        return; // unsupportDeviceOrientation
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameDevice", "setDeviceOrientation", "(I)V") )
    {
        /*
         0 ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
         1 ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
         */
        int value = ( orientation == LandscapeLeft || orientation == LandscapeRight ) ? 0 : 1;
        methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, value);
        return;
    }
    else
    {
        CCLOG("GameDevice::setDeviceOrientation method missed!");
    }
}

void CDevice::vibrate(int ms)
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameDevice", "vibrate", "(I)V") )
    {
        methodInfo.env->CallStaticObjectMethod(methodInfo.classID, methodInfo.methodID, ms);
    }
    else
    {
        CCLOG("GameDevice::vibrate method missed!");
    }
}

#endif