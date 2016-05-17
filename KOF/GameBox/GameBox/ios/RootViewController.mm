//
//  GameBoxAppController.h
//  GameBox
//
//  Created by Caspar on 13-4-23.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import "RootViewController.h"
#include "Device.h"

#include "Device.h"
#include "Application.h"
#include "LoginHttpApi.h"
#include "DateTime.h"
#include "AWebView.h"

using namespace ptola;
using namespace ptola::gui;

@implementation RootViewController

static RootViewController *theRootController = nil;

+(id)sharedInstance
{
    return theRootController;
}


+(void)setInstance:(id)value
{
    theRootController = value;
#if( AGENT_SDK_CODE == 5)
    [[PPAppPlatformKit sharedInstance] setDelegate:value];
#endif
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
 
*/
// Override to allow orientations other than the default portrait orientation.
// This method is deprecated on ios6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (ptola::CDevice::sharedDevice()->getDeviceSupportOrientation() & interfaceOrientation) != 0;
//    return YES;
//    return UIInterfaceOrientationIsLandscape( interfaceOrientation );
}

// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
- (NSUInteger) supportedInterfaceOrientations{
    return (ptola::CDevice::sharedDevice()->getDeviceSupportOrientation() << 1);
//#ifdef __IPHONE_6_0
//    return UIInterfaceOrientationMaskLandscape;
//#endif
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}






#if( AGENT_SDK_CODE == 5)

- (void)ppPayResultCallBack:(PPPayResultCode)paramPPPayResultCode
{
    
}
/**
 * @brief   验证更新成功后
 * @noti    分别在非强制更新点击取消更新和暂无更新时触发回调用于通知弹出登录界面
 * @return  无返回
 */
- (void)ppVerifyingUpdatePassCallBack
{
    [[PPAppPlatformKit sharedInstance] showLogin];
}
/**
 * @brief   登录成功回调【任其一种验证即可】
 * @param   INPUT   paramStrToKenKey       字符串token
 * @return  无返回
 */
- (void)ppLoginStrCallBack:(NSString *)paramStrToKenKey
{
    const char *_account = [[[PPAppPlatformKit sharedInstance] currentUserName] UTF8String];
    ptola::CDateTime nowTime;
    int nLocalTime          = nowTime.getTotalSeconds();
    char szLocalTime[32]    = {0};
    sprintf(szLocalTime, "%d", nLocalTime);


    std::string strSessionId = CCUserDefault::sharedUserDefault()->getStringForKey("sid", "");
    const char *lpcszSessionId  = strSessionId.c_str();

    CDefaultLoginBehavior *pSender = new CDefaultLoginBehavior;
    pSender->autorelease();

    CLoginHttpApi::setInternalVerify(false);

    CLoginHttpApi::httpVerify( CID_w_217, CWebView::urlEncode(_account), ptola::CDevice::sharedDevice()->getMAC(), ptola::CApplication::sharedApplication()->getBundleVersion(),
                              "Android", SDK_SOURCE_FROM, SDK_SOURCE_SUB_FROM, szLocalTime,
                              PRIVATEKEY_W_217, lpcszSessionId, pSender, callfuncND_selector(CDefaultLoginBehavior::defaultHttpVerify) );
}


/**
 * @brief   关闭Web页面后的回调
 * @param   INPUT   paramPPWebViewCode    接口返回的页面编码
 * @return  无返回
 */
- (void)ppCloseWebViewCallBack:(PPWebViewCode)paramPPWebViewCode
{

}
/**
 * @brief   关闭SDK客户端页面后的回调
 * @param   INPUT   paramPPPageCode       接口返回的页面编码
 * @return  无返回
 */
- (void)ppClosePageViewCallBack:(PPPageCode)paramPPPageCode
{
    if( paramPPPageCode == PPCenterViewPageCode )
    {
        return;
    }
    else
    {
        CCDirector::sharedDirector()->end();
#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        exit(EXIT_SUCCESS);
#endif
    }
}
/**
 * @brief   注销后的回调
 * @return  无返回
 */
- (void)ppLogOffCallBack
{

}
#endif
@end
