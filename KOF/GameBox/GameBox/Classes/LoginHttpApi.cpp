//
//  LoginHttpApi.cpp
//  GameBox
//
//  Created by Caspar on 13-5-22.
//
//

#include "LoginHttpApi.h"

#include "Device.h"
#include "CCCrypto.h"
#include "DateTime.h"
#include "MD5Crypto.h"
#include "AWebView.h"
#include "Constant.h"
#include "LuaScriptFunctionInvoker.h"

#include "json.h"
#include "cocos-ext.h"

#include "MemoryManager.h"

using namespace Json;

using namespace cocos2d;
using namespace ptola;
using namespace ptola::io;
using namespace ptola::memory;
USING_NS_CC_EXT;


static bool s_bInternalVerify = false;

void CLoginHttpApi::setInternalVerify(bool bInternalVerify)
{
    s_bInternalVerify = bInternalVerify;
}

bool CLoginHttpApi::getInternalVerify()
{
    return s_bInternalVerify;
}

void CLoginHttpApi::httpVerify(const char *lpcszCid, const char *lpcszAccount, const char *lpcszMac,
                               const char *lpcszVersions, const char *lpcszOS, const char *lpcszSource,
                               const char *lpcszSourceSub, const char *lpcszTime, const char *lpcszKey,
                               const char *lpcszSessionId,
                               CCObject *pTarget, SEL_CallFuncND _Selector)
{
    //
    char szUrl[1024]     = {0};

    if( s_bInternalVerify )
    {
        sprintf(szUrl, PHONE_LOGIN_URL, INTERNAL_SDK_HOST);
    }
    else
    {
        sprintf(szUrl, PHONE_LOGIN_URL, SDK_HOST);
    }
    //cid
    char szParams[1024]  = {0};
    char szParams2[1024] = {0};
    strcat(szParams, "cid=");
    strcat(szParams, lpcszCid);
    //account
    strcat(szParams, "&account=");
    strcat(szParams, lpcszAccount);
    //mac
    strcat(szParams, "&mac=");
    strcat(szParams, lpcszMac);
    //versions
    strcat(szParams, "&versions=");
    strcat(szParams, lpcszVersions);
    //os
    strcat(szParams, "&os=");
    strcat(szParams, lpcszOS);
    //source
    strcat(szParams, "&source=");
    strcat(szParams, lpcszSource);
    //source_sub
    strcat(szParams, "&source_sub=");
    strcat(szParams, lpcszSourceSub);
    //time
    strcat(szParams, "&time=");
    strcat(szParams, lpcszTime);

    strcpy(szParams2, szParams);

    //key
    strcat(szParams, "&key=");
    strcat(szParams, lpcszKey);

    std::string strSign = CMD5Crypto::md5(szParams, strlen(szParams));

    strcat(szParams2, "&sign=");
    strcat(szParams2, strSign.c_str());
    
    strcat(szParams2, "&session=");
    strcat(szParams2, lpcszSessionId);

    CCLOG("%s?%s", szUrl, szParams2);
    CCHttpRequest *pRequest = new CCHttpRequest();
    pRequest->setUrl(szUrl);
    pRequest->setRequestType(CCHttpRequest::kHttpPost);
    pRequest->setRequestData(szParams2, strlen(szParams2));
    pRequest->setResponseCallback(pTarget, _Selector);
    pRequest->setTag("Caspar_Login_Request");
    CCHttpClient::getInstance()->send(pRequest);
    pRequest->release();
}

void CLoginHttpApi::httpVerifyCallBack(cocos2d::CCObject *pSender, void *pData)
{
    // CCHttpResponse *pResponse = (CCHttpResponse *)pData;
    // if( pResponse == NULL || !pResponse->isSucceed() )
    // {
    //     CCMessageBox("Response faild!", "Error!");
    //     return;
    // }

    // CCHttpRequest *pRequest = pResponse->getHttpRequest();
    // if( pRequest == NULL || strcmp(pRequest->getTag(), "Caspar_Login_Request") != 0)
    // {
    //     CCLOG("Response Tag Error!");
    //     return;
    // }

    // std::vector<char> *pResponseBuffer = pResponse->getResponseData();
    // std::string strBuffer( pResponseBuffer->begin(), pResponseBuffer->end() );
    CCLOG("CLoginHttpApi::httpVerifyCallBack begin");
    std::string strBuffer = "{\"ref\":\"1\",\"account\":\"aaa\",\"uuid\":\"110\"}";

    Json::Value retJson;
    Json::Reader jsonReader;

    retJson["ref"] = Json::Value(1);
    retJson["account"] = Json::Value("aaa");
    retJson["uuid"] = Json::Value("110");
    
    // if( jsonReader.parse(strBuffer.c_str(), retJson) )
    {
        int nRef = retJson["ref"].asInt();
        if( nRef == 1 )
        {
            CCScriptEngineProtocol * pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
            if( pEngine == NULL )
                return;
            CCLuaEngine *pLuaEngine = dynamic_cast<CCLuaEngine *>(pEngine);
            if( pLuaEngine == NULL)
                return;
            CCLuaStack *pLuaStack = pLuaEngine->getLuaStack();
            if( pLuaStack == NULL )
                return;

            lua_State *L = pLuaStack->getLuaState();

            lua_getglobal(L, "LoginInfo");
            if( lua_isnil(L, -1) )
            {
                lua_newtable(L);
                lua_pushstring(L, "LoginInfo");
                lua_newtable(L);
                lua_settable(L, -3);
                lua_setglobal(L, "LoginInfo");
            }
            lua_pop(L, 1);
            lua_getglobal(L, "LoginInfo");
            if( lua_isnil(L, -1) )
            {
                lua_pushstring(L, "LoginInfo table create error!");
                lua_error(L);
                lua_pop(L, 1);
                return;
            }
            for( Value::iterator it = retJson.begin(); it != retJson.end(); it++ )
            {
                //
                if( strcasecmp(it.memberName(), "uuid") == 0 )
                {
                    char szUUID[64];
                    if( (*it).type() == Json::intValue )
                    {
                        int uuid = (*it).asInt();
                        sprintf(szUUID, "%d", uuid);
                    }
                    else if( (*it).type() == Json::stringValue )
                    {
                        strcpy(szUUID, (*it).asCString() );
                    }
                    CCUserDefault::sharedUserDefault()->setStringForKey("uuid", szUUID);
                }
                lua_pushstring(L, it.memberName());
                switch( (*it).type() )
                {
                    case Json::intValue:
                        lua_pushinteger(L, (*it).asInt());
                        break;
                    case Json::realValue:
                        lua_pushnumber(L, (*it).asFloat());
                        break;
                    case Json::stringValue:
                        lua_pushstring(L, (*it).asCString());
                        break;
                    case Json::booleanValue:
                        lua_pushboolean(L, (*it).asBool());
                        break;
                    default:
                        break;
                }
                lua_settable(L, -3);
            }
            lua_pop(L, 1);

            CCLOG("CLoginHttpApi::httpVerifyCallBack end");
            //open the memory detection
            //CMemoryManager::sharedMemoryManager()->startMemoryDetection();
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
            CCString* pstrFileContent = CCString::createWithContentsOfFile(LOGIN_EXECUTE_LUA);
            if (pstrFileContent)
            {
                pLuaEngine->executeString(pstrFileContent->getCString());
            }
#else
            std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename(LOGIN_EXECUTE_LUA);
            pLuaEngine->addSearchPath(path.substr(0, path.find_last_of("/")).c_str());
            pLuaEngine->executeScriptFile(path.c_str());
#endif

        }
        else
        {
            CCMessageBox(retJson["msg"].asCString(), "login valid!");
        }
    }
//    else
//    {
//        CCMessageBox(strBuffer.c_str(), "json parse error");
//    }
}

void CDefaultLoginBehavior::defaultHttpVerify(cocos2d::CCObject *pSender, void *pData)
{
    CLoginHttpApi::httpVerifyCallBack(pSender, pData);
}