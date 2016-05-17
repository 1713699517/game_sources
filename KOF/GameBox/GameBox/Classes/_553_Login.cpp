//
//  _553_Login.cpp
//  GameBox
//
//  Created by Caspar on 13-8-26.
//
//

#include "_553_Login.h"

#if (AGENT_SDK_CODE == 1 || AGENT_SDK_CODE == 6 || AGENT_SDK_CODE == 3 )

#include "Device.h"
#include "CCCrypto.h"
#include "MD5Crypto.h"
#include "DateTime.h"
#include "json.h"
#include "Application.h"
#include "LoginHttpApi.h"
#include "cocos-ext.h"
#include "AWebView.h"
#include "UserCache.h"
#include "RechargeScene.h"

using namespace ptola;
using namespace cocos2d::extension;
using namespace Json;

C553_Login::C553_Login()
{

}

bool C553_Login::init()
{
    if( !CCLayer::init() )
        return false;

    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    CCSprite *pBackground = CCSprite::create("Loading/loading2_underframe.jpg");
    pBackground->setPosition(ccp(visibleSize.width/2, visibleSize.height/2));
    addChild(pBackground);
    
    CCSize portaitDeviceSize = CDevice::sharedDevice()->getScreenSize();

    m_pWebView = CWebView::create();
    m_pWebView->setOverrideCallBack(this, (LP_OVERRIDE_WEBVIEW_URL_CALLBACK)(&C553_Login::shouldOverrideUrl));


#if( CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    m_pWebView->setPreferredSize(CCSizeMake(portaitDeviceSize.height,portaitDeviceSize.width));
#elif( CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    m_pWebView->setPreferredSize(CCSizeMake(portaitDeviceSize.width,portaitDeviceSize.height));
#endif
    char szUrl[1024] = {0};
    getUrl( szUrl, 1024);
    m_pWebView->loadGet(szUrl);
    addChild(m_pWebView);
    return true;
}

CCScene *C553_Login::scene()
{
    CCScene *pScene = CCScene::create();
    if( pScene != NULL )
    {
        C553_Login *pLogin = C553_Login::create();
        if( pLogin != NULL )
        {
            pScene->addChild(pLogin);
        }
        else
        {
            CC_SAFE_DELETE(pScene);
        }
    }
    return pScene;
}

void C553_Login::getUrl(char *lpszUrl, size_t uLength)
{
    char szTmp[256] = {0};
    strcpy(lpszUrl, AGENT_553_SDK_LOGIN_HOST);
    strcat(lpszUrl, "?ac=logon&time=");

    struct cocos2d::cc_timeval now;
    CCTime::gettimeofdayCocos2d(&now, NULL);
    sprintf(szTmp, "%ld", now.tv_sec );
    strcat( lpszUrl, szTmp );

    strcat(lpszUrl, "&sn=");
    strcat(lpszUrl, CDevice::sharedDevice()->getMAC());

    strcat(lpszUrl, "&v=i1&sign=");

    sprintf(szTmp, "%ld%si1%s", now.tv_sec, CDevice::sharedDevice()->getMAC(), "w75d4fsd6^&w8a7a;4d52");
    strcat(lpszUrl, CMD5Crypto::md5(szTmp, strlen(szTmp)) );

    std::string strSessionId = CCUserDefault::sharedUserDefault()->getStringForKey("sid", "");
    strcat(lpszUrl, "&sid=");
    strcat(lpszUrl, strSessionId.c_str());

    strcat(lpszUrl, "&serverid=74&fid=211000");

    //strcpy(lpszUrl, "http://www.baidu.com");
}

bool C553_Login::shouldOverrideUrl(const char *lpcszUrl)
{
    std::string urlToCheck( urlDecode(lpcszUrl));
    char szHostUrl[1024] = {0};
    strcpy(szHostUrl, AGENT_553_SDK_LOGIN_HOST);
    strcat(szHostUrl, "p=");
    size_t hostLength = strlen(szHostUrl);
    if( strncasecmp(szHostUrl, lpcszUrl, hostLength) == 0 )
    {
        std::string strJson = (char *)(((char *)urlToCheck.c_str()) + hostLength);
        parseJsonResultData(strJson.c_str());
        return true;
    }
    return false;
}

void C553_Login::parseJsonResultData(const char *lpcszJsonData)
{
    Json::Value retJson;
    Json::Reader jsonReader;

    if( jsonReader.parse(lpcszJsonData, retJson) )
    {
        int nState = retJson["state"].asInt();
        switch( nState )
        {
            case 0:
            {
                const char *lpcszAccount = retJson["username"].asCString();
                CDateTime nowTime;
                int nLocalTime          = nowTime.getTotalSeconds();
                char szLocalTime[32]    = {0};
                sprintf(szLocalTime, "%d", nLocalTime);
                
                const char *lpcszSessionId  = retJson["sid"].asCString();                CCUserDefault::sharedUserDefault()->setStringForKey("sid", lpcszSessionId);
                CCUserDefault::sharedUserDefault()->flush();
                CLoginHttpApi::httpVerify(CID_w_217, CWebView::urlEncode(lpcszAccount), CDevice::sharedDevice()->getMAC(), CApplication::sharedApplication()->getBundleVersion(),
#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
                                          "iOS"
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
                                          "Android"
#endif
                                          , SDK_SOURCE_FROM, SDK_SOURCE_SUB_FROM, szLocalTime, PRIVATEKEY_W_217, lpcszSessionId, this, callfuncND_selector(C553_Login::onJJAPIResponsed));
                return;
            }
                break;
            case 1:
                CCMessageBox("签名错误", "Error");
                break;
            case 2:
                CCMessageBox("帐号应该为5～17位字母或数字", "Error");
                break;
            case 3:
                CCMessageBox("密码应该为6-17位字母或数字", "Error");
                break;
            case 4:
                CCMessageBox("密码中不能有特殊字符", "Error");
                break;
            case 5:
                CCMessageBox("版本错误", "Error");
                break;
            case 8:
                CCMessageBox("密码不相同,请重新输入", "Error");
                break;
            case 9:
                CCMessageBox("此帐号已经被使用,请重新输入", "Error");
                break;
            case 27:
                CCMessageBox("密码错误", "Error");
                break;
            case 99:
                CCMessageBox("没有username或sid", "Error");
                break;
            default:
                break;
        }
        char szUrl[1024] = {0};
        getUrl( szUrl, 1024);
        m_pWebView->loadGet(szUrl);
    }
    else
    {
        CCMessageBox(lpcszJsonData, "json parse error");
    }
}

std::string C553_Login::urlDecode(const std::string& strToDecode)
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

void C553_Login::onJJAPIResponsed(cocos2d::CCNode *pSender, void *pResponseData)
{

    CCHttpResponse *pResponse = (CCHttpResponse *)pResponseData;
    if( pResponse == NULL || !pResponse->isSucceed() )
    {
        CCMessageBox("Response faild!", "Error!");                                                                                                                                                                                                                                                                                   
        return;
    }

    CCHttpRequest *pRequest = pResponse->getHttpRequest();
    if( pRequest == NULL || strcmp(pRequest->getTag(), "Caspar_Login_Request") != 0)
    {
        CCLOG("Response Tag Error!");
        return;
    }

    std::vector<char> *pResponseBuffer = pResponse->getResponseData();
    std::string strBuffer( pResponseBuffer->begin(), pResponseBuffer->end() );

    Json::Value retJson;
    Json::Reader jsonReader;
    if( jsonReader.parse(strBuffer.c_str(), retJson) )
    {
        int nRef = retJson["ref"].asInt();
        if( nRef == 1 )
        {

            for( Value::iterator it = retJson.begin(); it != retJson.end(); it++ )
            {
                const char *lpcszMemberName = it.memberName();
                if( strcasecmp(lpcszMemberName, "account") == 0 )
                {
                    CUserCache::sharedUserCache()->setObject("userName", (*it).asCString());
                    CRechargeScene::setRechargeData("username", (*it).asCString());
                }
            }
        }
    }
    CLoginHttpApi::httpVerifyCallBack(pSender, pResponseData);
}

#endif