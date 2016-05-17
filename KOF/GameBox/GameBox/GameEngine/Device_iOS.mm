//
//  Device_iOS.m
//  GameBox
//
//  Created by Caspar on 2013-4-23.
//
//
#include "cocos2d.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#include "Device.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//#include <net/if_types.h>

#include <ifaddrs.h>
#include <sys/types.h>

#import "RootViewController.h"
#import "Reachability.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


using namespace ptola;

CDevice::CDevice()
{
    memset( m_szIMEI, 0, sizeof(m_szIMEI) );
    setDeviceSupportOrientation( LandscapeLeft | LandscapeRight );
    reInitializeScreenSize();
    reInitializeDeviceIMEI();
    reInitializeOSVersion();
    reInitializeModel();
    reInitializeMAC();
    m_fHeightRatio = 1.0f;
}

CDevice::~CDevice()
{
    
}

enumNetworkStatus CDevice::getNetworkStatus()
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    return static_cast<enumNetworkStatus>( (int)[reachability currentReachabilityStatus] );
}

enumDeviceOrientation CDevice::getDeviceOrientation()
{
    switch( [[UIApplication sharedApplication] statusBarOrientation] )
    {
        case UIInterfaceOrientationLandscapeRight:
            return LandscapeRight;
        case UIInterfaceOrientationLandscapeLeft:
            return LandscapeLeft;
        case UIInterfaceOrientationPortraitUpsideDown:
            return PortraitUpsideDown;
        default:
            return Portrait;
    }
}

void CDevice::reInitializeScreenSize()
{
    m_sScreenSize.setSize( [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
}

void CDevice::reInitializeDeviceIMEI()
{
    int nRequestInfoBase[6];
    char szMsgBuffer[256];
    size_t uLength = 0;
    struct if_msghdr *pMsgHeader;
    struct sockaddr_dl *pSocketDL;


    nRequestInfoBase[0] = CTL_NET;
    nRequestInfoBase[1] = AF_ROUTE;
    nRequestInfoBase[2] = 0;
    nRequestInfoBase[3] = AF_LINK;
    nRequestInfoBase[4] = NET_RT_IFLIST;
    nRequestInfoBase[5] = if_nametoindex("en0");

    if( nRequestInfoBase[5] == 0 )
        return;

    if( sysctl(nRequestInfoBase, 6, NULL, &uLength, NULL, 0) < 0 )
        return;

    if( uLength > 256 )
        return;

    if( sysctl(nRequestInfoBase, 6, szMsgBuffer, &uLength, NULL, 0) < 0 )
        return;

    pMsgHeader = (struct if_msghdr *)szMsgBuffer;
    pSocketDL  = (struct sockaddr_dl *)(pMsgHeader + 1);
    unsigned char *pMacAddress = (unsigned char *)LLADDR(pSocketDL);
    sprintf(m_szIMEI, "%x%x%x%x%x%x", *(pMacAddress+0),*(pMacAddress+1),*(pMacAddress+2),*(pMacAddress+3),*(pMacAddress+4),*(pMacAddress+5));
}

void CDevice::reInitializeMAC()
{
    memset(m_szMAC, 0, sizeof(m_szMAC));
    struct ifaddrs *addrs;
    if( getifaddrs(&addrs) != 0 )
        return;
    ifaddrs *pAddrs = addrs;
    while( pAddrs != NULL )
    {
        if( (pAddrs->ifa_addr->sa_family == (sa_family_t)AF_LINK)
           && (((const struct sockaddr_dl *)pAddrs->ifa_addr)->sdl_type == 0x6)//IFT_ETHER)
           && strcmp("en0", pAddrs->ifa_name) == 0)
        {
            const struct sockaddr_dl *dlAddr = (const struct sockaddr_dl *)pAddrs->ifa_addr;
            const unsigned char *base = (const unsigned char *)&dlAddr->sdl_data[dlAddr->sdl_nlen];
            for( int i = 0 ; i < dlAddr->sdl_alen; i++)
            {
                if( i != 0 )
                    strcat(m_szMAC, ":");
                char particalAddr[3];
                sprintf(particalAddr, "%02X", base[i]);
                strcat( m_szMAC, particalAddr);
            }
        }
        pAddrs = pAddrs->ifa_next;
    }
    freeifaddrs(addrs);
}

void CDevice::reInitializeOSVersion()
{
    strcpy(m_szOSVersion, [[[UIDevice currentDevice] systemVersion] UTF8String]);
}

void CDevice::reInitializeModel()
{
    strcpy(m_szModel, [[[UIDevice currentDevice] model] UTF8String]);
}

void CDevice::setDeviceOrientation(enumDeviceOrientation orientation)
{
    if( (m_nDeviceSupportOrientation & orientation) == 0 )
        return; // unsupportDeviceOrientation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    switch( [[UIApplication sharedApplication] statusBarOrientation] )
    {
        case UIInterfaceOrientationLandscapeRight:
            switch(orientation)
            {
                case Portrait:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformIdentity;
                    break;
                case PortraitUpsideDown:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformMakeRotation(-M_PI);
                    break;
                case LandscapeLeft:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformMakeRotation(M_PI * 1.5f);
                    break;
                default:break;
            }
            break;
        case UIInterfaceOrientationLandscapeLeft:
            switch(orientation)
            {
                case Portrait:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformIdentity;
                    break;
                case PortraitUpsideDown:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformMakeRotation(-M_PI);
                    break;
                case LandscapeRight:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformMakeRotation(M_PI / 2.0f);
                    break;
                default:break;
            }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            switch(orientation)
            {
                case Portrait:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformIdentity;
                    break;
                case LandscapeLeft:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformMakeRotation(M_PI * 1.5f);
                    break;
                case LandscapeRight:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformMakeRotation(M_PI / 2.0f);
                    break;
                default:break;
            }
            break;
        default:
            switch(orientation)
            {
                case PortraitUpsideDown:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformMakeRotation(-M_PI);
                    break;
                case LandscapeLeft:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformMakeRotation(M_PI * 1.5f);
                    break;
                case LandscapeRight:
                    [[RootViewController sharedInstance] view].transform = CGAffineTransformMakeRotation(M_PI / 2.0f);
                    break;
                default:break;
            }
            break;
    }
    [UIView commitAnimations];
}

void CDevice::vibrate(int ms)
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
#endif