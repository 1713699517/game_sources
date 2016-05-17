//
//  PageTurn.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#include "PageTurn.h"
#include "EventHandler.h"
#include "MemoryAllocator.h"


using namespace ptola::gui;
using namespace ptola::event;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CPageTurn);


CPageTurn::CPageTurn()
: m_uCurrentPage(1)
, m_uMaxPages(1)
, m_pButtonPrevious(NULL)
, m_pButtonNext(NULL)
, m_pLabelPage(NULL)
{

}

CPageTurn::~CPageTurn()
{
    
    removeAllEventListener();
    
    CC_SAFE_RELEASE_NULL(m_pButtonNext);
    CC_SAFE_RELEASE_NULL(m_pButtonPrevious);
    CC_SAFE_RELEASE_NULL(m_pLabelPage);
}


CPageTurn *CPageTurn::create(CContainer *pContainer,unsigned int uCurrentPage,unsigned int uMaxPages)
{
    CPageTurn *pRet = new CPageTurn();
    
    if (pRet!=NULL && pRet->init(pContainer, uCurrentPage, uMaxPages))
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


bool CPageTurn::init(CContainer *pContainer,unsigned int uCurrentPage,unsigned int uMaxPages)
{
    if (!CUserControl::init())
    {
        return onInitialized(false);
    }
    
    // ..add my code begin..
    setAnchorPoint(ccp(0.5f,0.5f));
    setTouchesEnabled(true);
    
    setCurrentPage(uCurrentPage);
    setMaxPages(uMaxPages);
    
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    
    
    char tempChar[128] = {0};
    sprintf(tempChar, "%d/%d",m_uCurrentPage,m_uMaxPages);
    m_pLabelPage = CCLabelTTF::create(tempChar, "Arial",45);
    
    
    
    m_pLabelPage->setString(tempChar);
    m_pLabelPage->setPosition(ccp(winSize.width/2, 50));
    addChild(pContainer);
    
    pContainer->addChild(m_pLabelPage);
    
    m_pButtonPrevious = CButton::create("前一页", "bbutton.png");
    m_pButtonPrevious->setPosition(ccp(m_pButtonPrevious->getContentSize().width/2, winSize.height/2));
    m_pButtonPrevious->addEventListener(EVENT_BEGAN, this, eventhandler_selector(CPageTurn::goPreviousPage));

    m_pButtonNext = CButton::create("下一页", "bbutton.png");
    m_pButtonNext->setPosition(ccp(winSize.width-m_pButtonNext->getContentSize().width/2, winSize.height/2));
    m_pButtonNext->addEventListener(EVENT_BEGAN, this, eventhandler_selector(CPageTurn::goNextPage));
    
    
    pContainer->addChild(m_pButtonNext);
    pContainer->addChild(m_pButtonPrevious);
    
    m_Containers.addObject(pContainer);
    
    CC_SAFE_RETAIN(m_pButtonPrevious);
    CC_SAFE_RETAIN(m_pButtonNext);
    CC_SAFE_RETAIN(m_pLabelPage);
    
    // ..add my code end....
    
    return onInitialized(true);
}


void CPageTurn::goPreviousPage(CCObject *pSender)
{
    if (m_uCurrentPage <= 1)
    {
        return;
    }
    m_uCurrentPage--;
    char tempChar[128] = {0};
    sprintf(tempChar, "%d/%d",m_uCurrentPage,m_uMaxPages);

    m_pLabelPage->setString(tempChar);
}

void CPageTurn::goNextPage(CCObject *pSender)
{
    if (m_uMaxPages <= m_uCurrentPage)
    {
        return;
    }
    m_uCurrentPage++;
    char tempChar[128] = {0};
    sprintf(tempChar, "%d/%d",m_uCurrentPage,m_uMaxPages);
    
    m_pLabelPage->setString(tempChar);
}

void CPageTurn::setCurrentPage(unsigned int uPage)
{
    if (m_uCurrentPage == uPage)
    {
        return;
    }
    
    m_uCurrentPage = uPage;
    
}

unsigned int CPageTurn::getCurrentPage()
{
    return m_uCurrentPage;
}


void CPageTurn::setMaxPages(unsigned int uPages)
{
    m_uMaxPages = uPages;
}

unsigned int CPageTurn::getMaxPages()
{
    return m_uMaxPages;
}


const char *CPageTurn::getText()
{
    if (m_pLabelPage)
    {
        return m_pLabelPage->getString();
    }
    
    return NULL;
}

void CPageTurn::setText(const char *lpcszText)
{
    if (m_pLabelPage == NULL)
    {
        m_pLabelPage = CCLabelTTF::create();
    }
    
    if(strcmp(lpcszText, m_pLabelPage->getString()) == 0)
        return;
    
    m_pLabelPage->setString(lpcszText);
    addChild(m_pLabelPage);

}

ccColor4B CPageTurn::getColor()
{
    if (m_pLabelPage)
    {
        return ccc4(m_pLabelPage->getColor().r,
                    m_pLabelPage->getColor().g,
                    m_pLabelPage->getColor().b,
                    m_pLabelPage->getOpacity());
    }
    
    return ccc4(1,2,3,4);
}

void CPageTurn::setColor(ccColor4B &color)
{
    if (m_pLabelPage)
    {
        m_pLabelPage->setColor(ccc3(color.r, color.g, color.b));
        m_pLabelPage->setOpacity(color.a);
    }
}

float CPageTurn::getFontSize()
{
    if (m_pLabelPage)
    {
        return m_pLabelPage->getFontSize();
    }
    
    return 0.0f;
}

void CPageTurn::setFontSize(float fFontSize)
{
    if ( m_pLabelPage->getFontSize() == fFontSize)
    {
        return; 
    }
    
    m_pLabelPage->setFontSize(fFontSize);
}

const char *CPageTurn::getFontFamily()
{
    if (m_pLabelPage)
    {
        return m_pLabelPage->getFontName();
    }
    
    return NULL;
}

void CPageTurn::setFontFamily(const char *lpcszFontFamily)
{
    if (m_pLabelPage)
    {
        m_pLabelPage->setFontName(lpcszFontFamily);
    }
}

CCLabelTTF *CPageTurn::getLabel()
{
    return m_pLabelPage;
}

void CPageTurn::onPageTurn(unsigned int nCurrentPage, unsigned int uOldPage)
{
    
}

bool CPageTurn::containsPoint(CCPoint *pGLPoint)
{
    CCSize tempSize = m_pButtonPrevious->getContentSize();
    
    CCPoint anchorPoint = getAnchorPoint();
    CCRect tempRect = CCRectMake(-tempSize.width*anchorPoint.x, -tempSize.height*anchorPoint.y, tempSize.width, tempSize.height);
    
    return tempRect.containsPoint(*pGLPoint);
}

void CPageTurn::onTouchInside()
{
    if(m_pButtonPrevious == NULL || m_pButtonNext == NULL)
        return;
    
}


