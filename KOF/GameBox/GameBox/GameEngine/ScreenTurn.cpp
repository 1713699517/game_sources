//
//  ScreenTurn.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#include "ScreenTurn.h"
#include "MemoryAllocator.h"


using namespace ptola::event;
using namespace ptola::memory;

using namespace ptola::gui;


MEMORY_MANAGE_OBJECT_IMPL(CScreenTurn);


CScreenTurn::CScreenTurn()
: m_pButtonPrevious(NULL)
, m_pButtonNext(NULL)
, m_uCurrentPage(1)
{

}

CScreenTurn::~CScreenTurn()
{
    removeAllEventListener();
    
    CC_SAFE_RELEASE_NULL(m_pButtonNext);
    CC_SAFE_RELEASE_NULL(m_pButtonPrevious);
}

//bool CScreenTurn::init()
//{
//    return CUserControl::init();
//}

CScreenTurn *CScreenTurn::create(CContainer *pContainer)
{
    CScreenTurn *pRet = new CScreenTurn();
    
    if (pRet != NULL && pRet->init(pContainer))
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

bool CScreenTurn::init(CContainer *pContainer)
{
    if (!CUserControl::init())
    {
        return onInitialized(false);
    }
    
    setAnchorPoint(ccp(0.5f,0.5f));
    setTouchesEnabled(true);
    
    
    // ..add my code begin..
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    
    m_pButtonPrevious = CButton::create("前一页", "bbutton.png");
    m_pButtonPrevious->setPosition(ccp(m_pButtonPrevious->getContentSize().width/2, winSize.height/2));
    m_pButtonPrevious->addEventListener("TouchBegan", this, eventhandler_selector(CScreenTurn::goPreviousPage));
    
    
    m_pButtonNext = CButton::create("下一页", "bbutton.png");
    m_pButtonNext->setPosition(ccp(winSize.width-m_pButtonNext->getContentSize().width/2, winSize.height/2));
    m_pButtonNext->addEventListener("TouchBegan", this, eventhandler_selector(CScreenTurn::goNextPage));
    
    
    pContainer->addChild(m_pButtonNext);
    pContainer->addChild(m_pButtonPrevious);
    
    
    m_Containers.addObject(pContainer);
    
    CC_SAFE_RETAIN(m_pButtonPrevious);
    CC_SAFE_RETAIN(m_pButtonNext);
    // ..add my code end...
    
    
    return onInitialized(true);
}

void CScreenTurn::onPageTurn(unsigned int nCurrentPage, unsigned int uOldPage)
{
    CCLOG("onPageTurn.\n");
}

void CScreenTurn::goPreviousPage()
{
    CCLOG("goPreviousPage.\n");
}

void CScreenTurn::goNextPage()
{

}