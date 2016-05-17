//
//  UIWebViewBridge.m
//  GameBox
//
//  Created by Caspar on 2013-5-29.
//
//

#import "UIWebViewBridge.h"
#import "cocos2d.h"

@implementation UIWebViewBridge



-(id)init
{
    self = [super init];
    if( self )
    {
        m_pWebView = [[UIWebView alloc] init];
        [m_pWebView setDelegate: self];
    }
    return self;;
}

-(void)dealloc
{
    [m_pWebView loadHTMLString:@"" baseURL:nil];
    m_pWebView.delegate = nil;
    [m_pWebView removeFromSuperview];
    [m_pWebView dealloc];
    m_pWebView = nil;
    [super dealloc];
}

-(UIWebView *)getWebView
{
    return m_pWebView;
}


-(void)setPreferredSize:(CGSize)size
{
    CGPoint pos = [self getPosition];
    [m_pWebView setFrame:CGRectMake(pos.x, pos.y, size.width, size.height)];
}

-(CGSize)getPreferredSize
{
    return [m_pWebView frame].size;
}

-(void)setPosition:(CGPoint)pos
{
    CGSize size = [self getPreferredSize];
    [m_pWebView setFrame:CGRectMake(pos.x, pos.y, size.width, size.height)];
}

-(CGPoint)getPosition
{
    return [m_pWebView frame].origin;
}

-(void)loadGet:(NSString *)url httpHeaders:(NSDictionary *)headers requestBuffer:(NSData *)data target:(CCObject *)callTarget handler:(LP_WEBVIEW_CALLBACK)eventHandler
{
    m_pTarget = callTarget;
    m_pCallBack = eventHandler;
    [m_pWebView setUserInteractionEnabled:NO];
    NSURL *pUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *pRequest = [NSMutableURLRequest requestWithURL:pUrl];
    [pRequest setHTTPMethod:@"GET"];
    if( headers == nil )
    {
        for( NSString *key in headers )
        {
            [pRequest setValue:key forHTTPHeaderField: [headers objectForKey:key]];
        }
    }
    if( data != nil )
    {
        [pRequest setHTTPBody:data];
        
    }
    [m_pWebView loadRequest:pRequest];
}

-(void)loadPost:(NSString *)url httpHeaders:(NSDictionary *)headers requestBuffer:(NSData *)data target:(cocos2d::CCObject *)callTarget handler:(LP_WEBVIEW_CALLBACK)eventHandler
{
    m_pTarget = callTarget;
    m_pCallBack = eventHandler;
    [m_pWebView setUserInteractionEnabled:NO];
    NSURL *pUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *pRequest = [NSMutableURLRequest requestWithURL:pUrl];
    [pRequest setHTTPMethod:@"POST"];
    if( headers == nil )
    {
        for( NSString *key in headers )
        {
            [pRequest setValue:key forHTTPHeaderField: [headers objectForKey:key]];
        }
    }
    if( data != nil )
    {
        [pRequest setHTTPBody:data];

    }
    [m_pWebView loadRequest:pRequest];
}





-(void)setOverrideCallBack:(CCObject *)target overrideCallBack:(LP_OVERRIDE_WEBVIEW_URL_CALLBACK)callback
{
    m_pOverrideTarget = target;
    m_pOverrideCallBack = callback;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if( m_pOverrideTarget != NULL && m_pOverrideCallBack != NULL )
    {
        return (m_pOverrideTarget->*m_pOverrideCallBack)( [[[request URL] absoluteString] UTF8String]) ? NO : YES;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView setUserInteractionEnabled:YES];
    
    if( m_pTarget != NULL && m_pCallBack != NULL )
    {
        (m_pTarget->*m_pCallBack)();
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] == -999 )
    {
        return;
    }
    UIAlertView *pAlert = [[UIAlertView alloc]
                           initWithTitle:@"Error" message:[error localizedDescription]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

    [pAlert show];
    [pAlert release];
}
@end
