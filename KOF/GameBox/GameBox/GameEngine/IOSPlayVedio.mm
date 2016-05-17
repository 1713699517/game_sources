//
//  IOSPlayVedio.cpp
//  VedioTest
//
//  Created by Himi on 12-10-10.
//
//
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)


#include "IOSPlayVedio.h"
#include "../ios/AppController.h"

void IOSPlayVedio::playVedio4iOS(char *name){
//    char *cName = name;
    NSString *nsName = [[NSString alloc] initWithCString:name];
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app playVideo:nsName];
}

bool IOSPlayVedio::isPlaying(){
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    return [app isPlaying];
}

void IOSPlayVedio::cancelPlaying()
{
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    [app cancelPlaying];
}

#endif