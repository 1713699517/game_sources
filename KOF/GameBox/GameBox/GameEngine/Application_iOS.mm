//
//  Application_iOS.mm
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//
#include "cocos2d.h"

#if( CC_TARGET_PLATFORM == CC_PLATFORM_IOS )
#include "Application.h"
#include "ptola.h"

USING_NS_CC;
using namespace ptola;

CApplication::CApplication()
{
    reInitializeStartupPath();
    reInitializeResourcePath();
    reInitializeBundleVersion();
}

CApplication::~CApplication()
{

}



void CApplication::reInitializeStartupPath()
{
    m_strStartupPath = [[[NSBundle mainBundle] bundlePath] UTF8String];
}

void CApplication::reInitializeResourcePath()
{
//    m_strResourcePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"] UTF8String];

#ifdef LOCAL_VERSION
    m_strResourcePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"] UTF8String];
#else
    NSArray *caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *r = [[caches objectAtIndex:0] stringByAppendingString:@"/"];
    m_strResourcePath = [r UTF8String];
#endif
//    [r release];
//    [caches release];

//    m_strResourcePath = [[[NSBundle mainBundle] resourcePath] UTF8String];
}

void CApplication::reInitializeBundleVersion()
{
    CCDictionary *pDict = CCDictionary::createWithContentsOfFile("Info.plist");
    if( pDict != NULL )
    {
        CCString *pBundle = (CCString *)pDict->objectForKey("CFBundleVersion");
        if( pBundle != NULL )
        {
            m_strBundleVersion = pBundle->getCString();
            CCLOG("bundle version=%s", m_strBundleVersion.c_str());
        }
    }
    pDict->release();
}

#endif