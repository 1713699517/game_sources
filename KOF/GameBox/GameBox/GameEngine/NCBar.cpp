//
//  NCBar.cpp
//  GameBox
//
//  Created by Caspar on 13-5-9.
//
//

#include "NCBar.h"

#include "MemoryAllocator.h"
#define DEFAULT_CNCBAR_FONT_FAMILY "Arial"
#define DEFAULT_CNCBAR_FONT_SIZE 12.0f

using namespace ptola::gui;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CNCBar);

CNCBar::CNCBar()
: m_pTitle(NULL)
, m_pButton(NULL)
, m_pBackground(NULL)
, m_sizePreferedSize(CCSizeZero)
{

}


CNCBar::~CNCBar()
{
    
    CC_SAFE_RELEASE_NULL(m_pTitle);
    CC_SAFE_RELEASE_NULL(m_pBackground);
    CC_SAFE_RELEASE_NULL(m_pButton);
    
}

bool CNCBar::init()
{
    return CUserControl::init();
}

//2013.06.06 hlc add
CNCBar *CNCBar::create(CCLabelTTF *pLabel, CButton *pBtn, CSprite *pSprite)
{
    CNCBar *pRet = new CNCBar();
    
    if (pRet && pRet->initWithFile(pLabel, pBtn, pSprite))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

bool CNCBar::initWithFile(CCLabelTTF *pLabel, CButton *pBtn, CSprite *pSprite)
{
    if( !CUserControl::init() )
        return onInitialized(false);
    
    
    setAnchorPoint(ccp(0.5f, 0.5f));
    
    CCSize size = CCDirector::sharedDirector()->getVisibleSize();
    
    m_pBackground = pSprite;
    if (m_pBackground != NULL )
    {
        m_pBackground->setPosition(ccp(size.width/2, size.height/2));
        addChild( m_pBackground );
        m_sizePreferedSize = m_pBackground->getPreferredSize();
    }
    
    m_pButton = pBtn;
    if ( m_pButton != NULL )
    {
        m_pButton->setPosition(ccp(size.width/2+m_pBackground->getPreferredSize().width/2-m_pButton->getPreferredSize().width/2,
                                   size.height/2+m_pBackground->getPreferredSize().height/2-m_pButton->getPreferredSize().height/2));
        m_pButton->setTouchesPriority(-1);
        
        m_pButton->addEventListener("TouchBegan", this, eventhandler_selector(CNCBar::menuCallBack));
        
        addChild(m_pButton);
        m_sizePreferedSize = m_pButton->getPreferredSize();
    }
    
    m_pTitle = pLabel;
    if ( m_pTitle != NULL )
    {
        m_pTitle->setPosition(ccp(size.width/2, size.height/2));
        setFontSize(26);
        addChild(m_pTitle);
        
    }
    
    
    
    CC_SAFE_RETAIN(m_pTitle);
    CC_SAFE_RETAIN(m_pButton);
    CC_SAFE_RETAIN(m_pBackground);
    
    setTouchesEnabled(true);

    return onInitialized(true);
}

void CNCBar::menuCallBack(CCObject *pSender)
{
    removeFromParentAndCleanup(true);
}

CNCBar *CNCBar::createWithSpriteFrameName(const char *lpcszLabel, const char *lpcszBtn, const char *lpcszSprite)
{
    CNCBar *pRet = new CNCBar();
    
    if (pRet && pRet->initWithSpriteFrameName(lpcszLabel, lpcszBtn, lpcszSprite))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
    
}


CNCBar *CNCBar::create(const char *lpcszLabel, const char *lpcszBtn, const char *lpcszSprite)
{
    CNCBar *pRet = new CNCBar();
    
    if (pRet && pRet->initWithFile(lpcszLabel, lpcszBtn, lpcszSprite))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

bool CNCBar::initWithFile(const char *lpcszLabel, const char *lpcszBtn, const char *lpcszSprite)
{
    CCLabelTTF *pLabel = CCLabelTTF::create(lpcszLabel, DEFAULT_CNCBAR_FONT_FAMILY, DEFAULT_CNCBAR_FONT_SIZE);
    
    CSprite *pSprite = CSprite::create(lpcszSprite);
    
    CButton *pBtn = CButton::create("", lpcszBtn);
    
    return initWithFile(pLabel, pBtn, pSprite);
}


bool CNCBar::initWithSpriteFrameName(const char *lpcszLabel, const char *lpcszBtn, const char *lpcszSprite)
{
    CCLabelTTF *pLabel = CCLabelTTF::create(lpcszLabel, DEFAULT_CNCBAR_FONT_FAMILY, DEFAULT_CNCBAR_FONT_SIZE);
    
    CSprite *pSprite = CSprite::createWithSpriteFrameName(lpcszSprite);
    
    CButton *pBtn = CButton::createWithSpriteFrameName("", lpcszBtn);
    
    return initWithFile(pLabel, pBtn, pSprite);
}
//---

const char *CNCBar::getText()
{
    if (m_pTitle)
    {
        return m_pTitle->getString();
    }
    
    return NULL;
}

void CNCBar::setText(const char *lpcszText)
{
    m_pTitle->setString(lpcszText);
}

ccColor4B CNCBar::getColor()
{
    
    if (m_pTitle)
    {
        return ccc4(m_pTitle->getColor().r,
                    m_pTitle->getColor().g,
                    m_pTitle->getColor().b,
                    m_pTitle->getOpacity());
    }
    
    return ccc4(1,2,3,4);
}

void CNCBar::setColor(ccColor4B &color)
{
    m_pTitle->setColor(ccc3(color.r, color.g, color.b));
    m_pTitle->setOpacity(color.a);
}

float CNCBar::getFontSize()
{
    if (m_pTitle)
    {
        return m_pTitle->getFontSize();
    }
    return 0.0f;
}

void CNCBar::setFontSize(float fFontSize)
{
    m_pTitle->setFontSize(fFontSize);
}

const char *CNCBar::getFontFamily()
{
    if (m_pTitle)
    {
        return m_pTitle->getFontName();
    }
    
    return NULL;
}

void CNCBar::setFontFamily(const char *lpcszFontFamily)
{
    m_pTitle->setFontName(lpcszFontFamily);
}

void CNCBar::setPreferredSize(const CCSize &size)
{
    m_sizePreferedSize = size;
    m_pBackground->setPreferredSize(m_sizePreferedSize);
}

CCSize &CNCBar::getPreferredSize()
{
    
   return m_sizePreferedSize;
    
}

void CNCBar::setBackgroundSprite(CSprite *pBackground)
{
    if (m_pBackground == NULL)
    {
        m_pBackground = pBackground;
    }
    else
    {
        m_pBackground->removeFromParentAndCleanup(true);
        m_pBackground = pBackground;
    }
    
}

CSprite *CNCBar::getBackgroundSprite()
{
    if (m_pBackground == NULL)
    {
        return NULL;
    }
    return m_pBackground;
}

void CNCBar::setCloseButton(CButton *pButton)
{
    if(m_pButton != NULL)
    {
        m_pButton->removeFromParentAndCleanup(true);
        m_pButton = pButton;
    }
    else
    {
        m_pButton = pButton;
    }
}

CButton *CNCBar::getCloseButton()
{
    if (m_pButton != NULL)
    {
        return m_pButton;
    }
    return NULL;
}
