//
//  UUID_iOS.mm
//  GameBox
//
//  Created by Caspar on 13-8-27.
//
//

#include "UUID.h"

#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#import <CoreFoundation/CFUUID.h>

using namespace ptola;

static char g_szUUIDBuffer[64];

const char *CUUID::create()
{
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    strcpy( g_szUUIDBuffer, [uuidStr UTF8String]);
    [uuidStr release];
    CFRelease(uuidObject);
    return g_szUUIDBuffer;
}

#endif