//
//  UIWebViewBridge.h
//  GameBox
//
//  Created by Caspar on 2013-5-29.
//
//

#ifndef _PTOLA_UIWEBVIEW_BRIDGE_H__
#define _PTOLA_UIWEBVIEW_BRIDGE_H__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AWebView.h"

USING_NS_CC;

@interface UIWebViewBridge : NSObject<UIWebViewDelegate, UIAlertViewDelegate>
{
    UIWebView *m_pWebView;
    CCObject *m_pTarget;
    LP_WEBVIEW_CALLBACK m_pCallBack;

    CCObject *m_pOverrideTarget;
    LP_OVERRIDE_WEBVIEW_URL_CALLBACK m_pOverrideCallBack;
}

-(UIWebView *)getWebView;

-(void) setPreferredSize: (CGSize) size;
-(CGSize) getPreferredSize;

-(void) setPosition: (CGPoint) pos;
-(CGPoint) getPosition;

-(void) loadGet: (NSString *) url
        httpHeaders: (NSDictionary *) headers
        requestBuffer: (NSData *) data
         target: (CCObject *) callTarget
        handler: (LP_WEBVIEW_CALLBACK) eventHandler;

-(void) loadPost: (NSString *) url
    httpHeaders: (NSDictionary *) headers
  requestBuffer: (NSData *) data
         target: (CCObject *) callTarget
        handler: (LP_WEBVIEW_CALLBACK) eventHandler;

-(void) setOverrideCallBack: (CCObject *) target
           overrideCallBack: (LP_OVERRIDE_WEBVIEW_URL_CALLBACK) callback;
@end

#endif