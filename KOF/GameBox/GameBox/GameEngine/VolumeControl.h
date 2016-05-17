//
//  VolumeControl.h
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#ifndef __GameBox__VolumeControl__
#define __GameBox__VolumeControl__

#include "Button.h"
#include "Sprite.h"
#include "CCControlSlider.h"
#include "ptola.h"

namespace ptola
{
namespace gui
{

    class CVolumeControl : public CUserControl
    {
        
    public:

        MEMORY_MANAGE_OBJECT(CVolumeControl);
        
        CVolumeControl();
        ~CVolumeControl();
        
        
        
        static CVolumeControl *create(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName);
        
        bool init(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName);
        
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
        
        
    private:
        float m_fVolumeValue;
        
        CCControlSlider *m_pCtrlSlider;
        CSprite *m_pBackGroundImage;
    };

}
}

#endif /* defined(__GameBox__VolumeControl__) */
