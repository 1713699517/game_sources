//
//  GameBoxAppController.h
//  GameBox
//
//  Created by Caspar on 13-4-23.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//
#include "CCVideoPlayer.h"

@class RootViewController;

@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIApplicationDelegate, CCVideoPlayerDelegate> {
    UIWindow *window;
    RootViewController    *viewController;
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *viewController;

-(void)playVideo:(NSString*) name;
-(bool)isPlaying;
-(void)cancelPlaying;

@end

