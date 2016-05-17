//
//  JNI_GameBox.c
//  GameBox
//
//  Created by Caspar on 2013-6-6.
//
//



#include "JNI_GameBox.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include "DateTime.h"
#include "Device.h"
#include "Application.h"
#include "misc/json.h"
#include "platform/android/jni/JniHelper.h"

#include "../Classes/Constant.h"
#include "../Classes/LoginHttpApi.h"
#include "../Classes/LoginVerifyLua.h"

USING_NS_CC;
using namespace ptola;



JNIEXPORT void JNICALL Java_com_ptola_GameApp_nativeClose(JNIEnv *env, jobject thiz)
{
    cocos2d::CCDirector::sharedDirector()->end();
};

JNIEXPORT void JNICALL Java_com_ptola_GameApp_nativeVerify(JNIEnv *env, jobject thiz, jstring _account)
{
    CDateTime nowTime;
    int nLocalTime          = nowTime.getTotalSeconds();
    char szLocalTime[32]    = {0};
    sprintf(szLocalTime, "%d", nLocalTime);

    std::string strSessionId = CCUserDefault::sharedUserDefault()->getStringForKey("sid", "");
    const char *lpcszSessionId  = strSessionId.c_str();
    CDefaultLoginBehavior *pSender = new CDefaultLoginBehavior;
    pSender->autorelease();
    std::string strResult = JniHelper::jstring2string(_account);
    CLoginHttpApi::httpVerify( CID_w_217, strResult.c_str(), CDevice::sharedDevice()->getMAC(), CApplication::sharedApplication()->getBundleVersion(),
                              "Android", SDK_SOURCE_FROM, SDK_SOURCE_SUB_FROM, szLocalTime,
                              PRIVATEKEY_W_217, lpcszSessionId, pSender, callfuncND_selector(CDefaultLoginBehavior::defaultHttpVerify) );
};

JNIEXPORT void JNICALL Java_com_ptola_GameApp_nativeExecuteCommand(JNIEnv *env, jobject thiz, jint nCommand )
{
    LUA_EXECUTE_COMMAND( (int)nCommand );
};

#endif  //end CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID