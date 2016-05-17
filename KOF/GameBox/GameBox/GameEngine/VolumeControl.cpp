//
//  VolumeControl.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#include "VolumeControl.h"
#include "SimpleAudioEngine.h"

#include "MemoryAllocator.h"

using namespace ptola::memory;
using namespace ptola::gui;

using namespace cocos2d;
using namespace cocos2d::extension;

MEMORY_MANAGE_OBJECT_IMPL(CVolumeControl);




CVolumeControl::CVolumeControl()
: m_fVolumeValue(50.0f)
, m_pCtrlSlider(NULL)
, m_pBackGroundImage(NULL)
{
  
}

CVolumeControl::~CVolumeControl()
{
    CC_SAFE_RELEASE_NULL(m_pCtrlSlider);
}

CVolumeControl *CVolumeControl::create(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName)
{
    CVolumeControl *pRet = new CVolumeControl();
    
    if (pRet && pRet->init(lpcszBackgroundName, lpcszProgressName, lpcszVolumnBtnName))
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CC_SAFE_DELETE(pRet);
        return NULL;
    }
}
 
bool CVolumeControl::init(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName)
{
    if (!CUserControl::init())
    {
        return onInitialized(false);
    }
    
    m_pCtrlSlider = CCControlSlider::create(lpcszBackgroundName,lpcszProgressName ,lpcszVolumnBtnName);
    
    //设置最小 最大长度
    setSliderMinimumValue(0.0f);
    setSliderMaximumValue(100.0f);
    //设置允许的最小最大值
    setSliderMaximumAllowedValue(100.0f);
    setSliderMinimumAllowedValue(0.0f);
    //设置初始值
    setSliderValue(m_fVolumeValue);
    
    m_pCtrlSlider->setTag(111);
    
    m_pCtrlSlider->addTargetWithActionForControlEvents(this, cccontrol_selector(CVolumeControl::valueChanged), CCControlEventValueChanged);
    

    addChild(m_pCtrlSlider);
    
    setAnchorPoint(ccp(0.5f,0.5f));
    setTouchesEnabled(true);
    
    CC_SAFE_RETAIN(m_pCtrlSlider);
    
    
    return onInitialized(true);
}


void CVolumeControl::valueChanged(CCObject *sender, CCControlEvent controlEvent)
{
    CCControlSlider* pSlider = (CCControlSlider*)sender;
    
    //CCLOG("%d\n",pSlider->getTag());
    
    setVolumeValue(pSlider->getValue());
    
}


float CVolumeControl::getVolumeValue()
{
    return m_fVolumeValue;
}

void CVolumeControl::setVolumeValue(float fValue)
{
    
    if (m_fVolumeValue == fValue)
    {
        return;
    }
    
    m_fVolumeValue = fValue;
    
    CCLOG("当前音量：%.1f\n", m_fVolumeValue);
    
    
}

void CVolumeControl::setSliderMinimumValue(float fValue)
{
    if (fValue == m_pCtrlSlider->getMinimumValue())
    {
        return;
    }
    m_pCtrlSlider->setMinimumValue(fValue);
}

float CVolumeControl::getSliderMinimumValue()
{
    return m_pCtrlSlider->getMinimumValue();
}


void CVolumeControl::setSliderMaximumValue(float fValue)
{
    if (fValue == m_pCtrlSlider->getMaximumValue())
    {
        return;
    }
    m_pCtrlSlider->setMaximumValue(fValue);

}

float CVolumeControl::getSliderMaximumValue()
{
    return m_pCtrlSlider->getMaximumValue();
}


void CVolumeControl::setSliderMaximumAllowedValue(float fValue)
{
    if (fValue == m_pCtrlSlider->getMaximumAllowedValue())
    {
        return;
    }
    m_pCtrlSlider->setMaximumAllowedValue(fValue);
}

float CVolumeControl::getSliderMaximumAllowedValue()
{
    return m_pCtrlSlider->getMaximumAllowedValue();
}


void CVolumeControl::setSliderMinimumAllowedValue(float fValue)
{
    if (fValue == m_pCtrlSlider->getMinimumAllowedValue())
    {
        return;
    }
    m_pCtrlSlider->setMinimumAllowedValue(fValue);
}

float CVolumeControl::getSliderMinimumAllowedValue()
{
    return m_pCtrlSlider->getMinimumAllowedValue();
}


void CVolumeControl::setSliderValue(float fValue)
{
    if (fValue == m_pCtrlSlider->getValue())
    {
        return;
    }
    m_pCtrlSlider->setValue(fValue);
}

float CVolumeControl::getSliderValue()
{
    return m_pCtrlSlider->getValue();
}

void CVolumeControl::setVolumnBackGround(const char* lpcszBackgroundName)
{
    if (m_pBackGroundImage == NULL)
    {
        m_pBackGroundImage = CSprite::create(lpcszBackgroundName);
    }
    
}

CSprite *CVolumeControl::getVolumnBackGround()
{
    return m_pBackGroundImage;
}

