//
//  TabPage.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#include "TabPage.h"
#include "MemoryAllocator.h"

using namespace ptola::memory;

using namespace ptola::gui;


MEMORY_MANAGE_OBJECT_IMPL(CTabPage);


CTabPage::CTabPage()
{
    
}

bool CTabPage::initWithFile(const char *normalLabel,const char *normalBackgroundSprite)
{
    CButton::initWithFile(normalLabel, normalBackgroundSprite);
    return true;
}
CTabPage::~CTabPage()
{
    
}

CTabPage* CTabPage::create(const char *normalLabel,const char *normalBackgroundSprite)
{
    CTabPage *pRet =create(normalLabel,normalBackgroundSprite,NULL,NULL);
    return pRet;
}

CTabPage* CTabPage::create(const char *normalLabel,const char *normalBackgroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite)
{
    CTabPage *pRet = new CTabPage();
    if( pRet != NULL && pRet->initWithFile(normalLabel, normalBackgroundSprite,checkedLabel,checkedBackGroundSprite) )
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


CTabPage *CTabPage::createWithSpriteFrameName(const char *normalLabel, const char *normalBackgroundSprite)
{
    return createWithSpriteFrameName(normalLabel, normalBackgroundSprite, NULL, NULL);
}

CTabPage *CTabPage::createWithSpriteFrameName(const char *normalLabel,const char *normalBackgroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite)
{
    CTabPage *pRet = new CTabPage;
    if( pRet != NULL && pRet->initWithSpriteFrameName(normalLabel, normalBackgroundSprite, checkedLabel, checkedBackGroundSprite) )
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

bool CTabPage::initWithSpriteFrameName(const char *normalLabel, const char *normalBackgroundSprite, const char *checkedLabel, const char *checkedBackGroundSprite)
{
    return CButton::initWithSpriteFrameName(normalLabel, normalBackgroundSprite, checkedLabel, checkedBackGroundSprite);
}

bool CTabPage::initWithFile(const char *normalLabel,const char *normalBackgroundSprite,const char *checkedLabel,const char *checkedBackGroundSprite)
{
    return CButton::initWithFile(normalLabel, normalBackgroundSprite,checkedLabel,checkedBackGroundSprite);
}



bool CTabPage::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    bool bret = CButton::ccTouchBegan(pTouch, pEvent);
    if( bret )
    {
        getTab()->onTabChange(this);
    }
    return bret;
}

CTab *CTabPage::getTab()
{
    CCNode *pObject = getParent();
    while( pObject != NULL )
    {
        if( dynamic_cast<CTab *>(pObject) != NULL )
            break;
        pObject = pObject->getParent();
    }
    return dynamic_cast<CTab *>(pObject);
}

const CContainer *CTabPage::getContainer()
{
    return m_pContainer;
}
void CTabPage::setContainer(const CContainer *pContainer)
{
    m_pContainer = pContainer;
}
