//
//  Device.h
//  GameBox
//
//  Created by Caspar on 2013-4-23.
//
//

#ifndef __GameBox__Device__
#define __GameBox__Device__


#include "cocos2d.h"

#define SYSTEM_IMEI_LENGTH 32
#define SYSTEM_OS_VERSION_LENGTH 16
#define SYSTEM_MODEL_LENGTH 32
#define SYSTEM_MAC_LENGTH 32

using namespace cocos2d;

namespace ptola
{

    enum enumDeviceOS
    {
        iPhone,
        Android
    };

    enum enumDeviceOrientation
    {
        Portrait            = 0x1,
        PortraitUpsideDown  = 0x2,
        LandscapeLeft       = 0x4,
        LandscapeRight      = 0x8
    };

    enum enumNetworkStatus
    {
         eNS_NotReachable   = 0x0   //no network
        ,eNS_Wifi           = 0x1   //wifi
        ,eNS_WWAN           = 0x2   //2g, 3g
    };

    class CDevice
    {
    public:
        CDevice();
        ~CDevice();
    public:
        static CDevice *sharedDevice()
        {
            static CDevice staticDevice;
            return &staticDevice;
        };

        enumDeviceOS getOS()
        {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
            return iPhone;
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
            return Android;
#endif
        };

        bool isPad()
        {
#if (IS_PAD)
            return true;
#else
            return false;
#endif
        };

        enumNetworkStatus getNetworkStatus();

        CCSize &getScreenSize()
        {
            //reInitializeScreenSize();
            return m_sScreenSize;
        };

        int getDeviceSupportOrientation()
        {
            return m_nDeviceSupportOrientation;
        };

        void setDeviceSupportOrientation(int nOrientationMasks)
        {
            m_nDeviceSupportOrientation = nOrientationMasks;
        };

        enumDeviceOrientation getDeviceOrientation();
        void setDeviceOrientation(enumDeviceOrientation orientation);

        bool getDeviceOrientationIsPortrait()
        {
            enumDeviceOrientation orientation = getDeviceOrientation();
            return orientation == Portrait || orientation == PortraitUpsideDown;
        };

        bool getDeviceOrientationIsLandscape()
        {
            enumDeviceOrientation orientation = getDeviceOrientation();
            return orientation == LandscapeLeft || orientation == LandscapeRight;
        };

        const char *getDeviceIMEI()
        {
            return m_szIMEI;
        };

        const char *getOSVersion()
        {
            return m_szOSVersion;
        };

        const char *getModel()
        {
            return m_szModel;
        };

        const char *getMAC()
        {
            return m_szMAC;
        };

        float getCodeSize(float fValue = 1.0f)
        {
            return fValue * m_fHeightRatio;
        };

        void setCodeSizeRatio(float fValue)
        {
            m_fHeightRatio = fValue;
        }

        void vibrate(int ms);
    private:
        void reInitializeScreenSize();
        void reInitializeDeviceIMEI();
        void reInitializeOSVersion();
        void reInitializeModel();
        void reInitializeMAC();
        int m_nDeviceSupportOrientation;
        CCSize m_sScreenSize;
        float m_fHeightRatio;
        char m_szIMEI[SYSTEM_IMEI_LENGTH];
        char m_szOSVersion[SYSTEM_OS_VERSION_LENGTH];
        char m_szModel[SYSTEM_MODEL_LENGTH];
        char m_szMAC[SYSTEM_MAC_LENGTH];
    };
    
}

#endif /* defined(__GameBox__Device__) */
