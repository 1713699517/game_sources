#include "_APP_IOS_IAP.h"

#if (AGENT_SDK_CODE == 3)

#include <map>
#import "_APP_IOS_IAP_Bridge.h"
//#import <GameKit/GameKit.h>
//#import <CommonCrypto/CommonCrypto.h>
//#import <StoreKit/StoreKit.h>


static std::map<std::string,SProductInfo> s_ProductInfos;
static int s_ProductsCount = 0;
static IAPP_IOS_IAP *s_pCallbackInterface = NULL;
static _APP_IOS_IAP_Bridge *s_IAP_Bridge = [[_APP_IOS_IAP_Bridge alloc] init];

void CAPP_IOS_IAP::initialize(IAPP_IOS_IAP *pInterface)
{
    s_ProductInfos.clear();
    s_pCallbackInterface = pInterface;

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"config/product_ids"
                                         withExtension:@"plist"];
    NSArray *productIdentifiers = [NSArray arrayWithContentsOfURL:url];

    s_ProductsCount = (int)[productIdentifiers count];

    [s_IAP_Bridge loadProducts:productIdentifiers cbtarget:this cbmethod:(LP_IAP_PRODUCT_RESPONSE_CALLBACK)(&CAPP_IOS_IAP::onProductInfoCallback) cbmethod2:(LP_IAP_PRODUCT_PURCHASED_CALLBACK)(&CAPP_IOS_IAP::onPurchasedProduct)];
}



CAPP_IOS_IAP *CAPP_IOS_IAP::sharedAPP_IOS_IAP()
{
    static CAPP_IOS_IAP iap;
    return &iap;
}

void CAPP_IOS_IAP::pay(const char *lpcszProductID)
{
    std::map<std::string, SProductInfo>::iterator it = s_ProductInfos.find(lpcszProductID);
    if( it != s_ProductInfos.end() )
    {
        [s_IAP_Bridge promptConfirmDialog:lpcszProductID description:it->second.szDescription];
    }
}

void CAPP_IOS_IAP::onPurchasedProduct(const char *lpcszOrderID,const char *lpcszProductID, void *pData, size_t len)
{
    if( s_pCallbackInterface != NULL )
    {
        s_pCallbackInterface->onPurchasedProduct(lpcszOrderID,lpcszProductID, pData, len);
    }
}

void CAPP_IOS_IAP::onProductInfoCallback(const char *lpcszProductID, const char *lpcszTitle, const char *lpcszDescription, double dPrice)
{
    SProductInfo sInfo;
    sInfo.dPrice = dPrice;
    strcpy(sInfo.szProductName, lpcszTitle);
    strcpy(sInfo.szDescription, lpcszDescription);
    strcpy(sInfo.szProductID, lpcszProductID);

    s_ProductInfos[ sInfo.szProductID ] = sInfo;

    if( s_ProductsCount > 0 && s_ProductInfos.size() == s_ProductsCount )
    {
        if( s_pCallbackInterface != NULL )
        {
            s_pCallbackInterface->onProductInfoCallback();
        }
    }
}


const std::map<std::string, SProductInfo> &CAPP_IOS_IAP::getProductList()
{
    return s_ProductInfos;
}

SProductInfo *CAPP_IOS_IAP::getProductByProductID(const char *lpcszProductId)
{
    std::map<std::string,SProductInfo>::iterator it = s_ProductInfos.find(lpcszProductId);
    if( it != s_ProductInfos.end() )
    {
        return &it->second;
    }
    else
    {
        return NULL;
    }
}
#endif