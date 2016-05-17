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

    class CDevice
    {
    public:
        static CDevice *sharedDevice();

        enumDeviceOS getOS();
        bool isPad();
        CCSize &getScreenSize();

        int getDeviceSupportOrientation();
        void setDeviceSupportOrientation(int nOrientationMasks);
        enumDeviceOrientation getDeviceOrientation();
        void setDeviceOrientation(enumDeviceOrientation orientation);

        bool getDeviceOrientationIsPortrait();
        bool getDeviceOrientationIsLandscape();
        const char *getDeviceIMEI();
        const char *getOSVersion();
        const char *getModel();
	const char *getMAC();
        float getCodeSize(float fValue);
        void setCodeSizeRatio(float fValue);
        void vibrate(int ms);
    };
    