
    class CVolumeControl : public CUserControl
    {
        
    public:

        static CVolumeControl *create(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName);
        
        void setVolumnBackGround(const char* lpcszBackgroundName);
        CSprite *getVolumnBackGround();
        
        void valueChanged(CCObject *sender, CCControlEvent controlEvent);
        
                
        void setSliderMinimumValue(float fValue);
        float getSliderMinimumValue();
        
        void setSliderMaximumValue(float fValue);
        float getSliderMaximumValue();
        
        void setSliderMaximumAllowedValue(float fValue);
        float getSliderMaximumAllowedValue();
        
        void setSliderMinimumAllowedValue(float fValue);
        float getSliderMinimumAllowedValue();
        
        void setSliderValue(float fValue);
        float getSliderValue();
        
        
        float getVolumeValue();
        void setVolumeValue(float fValue);
        
    };
