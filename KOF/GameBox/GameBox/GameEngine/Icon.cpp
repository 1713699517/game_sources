//
//  Icon.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#include "Icon.h"
#include "MovieClip.h"
#include "Sprite.h"
#include "MemoryAllocator.h"

using namespace ptola::gui;
using namespace std;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CIcon);

CIcon::CIcon()
{
    
}

CIcon::~CIcon()
{
    
}


bool CIcon::init()
{
    return CUserControl::init();
}

CCNode *CIcon::initialize(const char *lpcszResourceName)
{
    return NULL;
}

bool CIcon::containsPoint(CCPoint *pPoint)
{
    CCSize tempsize = m_pSprite->getContentSize();
    CCPoint anchorPoint = getAnchorPoint();
    CCRect temp = CCRectMake(-tempsize.width*anchorPoint.x,-tempsize.height*anchorPoint.y,tempsize.width,tempsize.height);
    return temp.containsPoint(*pPoint);
}

CIcon* CIcon::create(const char *lpcszResourceName)
{
    CIcon *pIcon = new CIcon();
    if (pIcon && pIcon->init(lpcszResourceName))
    {
        pIcon->autorelease();
        return pIcon;
    }
    CC_SAFE_DELETE(pIcon);
    return NULL;
}

bool CIcon::init(const char *lpcszResourceName)
{
    setTouchesEnabled(true);
    setAnchorPoint(ccp(0.5,0.5));
    string temp = lpcszResourceName;
    int i = temp.find(".ccbi");
    
    if((temp.length()-i)==5)
        m_pSprite = CMovieClip::create(lpcszResourceName,NULL);
    else
        m_pSprite = CSprite::create(lpcszResourceName);
    addChild(m_pSprite);
    return true;
}

CIcon* CIcon::createWithSpriteFrameName(const char *lpcszResourceName)
{
    CIcon *pIcon = new CIcon();
    
    if (pIcon && pIcon->initWithSpriteFrameName(lpcszResourceName))
    {
        pIcon->autorelease();
        return pIcon;
    }
    
    CC_SAFE_DELETE(pIcon);
    return NULL;
}

bool CIcon::initWithSpriteFrameName(const char *lpcszResourceName)
{
    setTouchesEnabled(true);
    setAnchorPoint(ccp(0.5,0.5));
    
    m_pSprite = CSprite::createWithSpriteFrameName(lpcszResourceName);
    
    addChild(m_pSprite);
    return true;
    
}

void CIcon::onTouchInside()
{
    CCLog("CIcon::onTouchInside");
}


