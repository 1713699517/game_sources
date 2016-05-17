//
//  Button.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#include "Button.h"
#include "MemoryAllocator.h"

#define DEFAULT_BUTTON_FONT_FAMILY "Arial"
#define DEFAULT_BUTTON_FONT_SIZE 24.0f

using namespace ptola::gui;

using namespace ptola::memory;

MEMORY_MANAGE_OBJECT_IMPL(CButton);

CButton::CButton()
: m_bChecked(false)
, m_sizePreferedSize(CCSizeZero)
, m_pBackground(NULL)
, m_pLabel(NULL)
, m_eTextAlignment(kTextAlignmentCenter)
{

}

CButton::~CButton()
{
    CC_SAFE_RELEASE_NULL(m_pLabel);
    CC_SAFE_RELEASE_NULL(m_pBackground);
    CC_SAFE_RELEASE_NULL(m_pCheckedLabel);
    CC_SAFE_RELEASE_NULL(m_pCheckBackground);
}


const char *CButton::getText()
{
    if( m_bChecked )
    {
        if( m_pCheckedLabel != NULL )
            return m_pCheckedLabel->getString();
    }
    else
    {
        if( m_pLabel != NULL )
            return m_pLabel->getString();
    }
    if( m_pLabel != NULL )
        return m_pLabel->getString();
    else
        return NULL;
}

void CButton::setText(const char *lpcszText)
{
    if( m_pLabel != NULL )
    {
        m_pLabel->setString(lpcszText);
    }
    if( m_pCheckedLabel != NULL )
    {
        m_pCheckedLabel->setString(lpcszText);
    }
}

ccColor4B CButton::getColor()
{
    ccColor4B ret = ccc4(255,255,255,255);
    if( m_bChecked )
    {
        ret.r = m_pCheckedLabel->getColor().r;
        ret.g = m_pCheckedLabel->getColor().g;
        ret.b = m_pCheckedLabel->getColor().b;
        ret.a = m_pCheckedLabel->getOpacity();
    }
    else
    {
        ret.r = m_pLabel->getColor().r;
        ret.g = m_pLabel->getColor().g;
        ret.b = m_pLabel->getColor().b;
        ret.a = m_pLabel->getOpacity();
    }
    return ret;
}

void CButton::setColor(ccColor4B &color)
{
    if( m_pLabel != NULL )
    {
        m_pLabel->setColor(ccc3(color.r, color.g, color.b));
        m_pLabel->setOpacity(color.a);
    }
    if( m_pCheckedLabel != NULL )
    {
        m_pCheckedLabel->setColor(ccc3(color.r, color.g, color.b));
        m_pCheckedLabel->setOpacity(color.a);
    }
}

float CButton::getFontSize()
{
    if( m_bChecked )
    {
        if( m_pCheckedLabel != NULL )
            return m_pCheckedLabel->getFontSize();
    }
    else
    {
        if( m_pLabel != NULL )
            return m_pLabel->getFontSize();
    }
    return DEFAULT_BUTTON_FONT_SIZE;
}

void CButton::setFontSize(float fFontSize)
{
    if( m_pCheckedLabel != NULL )
        m_pCheckedLabel->setFontSize(fFontSize);
    if( m_pLabel != NULL )
        m_pLabel->setFontSize(fFontSize);
}

const char *CButton::getFontFamily()
{
    if( m_bChecked )
    {
        if( m_pCheckedLabel != NULL )
            return m_pCheckedLabel->getFontName();
    }
    else
    {
        if( m_pLabel != NULL )
            return m_pLabel->getFontName();
    }
    if( m_pLabel != NULL )
        return m_pLabel->getFontName();
    else
        return NULL;
}

void CButton::setFontFamily(const char *lpcszFontFamily)
{
    if( m_pLabel != NULL )
    {
        m_pLabel->setFontName(lpcszFontFamily);
    }
    if( m_pCheckedLabel != NULL )
    {
        m_pCheckedLabel->setFontName(lpcszFontFamily);
    }
}

CButton* CButton::create(const char *normalLabel,const char *normalBackGroundSprite)
{
    CButton *pRet = new CButton;
    if( pRet != NULL && pRet->initWithFile(normalLabel, normalBackGroundSprite))
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

CButton* CButton::create(const char *normalLabel,const char *normolBackGroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite,bool bDefaultChecked)
{
    CButton *pRet = new CButton();
    if (pRet != NULL && pRet->initWithFile(normalLabel,normolBackGroundSprite,checkedLabel,checkedBackGroundSprite, bDefaultChecked))
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

bool CButton::initWithFile(const char *normalLabel,const char *normolBackGroundSprite)
{

    CCLabelTTF *pNormalLabel = CCLabelTTF::create(normalLabel, DEFAULT_BUTTON_FONT_FAMILY, DEFAULT_BUTTON_FONT_SIZE);
    CSpriteRGBA *pNormalBackground = CSpriteRGBA::create(normolBackGroundSprite);

    return initWithFile(pNormalLabel,pNormalBackground,NULL,NULL);
}

bool CButton::initWithFile(const char *normalLabel,const char *normolBackGroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite, bool bDefaultChecked)
{
    CCLabelTTF *pNormalLabel = CCLabelTTF::create(normalLabel, DEFAULT_BUTTON_FONT_FAMILY, DEFAULT_BUTTON_FONT_SIZE);
    CSpriteRGBA *pNormalBackground = CSpriteRGBA::create(normolBackGroundSprite);

    
    CCLabelTTF *pCheckedLabel = NULL;
    if( checkedLabel != NULL )
        pCheckedLabel = CCLabelTTF::create(checkedLabel, DEFAULT_BUTTON_FONT_FAMILY, DEFAULT_BUTTON_FONT_SIZE);

    CSpriteRGBA *pCheckedBackground = NULL;
    if( checkedBackGroundSprite != NULL )
        pCheckedBackground = CSpriteRGBA::create(checkedBackGroundSprite);

    return initWithFile(pNormalLabel, pNormalBackground, pCheckedLabel, pCheckedBackground, bDefaultChecked);
}

CButton* CButton::create(CCLabelTTF* label, CSpriteRGBA* backgroundSprite)
{
    CButton *pRet = new CButton;
    if( pRet != NULL && pRet->initWithFile(label, backgroundSprite) )
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

bool CButton::initWithFile(CCLabelTTF* label, CSpriteRGBA* backgroundSprite)
{
    return initWithFile(label, backgroundSprite, NULL, NULL, false);
}

CButton* CButton::create(CCLabelTTF* label, CSpriteRGBA* backgroundSprite, CCLabelTTF* checkedLabel, CSpriteRGBA* checkedBackgroundSprite, bool bDefaultChecked)
{
    CButton *pRet = new CButton;
    if( pRet != NULL && pRet->initWithFile(label, backgroundSprite, checkedLabel, checkedBackgroundSprite, bDefaultChecked))
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


bool CButton::initWithFile(CCLabelTTF* label, CSpriteRGBA* backgroundSprite, CCLabelTTF* checkedLabel, CSpriteRGBA* checkedBackgroundSprite, bool bDefaultChecked)
{
    if( !CUserControl::init() )
        return onInitialized(false);
    setAnchorPoint(ccp(0.5f, 0.5f));
    m_pBackground = backgroundSprite;
    if( m_pBackground != NULL )
    {
        if( !bDefaultChecked )
        {
            addChild(m_pBackground, 1);
            m_sizePreferedSize = backgroundSprite->getPreferredSize();
        }
    }
    m_pLabel = label;
    if( m_pLabel != NULL )
    {
        if( !bDefaultChecked )
        {
            addChild(m_pLabel, 2);
        }
    }
    m_pCheckBackground = checkedBackgroundSprite;
    if( m_pCheckBackground != NULL )
    {
        if( bDefaultChecked )
        {
            addChild(m_pCheckBackground, 3);
            m_sizePreferedSize = checkedBackgroundSprite->getPreferredSize();
        }
    }
    m_pCheckedLabel = checkedLabel;
    if( m_pCheckedLabel != NULL )
    {
        if( bDefaultChecked )
        {
            addChild(m_pLabel, 4);
        }
    }
    
    setVerticalAlignment(m_eTextAlignment);
    
    CC_SAFE_RETAIN(m_pLabel);
    CC_SAFE_RETAIN(m_pBackground);
    CC_SAFE_RETAIN(m_pCheckedLabel);
    CC_SAFE_RETAIN(m_pCheckBackground);
    onLayout();
    setTouchesEnabled(true);
    return onInitialized(true);
}

bool CButton::initWithSpriteFrameName(const char *normalLabel, const char *normalBackgroundSprite, const char *checkedLabel, const char *checkedBackGroundSprite, bool bDefaultChecked)
{
    CCLabelTTF *pNormalLabel = CCLabelTTF::create(normalLabel, DEFAULT_BUTTON_FONT_FAMILY, DEFAULT_BUTTON_FONT_SIZE);
    CSpriteRGBA *pNormalBackground = CSpriteRGBA::createWithSpriteFrameName(normalBackgroundSprite);

    CCLabelTTF *pCheckedLabel = NULL;
    if(checkedLabel != NULL)
        pCheckedLabel = CCLabelTTF::create(checkedLabel, DEFAULT_BUTTON_FONT_FAMILY, DEFAULT_BUTTON_FONT_SIZE);

    CSpriteRGBA *pCheckedBackground = NULL;
    if(checkedBackGroundSprite != NULL)
        pCheckedBackground = CSpriteRGBA::createWithSpriteFrameName(checkedBackGroundSprite);
    return initWithFile(pNormalLabel, pNormalBackground, pCheckedLabel, pCheckedBackground, bDefaultChecked);
}

CButton *CButton::createWithSpriteFrameName(const char *normalLabel, const char *normalBackgroundSprite, const char *checkedLabel, const char *checkedBackGroundSprite, bool bDefaultChecked)
{
    CButton *pRet = new CButton;
    if( pRet != NULL && pRet->initWithSpriteFrameName(normalLabel, normalBackgroundSprite, checkedLabel, checkedBackGroundSprite, bDefaultChecked))
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

bool CButton::initWithSpriteFrameName(const char *normalLabel, const char *normolBackGroundSprite)
{
    CCLabelTTF *pNormalLabel = CCLabelTTF::create(normalLabel, DEFAULT_BUTTON_FONT_FAMILY, DEFAULT_BUTTON_FONT_SIZE);
    CSpriteRGBA *pNormalBackground = CSpriteRGBA::createWithSpriteFrameName(normolBackGroundSprite);
    return initWithFile(pNormalLabel, pNormalBackground, NULL, NULL, false);
}

CButton *CButton::createWithSpriteFrameName(const char *normalLabel, const char *normolBackGroundSprite)
{
    CButton *pRet = new CButton;
    if( pRet != NULL && pRet->initWithSpriteFrameName(normalLabel, normolBackGroundSprite) )
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


void CButton::setChecked(bool bChecked)
{
    if( m_bChecked == bChecked )
        return;
    m_bChecked = bChecked;
    if( m_bChecked )
    {
        if( m_pCheckBackground != NULL && m_pCheckBackground->getParent() == NULL )
            addChild( m_pCheckBackground , 3);
        if( m_pCheckedLabel != NULL && m_pCheckedLabel->getParent() == NULL)
            addChild( m_pCheckedLabel, 4 );
        if( m_pBackground != NULL )
            m_pBackground->removeFromParentAndCleanup(false);
        if( m_pLabel != NULL )
            m_pLabel->removeFromParentAndCleanup(false);
    }
    else
    {
        if( m_pBackground != NULL && m_pBackground->getParent() == NULL )
            addChild( m_pBackground , 1);
        if( m_pLabel != NULL && m_pLabel->getParent() == NULL )
            addChild( m_pLabel, 2 );
        if( m_pCheckBackground != NULL )
            m_pCheckBackground->removeFromParentAndCleanup(false);
        if( m_pCheckedLabel != NULL )
            m_pCheckedLabel->removeFromParentAndCleanup(false);
    }
    onLayout();
    if( m_bChecked && m_pCheckBackground == NULL )
    {
        if( m_pBackground != NULL && m_pBackground->getParent() == NULL )
            addChild( m_pBackground, 1 );
    }
    if( m_bChecked && m_pCheckedLabel == NULL )
    {
        if( m_pLabel != NULL && m_pLabel->getParent() == NULL )
            addChild( m_pLabel, 2);
    }
}

bool CButton::getChecked()
{
    return m_bChecked;
}

const CCSize &CButton::getContentSize()
{
    return m_sizePreferedSize;
}

bool CButton::containsPoint(CCPoint *pGLPoint)
{
    CCPoint anchorPoint = getAnchorPoint();
    CCRect temp = CCRectMake(-m_sizePreferedSize.width*anchorPoint.x,-m_sizePreferedSize.height*anchorPoint.y,m_sizePreferedSize.width,m_sizePreferedSize.height);
    return temp.containsPoint(*pGLPoint);
}

void CButton::onTouchInside()
{
    if(m_pCheckedLabel == NULL && m_pCheckBackground == NULL )
        return ;
}

void CButton::setPreferredSize(const cocos2d::CCSize &size)
{
    if( m_sizePreferedSize.equals(size) )
        return;
    m_sizePreferedSize = size;
    if( m_pBackground != NULL )
    {
        m_pBackground->setPreferredSize(size);
    }
    if( m_pCheckBackground != NULL )
    {
        m_pCheckBackground->setPreferredSize(size);
    }
    onLayout();
}

CCSize &CButton::getPreferredSize()
{
    return m_sizePreferedSize;
}

void CButton::onLayout()
{
    
}


void CButton::setVerticalAlignment(eTextAlignment textAlignment)
{
    
    //CCPoint pos = m_pBackground->getPosition();
    //CCLOG("pos %f, %f\n", pos.x, pos.y);
    
    
    if (textAlignment == m_eTextAlignment)
    {
        return;
    }
    else
    {
        m_eTextAlignment = textAlignment;
        
        if (m_eTextAlignment == kTextAlignmentLeft)
        {
            m_pLabel->setPosition(ccp(-getPreferredSize().width/2,0));
            m_pLabel->setAnchorPoint(ccp(0.0f, 0.5f));
        }
        else if(m_eTextAlignment == kTextAlignmentRight)
        {
            //右对齐
            m_pLabel->setPosition(ccp(getPreferredSize().width/2,0));
            m_pLabel->setAnchorPoint(ccp(1.0f, 0.5f));
        }
        else if(m_eTextAlignment == kTextAlignmentCenter)
        {
            //默认位置
            
            m_pLabel->setAnchorPoint(ccp(0.5f, 0.5f));

        }
    }
    
    
}

eTextAlignment CButton::getVerticalAlignment()
{
    return m_eTextAlignment;
}

bool CButton::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    if (CUserControl::ccTouchBegan(pTouch, pEvent))
    {
        if( containsTouch(pTouch) )
        {
            setChecked(!getChecked());
            setDark();
        }
        return true;
    }
    else
    {
        return false;
    }
}

void CButton::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    CUserControl::ccTouchEnded(pTouch, pEvent);
    setDefault();
}

void CButton::setTouchesEnabled(bool bTouchEnabled)
{
    CUserControl::setTouchesEnabled(bTouchEnabled);
    if( bTouchEnabled )
    {
        setDefault();
    }
    else
    {
        setGray();
    }
}

void CButton::setHightLight()
{
    if( m_pBackground != NULL )
    {
        m_pBackground->shaderMulColor(1.6f, 1.6f, 1.6f, 1.0f);
    }
    if( m_pCheckBackground != NULL )
    {
        m_pCheckBackground->shaderMulColor(1.6f, 1.6f, 1.6f, 1.0f);
    }
}

void CButton::setDefault()
{
    if( m_pBackground != NULL )
    {
        m_pBackground->shaderResetNull();
    }
    if( m_pCheckBackground != NULL )
    {
        m_pCheckBackground->shaderResetNull();
    }
}

void CButton::setDark()
{
    if( m_pBackground != NULL )
    {
        m_pBackground->shaderMulColor(0.7f, 0.7f, 0.7f, 1.0f);
    }
    if( m_pCheckBackground != NULL )
    {
        m_pCheckBackground->shaderMulColor(0.7f, 0.7f, 0.7f, 1.0f);
    }
}

void CButton::setGray()
{
    if( m_pBackground != NULL )
    {
        m_pBackground->shaderDotColor(0.299f, 0.587f, 0.114f, 1.0f);
    }
    if( m_pCheckBackground != NULL )
    {
        m_pCheckBackground->shaderDotColor(0.299f, 0.587f, 0.114f, 1.0f);
    }
}

void CButton::setPressed()
{
    if( m_pBackground != NULL )
    {
        m_pBackground->shaderMulColor(1.1f, 1.1f, 1.1f, 1.0f);
    }
    if( m_pCheckBackground != NULL )
    {
        m_pCheckBackground->shaderMulColor(1.1f, 1.1f, 1.1f, 1.0f);
    }
}
