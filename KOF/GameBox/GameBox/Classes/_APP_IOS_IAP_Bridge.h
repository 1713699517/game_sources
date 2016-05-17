//
//  _APP_IOS_IAP_Bridge.h
//  GameBox
//
//  Created by Caspar on 13-11-25.
//
//

#ifndef _APP_IOS_IAP_BRIDGE_H__
#define _APP_IOS_IAP_BRIDGE_H__

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import <StoreKit/StoreKit.h>

#import "GTMBase64.h"
#import "_APP_IOS_IAP.h"

#if (AGENT_SDK_CODE == 3)

USING_NS_CC;

@interface _APP_IOS_IAP_Bridge : NSObject< SKProductsRequestDelegate , UIAlertViewDelegate, SKPaymentTransactionObserver >
{
    CCObject *m_pCallbackTarget;
    LP_IAP_PRODUCT_RESPONSE_CALLBACK m_pCallBack;
    LP_IAP_PRODUCT_PURCHASED_CALLBACK m_pPurchasedCallBack;
    NSArray *m_pProducts;
}

-(id) init;

-(void) loadProducts:(NSArray *) product_ids
            cbtarget:(CCObject *) target
            cbmethod:(LP_IAP_PRODUCT_RESPONSE_CALLBACK) callback
           cbmethod2:(LP_IAP_PRODUCT_PURCHASED_CALLBACK) callback2;

-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;

-(void) promptConfirmDialog:(const char *)lpcszProductID
                description:(const char *)lpcszDescription;


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
@end

#endif

#endif