//
//  Constant.h
//  GameBox
//
//  Created by Caspar on 2013-5-24.
//
//

#ifndef GameBox_Constant_h
#define GameBox_Constant_h



//#define INTERNAL_SDK_HOST           "jjapi.appqj.com:80"
//#define SDK_HOST                    "jjapi.appqj.com"

#define SDK_LOGIN_URL               "http://%s/api/PhoneSDK/Login"
#define PHONE_UPDATE_URL            "http://%s/api/Phone/UpdateXml?"
#define PHONE_LOGIN_URL             "http://%s/api/Phone/Login"
#define APP_LOGIN_URL               "http://%s/api/PhoneSDK/AppLogin"
#define APP_REGISTER_URL            "http://%s/api/PhoneSDK/AppRegister"
#define APP_FORGET_URL              "http://%s/api/PhoneSDK/AppPasswd"
#define SDK_SOURCE_FROM             "testSource"
#define SDK_SOURCE_SUB_FROM         "testSourceSub"
#define SDK_REDIRECT_URL            "http://%s/p="

//#define LOGIN_EXECUTE_LUA           "hello.lua"
#define LOGIN_EXECUTE_LUA           "main.lua"


//-----------------------------------
//SDK宏
/*
 SDK 接口代码
 1 553 通用
 2 360 Android SDK
 3 AppStore
 4 553 Android SDK
 5 PP iOS SDK
 6 553 iOS SDK
 7 xiaomi Android SDK
 
 8 OPPO Android SDK
 9 91 Android SDK
 10 UC Android SDK
 11 UC IOS SDK
 12 baidu Android SDK
 */

#define AGENT_SDK_CODE  3



#if (AGENT_SDK_CODE == 5)               //PP
    #define CID_w_217                   "103"
    #define PRIVATEKEY_W_217            "fc9789fbf6c9bc21896838c9e6dfc556"
#elif (AGENT_SDK_CODE == 3)             //AppStore
    #define CID_w_217                   "888"
    #define PRIVATEKEY_W_217            "adcce67aaf39c160d16aa6bb7a980375"
#elif (AGENT_SDK_CODE == 2)             //360 Android
    #define CID_w_217                   "360"
    #define PRIVATEKEY_W_217            "888ebb1b1af19eacaeb5d5017b87e769"
#elif (AGENT_SDK_CODE == 7)             //小米
    #define CID_w_217                   "203"
    #define PRIVATEKEY_W_217            "d7e78887cd5c6e9c523948cba7cfa765"
#elif (AGENT_SDK_CODE == 8)             //oppo Android
    #define CID_w_217                   "503"
    #define PRIVATEKEY_W_217            "bd99048641a8292651e22bfc8f0dcb07"
#elif (AGENT_SDK_CODE == 9)             //91
    #define CID_w_217                   "403"
    #define PRIVATEKEY_W_217            "6bb3930b8a0a59b219058444b7bd768f"
#elif (AGENT_SDK_CODE == 10)             //UC
    #define CID_w_217                   "603"
    #define PRIVATEKEY_W_217            "10498844eff809284cf8928bbd6ef508"
#elif (AGENT_SDK_CODE == 12)             //baidu
    #define CID_w_217                   "303"
    #define PRIVATEKEY_W_217            "be525be70e795f63904bf4d3cf55f098"
#elif (AGENT_SDK_CODE == 13)            //豌豆夹
    #define CID_w_217                   "703"
    #define PRIVATEKEY_W_217            "a487b0c69e535a4c56c30c24999e743b"
#elif (AGENT_SDK_CODE == 4)            //553
    #define CID_w_217                   "553"
    #define PRIVATEKEY_W_217            "4b2784ed291cdb3bd28af21f7c64fbc4"
#else                                   //研发内部
    #define CID_w_217                   "217"
    #define PRIVATEKEY_W_217            "458f62446357f7787d22dfaf870dec1e"
#endif

//-----------------------------------

#define __NETWORK_TYPE__  2        //1:内网    2:外网

#if ( __NETWORK_TYPE__ == 1 )
#define INTERNAL_SDK_HOST           "192.168.1.9:89"
#define SDK_HOST                    "192.168.1.9:89"
#undef CID_w_217
#undef PRIVATEKEY_W_217
#define CID_w_217                   "217"
#define PRIVATEKEY_W_217            "458f62446357f7787d22dfaf870dec1e"
#elif ( __NETWORK_TYPE__ == 2 )
#define INTERNAL_SDK_HOST           "jjapi.appqj.com:80"
#define SDK_HOST                    "jjapi.appqj.com"
#endif
//-----------------------------------

//553 sdk
#define AGENT_553_SDK_LOGIN_HOST              "https://mapi.553.com/"
#define AGENT_553_SDK_RECHARGE_HOST           "http://pay.553.com/"





//360 sdk
//#define AGENT_SDK_LOGIN_HOST              "https://mapi.553.com/"
//#define AGENT_SDK_RECHARGE_HOST           "http://pay.553.com/"



//apple sdk

#define AGENT_APPSTORE_SDK_RECHARGE_HOST             "http://jjapi.appqj.com/api/CReturn/AppStore"







/** **********************************************************************************
 *  全局通用常量
 ** ********************************************************************************** */

/** AUfTO_CODE_BEGIN_Const **************** don't touch this line ********************/
/** =============================== 自动生成的代码 =============================== **/

/** =============================== 自动生成的代码 =============================== **/
/*************************** don't touch this line *********** AUTO_CODE_END_Conwst **/


/** *********************************************************************************
 小米             203
 360             360
 91              403
 oppo            503
 uc              603
 豌豆荚           703
 AppStor         888
 ** *********************************************************************************/


#endif
