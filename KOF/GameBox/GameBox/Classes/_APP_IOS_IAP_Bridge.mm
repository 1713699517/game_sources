//
//  _APP_IOS_IAP_Bridge.m
//  GameBox
//
//  Created by Caspar on 13-11-25.
//
//

#include "Constant.h"

#if (AGENT_SDK_CODE == 3)

#import "_APP_IOS_IAP_Bridge.h"
#import "cocos2d.h"



@implementation _APP_IOS_IAP_Bridge

-(id) init
{
    id ret = [super init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return ret;
}

-(void) loadProducts:(NSArray *) product_ids
            cbtarget:(CCObject *) target
            cbmethod:(LP_IAP_PRODUCT_RESPONSE_CALLBACK) callback
           cbmethod2:(LP_IAP_PRODUCT_PURCHASED_CALLBACK)callback2
{
    m_pCallbackTarget = target;
    m_pCallBack = callback;
    m_pPurchasedCallBack = callback2;
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:product_ids]];
    productsRequest.delegate = self;
    [productsRequest start];
}

-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    m_pProducts = [[NSArray alloc] initWithArray:products];
    for( SKProduct *pProduct in products)
    {
        NSDecimalNumber *pPrice = [pProduct price];
        NSString *pTitle = [pProduct localizedTitle];
        NSString *pDesc = [pProduct localizedDescription];
        NSString *pID = [pProduct productIdentifier];

        if( m_pCallbackTarget != NULL && m_pCallBack != NULL )
        {
            (m_pCallbackTarget->*m_pCallBack)([pID UTF8String], [pTitle UTF8String], [pDesc UTF8String], [pPrice doubleValue]);
        }
    }
}


-(void) promptConfirmDialog:(const char *)lpcszProductID
                description:(const char *)lpcszDescription
{
    UIAlertView *pAlert = [[UIAlertView alloc]
                           initWithTitle:@"购买" message:[[NSString alloc] initWithUTF8String:lpcszDescription]  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [pAlert setAccessibilityValue: [[NSString alloc] initWithUTF8String:lpcszProductID]];

    [pAlert show];
    [pAlert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 1 )
    {   //OK button clicked
        NSString *pStrProductID = [alertView accessibilityValue];
        SKProduct *pProduct = nil;
        for( SKProduct *pPro in m_pProducts )
        {
            if( [[pPro productIdentifier] compare:pStrProductID] == NSOrderedSame)
            {
                pProduct = pPro;
                break;
            }
        }
        if( pProduct != NULL )
        {
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:pProduct];
            [payment setQuantity:1];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
        //CCLOG("%s", [pStrProductID UTF8String]);
        [pStrProductID release];
    }

}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for( SKPaymentTransaction *transaction in transactions )
    {
        switch(transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:     // Transaction is in queue, user has been charged.  Client should complete the transaction.
            {
                //NSData *pData = [transaction transactionReceipt] ;

                if( m_pCallbackTarget != NULL && m_pPurchasedCallBack != NULL )
                {

                    NSString *pStrData = [GTMBase64 stringByEncodingData:[transaction transactionReceipt]];

//                    char *pData = new char[ [[transaction transactionReceipt] length] ];
//                    [[transaction transactionReceipt] getBytes:pData length:[[transaction transactionReceipt] length]];
                    
                    (m_pCallbackTarget->*m_pPurchasedCallBack)( [[transaction transactionIdentifier] UTF8String], [[[transaction payment] productIdentifier] UTF8String] , (void *)[pStrData UTF8String], [pStrData length]);
//                    delete[] pData;
                }
                //pPostStr
                [queue finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed:        // Transaction was cancelled or failed before being added to the server queue.
                if( [[transaction error] code] != SKErrorPaymentCancelled )
                {
                    CCMessageBox([[[transaction error] localizedDescription] UTF8String], [[[transaction error] localizedFailureReason] UTF8String]);
                }
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:       // Transaction was restored from user's purchase history.  Client should complete the transaction.

                break;
            default:    //SKPaymentTransactionStatePurchasing
                break;
        }
    }
}
@end
#endif