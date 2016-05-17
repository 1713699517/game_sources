//
//  GameBoxAppController.h
//  GameBox
//
//  Created by Caspar on 13-4-23.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#include "Constant.h"
#import <UIKit/UIKit.h>

#if (AGENT_SDK_CODE == 5)
#import <PPAppPlatformKit/PPAppPlatformKit.h>
@interface RootViewController : UIViewController<PPAppPlatformKitDelegate> {
#else
@interface RootViewController : UIViewController {
#endif

}


+(id)sharedInstance;
+(void)setInstance:(id)value;

@end
