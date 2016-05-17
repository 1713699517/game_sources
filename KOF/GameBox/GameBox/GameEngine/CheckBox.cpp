//
//  CheckBox.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
/////////////////////////////////////////////////

#include "CheckBox.h"
#include "MemoryAllocator.h"
using namespace ptola::gui;
using namespace ptola::memory;

#define DEFAULT_CHECK_FONT_FAMILY   "Arial"
#define DEFAULT_CHECK_FONT_SIZE     23

MEMORY_MANAGE_OBJECT_IMPL(CCheckBox);

CCheckBox::CCheckBox()
: m_bCheckState(false)
, m_eTextAlign(eTA_Left)        //默认左对齐
, m_pNormalSprite(NULL)
, m_pCheckedSprite(NULL)
, m_pTextLabel(NULL)
{

}

CCheckBox::~CCheckBox()
{
    CC_SAFE_RELEASE_NULL(m_pNormalSprite);
    CC_SAFE_RELEASE_NULL(m_pCheckedSprite);
    CC_SAFE_RELEASE_NULL(m_pTextLabel);
}

CCheckBox *CCheckBox::create(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText,enumTextAlign align)
{
    CCheckBox *pRet = new CCheckBox();
    
    if(pRet != NULL && pRet->initWithFile(lpcszNormalName,lpcszCheckedSprite,lpcszText,align))
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

CCheckBox *CCheckBox::create(CSprite *pNormalImg, CSprite *pCheckedImg, CCLabelTTF *pLabel, enumTextAlign align)
{
    CCheckBox *pRet = new CCheckBox();
    
    if(pRet != NULL && pRet->initWithFile(pNormalImg, pCheckedImg, pLabel, align))
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


bool CCheckBox::initWithFile(CSprite *pNormalImg, CSprite *pCheckedImg, CCLabelTTF *pLabel, enumTextAlign align)
{
    if (!CUserControl::init())
    {
        return onInitialized(false);
    }
    setAnchorPoint(ccp(0.5f,0.5f));
    setTouchesEnabled(true);
    
    if (pNormalImg != NULL)
    {
        m_pNormalSprite = pNormalImg;
    }
    
    if (pCheckedImg != NULL)
    {
        m_pCheckedSprite = pCheckedImg;
    }
   
    if (pLabel != NULL)
    {
        m_pTextLabel = pLabel;
    }
    
    m_eTextAlign = align;
    
    m_pNormalSprite->setVisible(true);
    m_pCheckedSprite->setVisible(false);
    
    
    
    ccColor4B color4 = ccc4(255,215,0,255);
    setColor(color4);
    
    //设置对齐方式
    setTextAlign(align);
    
    addChild(m_pTextLabel);
    addChild(m_pCheckedSprite);
    addChild(m_pNormalSprite);
    
    CC_SAFE_RETAIN(m_pTextLabel);
    CC_SAFE_RETAIN(m_pCheckedSprite);
    CC_SAFE_RETAIN(m_pNormalSprite);
    
    return onInitialized(true);
}

CCheckBox *CCheckBox::createWithSpriteFrameName(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText,enumTextAlign align)
{
    CCheckBox *pRet = new CCheckBox();
    
    if(pRet != NULL && pRet->initWithParameters(lpcszNormalName,lpcszCheckedSprite,lpcszText, align))
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

CCheckBox *CCheckBox::create(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText)
{
    
    return create(lpcszNormalName,lpcszCheckedSprite,lpcszText,eTA_Left);
}


bool CCheckBox::initWithParameters(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText)
{
    return initWithParameters(lpcszNormalName, lpcszCheckedSprite, lpcszText,eTA_Left);
}

bool CCheckBox::initWithFile(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText,enumTextAlign align)
{
    CSprite *pNormal = CSprite::create(lpcszNormalName);
    CSprite *pChecked = CSprite::create(lpcszCheckedSprite);
    CCLabelTTF *pTextLabel = CCLabelTTF::create(lpcszText, DEFAULT_CHECK_FONT_FAMILY,DEFAULT_CHECK_FONT_SIZE);
    
    return initWithFile(pNormal, pChecked, pTextLabel, align);
}

bool CCheckBox::initWithParameters(const char *lpcszNormalName,const char *lpcszCheckedSprite,const char *lpcszText,enumTextAlign align)
{
    
    CSprite *pNormal = CSprite::createWithSpriteFrameName(lpcszNormalName);
    CSprite *pChecked = CSprite::createWithSpriteFrameName(lpcszCheckedSprite);
    CCLabelTTF *pTextLabel = CCLabelTTF::create(lpcszText, DEFAULT_CHECK_FONT_FAMILY,DEFAULT_CHECK_FONT_SIZE);
    
    return initWithFile(pNormal, pChecked, pTextLabel, align);
}

void CCheckBox::performStateChanged()
{
    if ( m_bCheckState == false )
    {
        m_pNormalSprite->setVisible(true);
        m_pCheckedSprite->setVisible(false);
    }
    else
    {
        m_pNormalSprite->setVisible(false);
        m_pCheckedSprite->setVisible(true);
    }
}

bool CCheckBox::containsPoint(CCPoint *pGLPoint)
{
    CCSize tempSize = m_pNormalSprite->getPreferredSize();
     
    CCPoint anchorPoint = getAnchorPoint();
    CCRect tempRect = CCRectMake(-tempSize.width*anchorPoint.x, -tempSize.height*anchorPoint.y, tempSize.width, tempSize.height);
    
    return tempRect.containsPoint(*pGLPoint);
}

void CCheckBox::onTouchInside()
{
    if(m_pNormalSprite == NULL)
        return;
    setChecked(!getChecked());
}


enumTextAlign CCheckBox::getTextAlign()
{
    return m_eTextAlign;
}

//text对齐方式 
void CCheckBox::setTextAlign(enumTextAlign align)
{
//    if (m_eTextAlign == align)
//    {
//        return;
//    }
    m_eTextAlign = align;
    
    if (m_eTextAlign == eTA_Center)
    {
        m_pTextLabel->setAnchorPoint(ccp(0.0f,0.5f));
        m_pTextLabel->setPosition(ccp(
                                      m_pNormalSprite->getPosition().x+m_pNormalSprite->getPreferredSize().width +5,(m_pNormalSprite->getPosition()).y));
    }
    else if(m_eTextAlign == eTA_Left)
    {
        
        m_pTextLabel->setAnchorPoint(ccp(0.0f,0.5f));
        m_pTextLabel->setPosition(ccp(
                                      m_pNormalSprite->getPosition().x+m_pNormalSprite->getPreferredSize().width +5,(m_pNormalSprite->getPosition()).y));
    }
    else if(m_eTextAlign == eTA_Right)
    {
      
        m_pTextLabel->setAnchorPoint(ccp(1.0f,0.5f));
        m_pTextLabel->setPosition(ccp(
                                      m_pNormalSprite->getPosition().x-m_pNormalSprite->getPreferredSize().width -5,(m_pNormalSprite->getPosition()).y));
    }
    
   
}


bool CCheckBox::getChecked()
{
    return m_bCheckState;
}

void CCheckBox::setChecked(bool bChecked)
{
    if( m_bCheckState == bChecked )
        return;
    
    m_bCheckState = bChecked;
    performStateChanged();
}

const char *CCheckBox::getText()
{
    if ( m_pTextLabel )
    {
        return m_pTextLabel->getString();
    }
    
    return NULL;
}

void CCheckBox::setText(const char *lpcszText)
{
    if ( m_pTextLabel == NULL )
    {
        m_pTextLabel = CCLabelTTF::create();
    }
    
    if (strcmp(lpcszText, m_pTextLabel->getString()) == 0)
    {
        return;
    }
    
    m_pTextLabel->setString(lpcszText);
    
    
}

ccColor4B CCheckBox::getColor()
{
    if ( m_pTextLabel )
    {
        return ccc4((m_pTextLabel->getColor()).r,
                    (m_pTextLabel->getColor()).g,
                    (m_pTextLabel->getColor()).b,
                    m_pTextLabel->getOpacity());
    }
    return ccc4(1, 2, 3, 4);
}

void CCheckBox::setColor(ccColor4B &color)
{
    if ( m_pTextLabel )
    {
        m_pTextLabel->setColor(ccc3(color.r, color.g, color.b));
        m_pTextLabel->setOpacity(color.a);
    }
    
}

float CCheckBox::getFontSize()
{
    if (m_pTextLabel)
    {
        return m_pTextLabel->getFontSize();
    }
    return 0.0f;
}

void CCheckBox::setFontSize(float fFontSize)
{
    if (m_pTextLabel->getFontSize() != fFontSize)
    {
        m_pTextLabel->setFontSize(fFontSize);

    }
}

const char *CCheckBox::getFontFamily()
{
    if (m_pTextLabel)
    {
        return m_pTextLabel->getFontName();
    }
    
    return NULL;
}

void CCheckBox::setFontFamily(const char *lpcszFontFamily)
{
    if ( m_pTextLabel )
    {
        m_pTextLabel->setFontName(lpcszFontFamily);
    }
    else
    {
        CCLOG("CCheckBox setFontFamily Wrong!\n");
    }
}

CCLabelTTF *CCheckBox::getLabel()
{
    return m_pTextLabel;
}

const char *CCheckBox::getGroupName()
{
    return m_strGroupName.c_str();
}

void CCheckBox::setGroupName(const char *lpcszGroupName)
{
    m_strGroupName = lpcszGroupName;
}


