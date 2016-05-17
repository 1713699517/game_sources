#ifndef __GameBox___APP_IOS_IAP__
#define __GameBox___APP_IOS_IAP__

#include "Constant.h"

#if (AGENT_SDK_CODE == 3)

#include "cocos2d.h"

USING_NS_CC;

typedef void (CCObject::*LP_IAP_CALLBACK)();
typedef void (CCObject::*LP_IAP_PRODUCT_RESPONSE_CALLBACK)(const char *lpcszProductID, const char *lpcszTitle, const char *lpcszDescription, double dPrice);
typedef void (CCObject::*LP_IAP_PRODUCT_PURCHASED_CALLBACK)(const char *lpcszOrderID,const char *lpcszProductID, void *pData, size_t len);

struct SProductInfo
{
    double dPrice;
    char szProductName[32];
    char szDescription[1024];
    char szProductID[32];
};

class IAPP_IOS_IAP
{
public:
    virtual void onProductInfoCallback() = 0;
    virtual void onPurchasedProduct(const char *lpcszOrderID,const char *lpcszProductID, void *pData, size_t len) = 0;
};

class CAPP_IOS_IAP : CCObject
{    
public:
    static CAPP_IOS_IAP *sharedAPP_IOS_IAP();
    SProductInfo *getProductByProductID(const char *lpcszProductId);
    void initialize(IAPP_IOS_IAP *pInterface);
    void pay(const char *lpcszProductID);
    const std::map<std::string, SProductInfo> &getProductList();

    void onPurchasedProduct(const char *lpcszOrderID,const char *lpcszProductID, void *pData, size_t len);
    void onProductInfoCallback(const char *lpcszProductID, const char *lpcszTitle, const char *lpcszDescription, double dPrice);
};

#endif

#endif