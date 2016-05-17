        class CSliderControl : public CUserControl
        {
        public:
            
            static CSliderControl *create(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName);
            
            static CSliderControl *createWithSpriteFrameName(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName);
            static CSliderControl *createWithCCSprite(CCSprite *lpcszBackgroundName, CCSprite *lpcszProgressName, CCSprite *lpcszVolumnBtnName);
            
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
            
            void setEnabled(bool bEnabled);
            bool getEnabled();
            
        };
        