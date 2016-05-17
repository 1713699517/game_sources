//
//  LoginHttpApi.h
//  GameBox
//
//  Created by Caspar on 13-5-22.
//
//

#ifndef __GameBox__LoginHttpApi__
#define __GameBox__LoginHttpApi__

#include "cocos2d.h"

USING_NS_CC;

class CLoginHttpApi : public CCObject
{
public:
    static void setInternalVerify(bool bInternalVerify);
    static bool getInternalVerify();
    
    static void httpVerify( const char *lpcszCid, const char *lpcszAccount, const char *lpcszMac, const char *lpcszVersions, const char *lpcszOS, const char *lpcszSource, const char *lpcszSourceSub, const char *lpcszTime, const char *lpcszKey, const char *lpcszSessionId,CCObject *pTarget, SEL_CallFuncND _successSelector );

    static void httpVerifyCallBack(CCObject *pSender, void *pData);
};

class CDefaultLoginBehavior : public CCObject
{
public:
    void defaultHttpVerify(CCObject *pSender, void *pData);
};


#endif /* defined(__GameBox__LoginHttpApi__) */
