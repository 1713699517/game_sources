//
//  sliderl.h
//  GameBox
//
//  Created by Julian chen on 13-5-13.
//
//

#ifndef __GameBox__sliderl__
#define __GameBox__sliderl__

#include <iostream>
#include "Button.h"
#include "Sprite.h"
#include "CCControlSlider.h"
#include "ptola.h"

namespace ptola
{
    namespace gui
    {
        class CSliderControl : public CUserControl
        {
            
        public:

            MEMORY_MANAGE_OBJECT(CSliderControl);
            
            CSliderControl();
            ~CSliderControl();
            
            
            
            static CSliderControl *create(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName);
            static CSliderControl *createWithSpriteFrameName(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName);
            static CSliderControl *createWithCCSprite(CCSprite *lpcszBackgroundName, CCSprite *lpcszProgressName, CCSprite *lpcszVolumnBtnName);
            
            bool init(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName);
            bool initWithSpriteFrameName(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName);
            bool initWithSpriteFrameName(CCSprite *lpcszBackgroundName, CCSprite *lpcszProgressName, CCSprite *lpcszVolumnBtnName);
          //  void setCSliderControlBackGround(const char* lpcszBackgroundName);
        //    CSprite *getVolumnBackGround();
            
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
                        
            void setEnabled(bool bEnabled);
            bool getEnabled();
        private:
            float m_fVolumeValue;
            
            CCControlSlider *m_pCtrlSlider;
        };
        
        
    }
}


#endif /* defined(__GameBox__sliderl__) */
