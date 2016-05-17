//
//  sliderl.cpp
//  GameBox
//
//  Created by Julian chen on 13-5-13.
//
//

#include "Slider.h"
#include "CCControlSlider.h"

#include "MemoryAllocator.h"

using namespace ptola::memory;
using namespace ptola::gui;


MEMORY_MANAGE_OBJECT_IMPL(CSliderControl);

CSliderControl::CSliderControl()
: m_pCtrlSlider(NULL)
{
    
}

CSliderControl::~CSliderControl()
{
    
}

CSliderControl *CSliderControl::create(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName)
{
    CSliderControl *pRet = new CSliderControl();
    
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

CSliderControl *CSliderControl::createWithCCSprite(CCSprite *lpcszBackgroundName, CCSprite *lpcszProgressName, CCSprite *lpcszVolumnBtnName)
{
    CSliderControl *pRet = new CSliderControl();
    
    if (pRet && pRet->initWithSpriteFrameName(lpcszBackgroundName, lpcszProgressName, lpcszVolumnBtnName))
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

bool CSliderControl::initWithSpriteFrameName(const char *lpcszBackgroundName, const char *lpcszProgressName, const char *lpcszVolumnBtnName)
{
    CCSprite *pBackground = CCSprite::createWithSpriteFrameName(lpcszBackgroundName);
    CCSprite *pProgress = CCSprite::createWithSpriteFrameName(lpcszProgressName);
    CCSprite *pVolumnBtn = CCSprite::createWithSpriteFrameName(lpcszVolumnBtnName);
    return initWithSpriteFrameName( pBackground, pProgress, pVolumnBtn );
}

bool CSliderControl::initWithSpriteFrameName(CCSprite *pBackground, CCSprite *pProgress, CCSprite *pVolumnBtn)
{
    if (!CUserControl::init())
    {
        return onInitialized(false);
    }
    
    m_pCtrlSlider = CCControlSlider::create( pBackground, pProgress ,pVolumnBtn );
    
    //设置最小 最大长度
    setSliderMinimumValue(0.0f);
    setSliderMaximumValue(1.0f);
    //设置允许的最小最大值
    setSliderMaximumAllowedValue(1.0f);
    setSliderMinimumAllowedValue(0.0f);
    //设置初始值
    setSliderValue(getSliderMinimumValue());
    
    addChild(m_pCtrlSlider);
    
    setAnchorPoint(ccp(0.5f,0.5f));
    setTouchesEnabled(true);
    
    setEnabled(false);
    
    return onInitialized(true);

}


CSliderControl *CSliderControl::createWithSpriteFrameName(const char *lpcszBackgroundName, const char *lpcszProgressName, const char *lpcszVolumnBtnName)
{
    CSliderControl *pRet = new CSliderControl();
    
    if (pRet && pRet->initWithSpriteFrameName(lpcszBackgroundName, lpcszProgressName, lpcszVolumnBtnName))
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

bool CSliderControl::init(const char* lpcszBackgroundName, const char* lpcszProgressName,const char* lpcszVolumnBtnName)
{
    if (!CUserControl::init())
    {
        return onInitialized(false);
    }
    
    m_pCtrlSlider = CCControlSlider::create(lpcszBackgroundName,lpcszProgressName ,lpcszVolumnBtnName);
    
    //设置最小 最大长度
    setSliderMinimumValue(0.0f);
    setSliderMaximumValue(1.0f);
    //设置允许的最小最大值
    setSliderMaximumAllowedValue(1.0f);
    setSliderMinimumAllowedValue(0.0f);
    //设置初始值
    setSliderValue(getSliderMinimumValue());
    
    addChild(m_pCtrlSlider);
    
    setAnchorPoint(ccp(0.5f,0.5f));
    setTouchesEnabled(true);
    
    setEnabled(false);
    
    return onInitialized(true);
}

void CSliderControl::setSliderMinimumValue(float fValue)
{
    if (fValue == m_pCtrlSlider->getMinimumValue())
    {
        return;
    }
    m_pCtrlSlider->setMinimumValue(fValue);
}

float CSliderControl::getSliderMinimumValue()
{
    return m_pCtrlSlider->getMinimumValue();
}


void CSliderControl::setSliderMaximumValue(float fValue)
{
    if (fValue == m_pCtrlSlider->getMaximumValue())
    {
        return;
    }
    m_pCtrlSlider->setMaximumValue(fValue);
    
}

float CSliderControl::getSliderMaximumValue()
{
    return m_pCtrlSlider->getMaximumValue();
}


void CSliderControl::setSliderMaximumAllowedValue(float fValue)
{
    if (fValue == m_pCtrlSlider->getMaximumAllowedValue())
    {
        return;
    }
    m_pCtrlSlider->setMaximumAllowedValue(fValue);
}

float CSliderControl::getSliderMaximumAllowedValue()
{
    return m_pCtrlSlider->getMaximumAllowedValue();
}


void CSliderControl::setSliderMinimumAllowedValue(float fValue)
{
    if (fValue == m_pCtrlSlider->getMinimumAllowedValue())
    {
        return;
    }
    m_pCtrlSlider->setMinimumAllowedValue(fValue);
}

float CSliderControl::getSliderMinimumAllowedValue()
{
    return m_pCtrlSlider->getMinimumAllowedValue();
}


void CSliderControl::setSliderValue(float fValue)
{
    if (fValue == m_pCtrlSlider->getValue())
    {
        return;
    }
    m_pCtrlSlider->setValue(fValue);
}

float CSliderControl::getSliderValue()
{
    return m_pCtrlSlider->getValue();
}

void CSliderControl::setEnabled(bool bEnabled)
{
    m_pCtrlSlider->setEnabled(bEnabled);
}

bool CSliderControl::getEnabled()
{
    return m_pCtrlSlider->isEnabled();
}

