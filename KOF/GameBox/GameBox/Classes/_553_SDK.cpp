//
//  _553_SDK.cpp
//  GameBox
//
//  Created by wrc on 13-6-24.
//
//

#include "_553_SDK.h"
#include "Device.h"
#include "Constant.h"
#include "CCCrypto.h"
#include "MD5Crypto.h"
#include "DateTime.h"
#include "json.h"
#include "Application.h"
#include "LoginHttpApi.h"
#include "AWebView.h"


using namespace ptola;
using namespace ptola::gui;

C553_SDK::C553_SDK()
{
    
}

bool C553_SDK::init()
{
    if( !CCLayer::init() )
    {
        return false;
    }
    //PortraitSize
    CCSize portaitDeviceSize = CDevice::sharedDevice()->getScreenSize();

    m_pWebView = CWebView::create();
    m_pWebView->setOverrideCallBack(this, (LP_OVERRIDE_WEBVIEW_URL_CALLBACK)(&C553_SDK::shouldOverrideUrl));
#if( CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    m_pWebView->setPreferredSize(CCSizeMake(portaitDeviceSize.height,portaitDeviceSize.width));
#elif( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    m_pWebView->setPreferredSize(CCSizeMake(portaitDeviceSize.width,portaitDeviceSize.height));
#endif
    char szUrl[1024] = {0};
    getUrl( szUrl, 1024 );
    m_pWebView->loadGet(szUrl);

    //pWeb->loadGet(strUrl.c_str());
    addChild(m_pWebView);
    return true;
}

CCScene *C553_SDK::scene()
{
    CCScene *pScene = CCScene::create();
    if( pScene != NULL )
    {
        C553_SDK *pSdk = C553_SDK::create();
        if( pSdk != NULL )
        {
            pScene->addChild(pSdk);
        }
        else
        {
            CC_SAFE_DELETE(pScene);
        }
    }
    return pScene;
}


void C553_SDK::getUrl(char *lpszUrl, size_t uLength)
{
    snprintf(lpszUrl, uLength, SDK_LOGIN_URL, SDK_HOST);

    std::string strSessionId = CCUserDefault::sharedUserDefault()->getStringForKey("sid", "");

    char szSessionId[1024]  = {0};
    strcpy(szSessionId, strSessionId.c_str()); // by:yiping

    char szParam[1024]      = {0};
    char szParam2[1024]     = {0};
    //cid
    strcat(szParam, "cid=");
    strcat(szParam, CID_w_217);
    //mac
    strcat(szParam, "&mac=");
    strcat(szParam, CDevice::sharedDevice()->getDeviceIMEI());
    //versions
    strcat(szParam, "&versions=");
    strcat(szParam, CApplication::sharedApplication()->getBundleVersion());
    //os
    strcat(szParam, "&os=");
#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    strcat(szParam, "iOS");
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    strcat(szParam, "Android");
#endif
    //source
    strcat(szParam, "&source=");
    strcat(szParam, SDK_SOURCE_FROM);
    //source_sub
    strcat(szParam, "&source_sub=");
    strcat(szParam, SDK_SOURCE_SUB_FROM);
    //time
    strcat(szParam, "&time=");
    CDateTime nowTime;
    char szTimeStr[32] = {0};
    sprintf(szTimeStr, "%d", nowTime.getTotalSeconds() );
    strcat(szParam,  szTimeStr );
    strcpy(szParam2, szParam);

    //key
    strcat(szParam, "&key=");
    strcat(szParam, PRIVATEKEY_W_217);
    
    std::string strSign = CMD5Crypto::md5(szParam, strlen(szParam));

    strcat(szParam2, "&sign=");
    strcat(szParam2, strSign.c_str());
    
    strcat(szParam2, "&session=");
    strcat(szParam2, szSessionId);

    strcat( lpszUrl, "?" );
    strcat( lpszUrl, szParam2);
}


bool C553_SDK::shouldOverrideUrl(const char *lpcszUrl)
{
    //urldecode
    std::string urlToCheck = urlDecode(lpcszUrl);
    char szHostUrl[1024] = {0};
    strcpy(szHostUrl, SDK_HOST);
    
    sprintf(szHostUrl, SDK_REDIRECT_URL, SDK_HOST);
    size_t hostLength = strlen(szHostUrl);
    if( strncasecmp(szHostUrl, lpcszUrl, hostLength) == 0 )
    {
        std::string strJson = (char *)(((char *)urlToCheck.c_str()) + hostLength);

        std::string::size_type beginPos = strJson.find("{");
        std::string::size_type endPos = strJson.rfind("}");
        std::string strJsonParseData = strJson.substr(beginPos, endPos-beginPos+1);
        parseJsonResultData(strJsonParseData.c_str());
        return true;
    }
    return false;
}





void C553_SDK::parseJsonResultData(const char *lpcszJsonData)
{
    Json::Value retJson;
    Json::Reader jsonReader;

    if( jsonReader.parse(lpcszJsonData, retJson))
    {
        int nRef = retJson["ref"].asInt();
        if(nRef == 0)
        {
            const char *lpcszMessage = retJson["msg"].asCString();
            CCMessageBox(lpcszMessage, "Error!");
            return;
        }
        CDateTime nowTime;
        int nLocalTime          = nowTime.getTotalSeconds();
        char szLocalTime[32]    = {0};
        sprintf(szLocalTime, "%d", nLocalTime);
        
        int nRetTime                = retJson["time"].asInt();
        int nUuid                   = retJson["uuid"].asInt();           // 这个要存起来 给别的地方 与 下次 用 by:yiping
        const char *lpcszAccount    = retJson["account"].asCString();
        const char *lpcszSessionId  = retJson["session_id"].asCString(); // 这个要存起来 给别的地方 与 下次 用 by:yiping
        CCUserDefault::sharedUserDefault()->setStringForKey("sid", lpcszSessionId);
        CCUserDefault::sharedUserDefault()->flush();
        //mac,account,retTime,cid,version,source,key
        char szBuffer[1024];
        const char *lpcszMac            = CDevice::sharedDevice()->getDeviceIMEI();
        const char *lpcszBundleVersion  = CApplication::sharedApplication()->getBundleVersion();
        sprintf(szBuffer, "%s,%s,%d,%s,%d,%s", lpcszMac, lpcszAccount, nRetTime, CID_w_217, nUuid, PRIVATEKEY_W_217);
        const char *lpcszMD5Buffer      = CMD5Crypto::md5(szBuffer, strlen(szBuffer));
        if( strcmp(retJson["sign"].asCString(), lpcszMD5Buffer) == 0 )
        {
            if( abs(nLocalTime - nRetTime) <= 600 ) //10分钟
            {
                //本地服务验证
                CCLOG("webview verify successed!");
                CLoginHttpApi::httpVerify(CID_w_217, CWebView::urlEncode(lpcszAccount), lpcszMac, lpcszBundleVersion,
#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
                                        "iOS"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
                                        "Android"
#endif
                                          , SDK_SOURCE_FROM, SDK_SOURCE_SUB_FROM, szLocalTime, PRIVATEKEY_W_217,
                                          lpcszSessionId,
                                          this, callfuncND_selector(C553_SDK::onJJAPIResponsed));
                //
            }
        }
        else
        {
            CCMessageBox("sign valid!", "sign code error!");
        }
    }
    else
    {
        CCMessageBox("json parse error", lpcszJsonData);
    }
}

std::string C553_SDK::urlDecode(const std::string& strToDecode)
{
	std::string result;
	int hex = 0;
	for (size_t i = 0; i < strToDecode.length(); ++i)
	{
		switch (strToDecode[i])
		{
            case '+':
                result += ' ';
                break;
            case '%':
                if (isxdigit(strToDecode[i + 1]) && isxdigit(strToDecode[i + 2]))
                {
                    std::string hexStr = strToDecode.substr(i + 1, 2);
                    hex = strtol(hexStr.c_str(), 0, 16);
                    //字母和数字[0-9a-zA-Z]、一些特殊符号[$-_.+!*'(),] 、以及某些保留字[$&+,/:;=?@]
                    //可以不经过编码直接用于URL
                    if (!((hex >= 48 && hex <= 57) ||	//0-9
                          (hex >=97 && hex <= 122) ||	//a-z
                          (hex >=65 && hex <= 90) ||	//A-Z
                          //一些特殊符号及保留字[$-_.+!*'(),]  [$&+,/:;=?@]
                          hex == 0x21 || hex == 0x24 || hex == 0x26 || hex == 0x27 || hex == 0x28 || hex == 0x29
                          || hex == 0x2a || hex == 0x2b|| hex == 0x2c || hex == 0x2d || hex == 0x2e || hex == 0x2f
                          || hex == 0x3A || hex == 0x3B|| hex == 0x3D || hex == 0x3f || hex == 0x40 || hex == 0x5f
                          ))
                    {
                        result += char(hex);
                        i += 2;
                    }
                    else result += '%';
                }else {
                    result += '%';
                }
                break;
            default:
                result += strToDecode[i];
                break;
		}
	}
	return result;
}





//============
// JJAPI
//============
void C553_SDK::onJJAPIResponsed(cocos2d::CCNode *pSender, void *pResponseData)
{
    CLoginHttpApi::httpVerifyCallBack(pSender, pResponseData);
}
