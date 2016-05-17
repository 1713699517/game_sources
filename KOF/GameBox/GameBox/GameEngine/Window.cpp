//
//  Window.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#include "Window.h"

#include "MemoryAllocator.h"
#define DEFAULT_CWINDOW_FONT_FAMILY "Arial"
#define DEFAULT_CWINDOW_FONT_SIZE   12.0f




using namespace ptola::memory;
using namespace ptola::gui;


MEMORY_MANAGE_OBJECT_IMPL(CWindow);



CWindow::CWindow()
: m_pNCBar(NULL)
, m_pContainer(NULL)
, m_pScene(NULL)
{

}

CWindow::~CWindow()
{
    CC_SAFE_RELEASE_NULL(m_pNCBar);
    CC_SAFE_RELEASE_NULL(m_pContainer);
    CC_SAFE_RELEASE_NULL(m_pScene);
}
//---
CWindow *CWindow::create(CSprite *pBackground, CButton *pCloseBtn, CContainer *pContainer)
{
    CWindow *pRet = new CWindow();
    
    if (pRet && pRet->initWithFile(pBackground, pCloseBtn, pContainer))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

bool CWindow::initWithFile(CSprite *pBackground, CButton *pCloseBtn, CContainer *pContainer)
{
    return initWithFile(NULL, pBackground, NULL, pCloseBtn, pContainer, false);
}

CWindow *CWindow::create(const char *lpcszBackground, const char *lpcszClose, CContainer *pContainer)
{
    CWindow *pRet = new CWindow();
    
    if (pRet && pRet->initWithFile(lpcszBackground, lpcszClose, pContainer))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;
}

bool CWindow::initWithFile(const char *lpcszBackground, const char *lpcszClose, CContainer *pContainer)
{
    CSprite *pBackground = CSprite::create(lpcszBackground);
    CButton *pCloseBtn = CButton::create("", lpcszClose);
    
    return initWithFile(pBackground, pCloseBtn, pContainer);
                     
}


CWindow *CWindow::createWithSpriteFrameName(const char *lpcszBackground, const char *lpcszClose, CContainer *pContainer)
{
    CWindow *pRet = new CWindow();
    
    if (pRet && pRet->initWithFrameName(lpcszBackground, lpcszClose, pContainer))
    {
        pRet->autorelease();
        return pRet;
    }
    CC_SAFE_DELETE(pRet);
    return NULL;

}

bool CWindow::initWithFrameName(const char *lpcszBackground, const char *lpcszClose, CContainer *pContainer)

{
    CSprite *pBackground = CSprite::createWithSpriteFrameName(lpcszBackground);
    CButton *pCloseBtn = CButton::createWithSpriteFrameName("", lpcszClose);
    
    return initWithFile(NULL, pBackground, NULL, pCloseBtn, pContainer, false);
}

//--------

CWindow *CWindow::create(CCLabelTTF *pLabel, CSprite *pBackground, CSprite *pBarBackground,CButton *pCloseBtn, CContainer *pContainer, bool bDefaultBar)
{
    CWindow *pRet = new CWindow();
    
    if ( pRet && pRet->initWithFile(pLabel, pBackground, pBarBackground,pCloseBtn, pContainer, bDefaultBar) )
    {
        pRet->autorelease();
        return pRet;
    }
    
    CC_SAFE_DELETE(pRet);
    return NULL;
}

bool CWindow::initWithFile(CCLabelTTF *pLabel, CSprite *pBackground, CSprite *pBarBackground,CButton *pCloseBtn, CContainer *pContainer, bool bDefaultBar)
{
    if( !CUserControl::init() )
        return onInitialized(false);
    
    CCSize nSize = CCDirector::sharedDirector()->getWinSize();
    CCLOG("width===%f, height ===%f  \n", nSize.width, nSize.height);
    
    m_pContainer = pContainer;
    
    if (m_pContainer != NULL)
    {
        m_pContainer->setPosition(ccp(0, 0));
    }
   
    
    if (pBackground != NULL)
    {
        pBackground->setPreferredSize(CCSizeMake(nSize.width*3/4, nSize.height*3/4));
        pBackground->setPosition(ccp(nSize.width/2, nSize.height/2));
        
       
        addChild(pBackground, 0);
    }
    
    //CSprite *pBarBackground = CSprite::create("SelectServerBtn.png");
    if(bDefaultBar == true)
    {
        if(pLabel != NULL)
        {
            m_pNCBar = CNCBar::create(pLabel, pCloseBtn, pBarBackground);
        
            CCSize spriteSize = CCSizeMake(pBackground->getPreferredSize().width,m_pNCBar->getCloseButton()->getPreferredSize().height);
        
            m_pNCBar->getCloseButton()->setPosition(ccp(nSize.width/2+pBackground->getPreferredSize().width/2-pCloseBtn->getPreferredSize().width/2, m_pNCBar->getCloseButton()->getPosition().y));
        
            m_pNCBar->getBackgroundSprite()->setPreferredSize(spriteSize);
        
            m_pNCBar->setPosition(ccp(0,
                                  pBackground->getPreferredSize().height/2+m_pNCBar->getCloseButton()->getPreferredSize().height/5));
        
            m_pNCBar->getCloseButton()->setTouchesPriority(-1);
            m_pNCBar->getCloseButton()->addEventListener("TouchBegan", this, eventhandler_selector(CWindow::closeCallback));
        
            addChild(m_pNCBar, 1, 5);
            
            CC_SAFE_RETAIN(m_pNCBar);
        }
    }
    else
    {
        if ( pCloseBtn != NULL )
        {
            pCloseBtn->setPosition(ccp(nSize.width/2+pBackground->getPreferredSize().width/2-pCloseBtn->getPreferredSize().width/2, nSize.height/2+pBackground->getPreferredSize().height/2-pCloseBtn->getPreferredSize().height/2 ));
            
            pCloseBtn->setTouchesPriority(pCloseBtn->getTouchesPriority()-1);
            pCloseBtn->addEventListener("TouchBegan", this, eventhandler_selector(CWindow::closeCallback));
            
            addChild(pCloseBtn, 1, 5);
        }
    }

    
    CFloatLayer::addChild(m_pContainer);
    
   
    CC_SAFE_RETAIN(m_pContainer);
    
    setAnchorPoint(ccp(0.5f, 0.5f));
    setFullScreenTouchEnabled(true);
    
    setTouchesEnabled(true);
    return onInitialized(true);
}

void CWindow::closeCallback(CCObject *pSender)
{

    this->removeFromParentAndCleanup(true);

}

CWindow *CWindow::create(const char *lpcszTitle, const char *lpcszBackground, const char *lpcszBarBackground,const char *lpcszClose, CContainer *pContainer, bool bDefaultBar)
{
    CWindow *pRet = new CWindow();
    
    if (pRet && pRet->initWithFile(lpcszTitle, lpcszBackground, lpcszBarBackground,lpcszClose, pContainer, bDefaultBar))
    {
        pRet->autorelease();
        return pRet;
    }
    
    CC_SAFE_DELETE(pRet);
    return NULL;
    
}

bool CWindow::initWithFile(const char *lpcszTitle, const char *lpcszBackground, const char *lpcszBarBackground,const char *lpcszClose, CContainer *pContainer, bool bDefaultBar)
{
    CCLabelTTF *pLabel = NULL;
    CSprite *pBarBackground = NULL;
    
    if (bDefaultBar == true)
    {
        pLabel = CCLabelTTF::create(lpcszTitle, DEFAULT_CWINDOW_FONT_FAMILY, DEFAULT_CWINDOW_FONT_SIZE );
        pBarBackground = CSprite::create(lpcszBarBackground);

    }
    
    CSprite *pBackground = CSprite::create(lpcszBackground);
    CButton *pCloseBtn = CButton::create("", lpcszClose);
        
    return initWithFile(pLabel, pBackground, pBarBackground,pCloseBtn, pContainer, bDefaultBar);
}

CWindow *CWindow::createWithSpriteFrameName(const char *lpcszTitle, const char *lpcszBackground, const char *lpcszBarBackground,const char *lpcszClose, CContainer *pContainer, bool bDefaultBar)
{
    CWindow *pRet = new CWindow();
    
    if (pRet && pRet->initWithFrameName(lpcszTitle, lpcszBackground, lpcszBackground, lpcszClose, pContainer, bDefaultBar))
    {
        pRet->autorelease();
        return pRet;
    }
    
    CC_SAFE_DELETE(pRet);
    return NULL;
}

bool CWindow::initWithFrameName(const char *lpcszTitle, const char *lpcszBackground, const char *lpcszBarBackground,const char *lpcszClose, CContainer *pContainer, bool bDefaultBar)
{
    CCLabelTTF *pLabel = NULL;
    CSprite *pBarBackground = NULL;
    
    if (bDefaultBar == true)
    {
        pLabel = CCLabelTTF::create(lpcszTitle, DEFAULT_CWINDOW_FONT_FAMILY, DEFAULT_CWINDOW_FONT_SIZE );
        pBarBackground = CSprite::create(lpcszBarBackground);
        
    }
    
    CSprite *pBackground = CSprite::createWithSpriteFrameName(lpcszBackground);
    CButton *pCloseBtn = CButton::createWithSpriteFrameName("", lpcszClose);
    
    

    
    return initWithFile(pLabel, pBackground, pBarBackground,pCloseBtn, pContainer, bDefaultBar);
}


CCArray *CWindow::getChildren()
{
    return m_pContainer->getChildren();
}

unsigned int CWindow::getChildrenCount()
{
    return m_pContainer->getChildrenCount();
}

void CWindow::addChild(cocos2d::CCNode *child)
{
    //check if is CMenuItem
    if( getInitialized())
        m_pContainer->addChild(child);
    else
        CFloatLayer::addChild(child);
}

void CWindow::addChild(CCNode* child, int zOrder)
{
    //check if is CMenuItem
    if( getInitialized())
        m_pContainer->addChild(child, zOrder);
    else
        CFloatLayer::addChild(child, zOrder);
}

void CWindow::addChild(CCNode* child, int zOrder, int tag)
{
    //check if is CMenuItem
    if( getInitialized())
        m_pContainer->addChild(child, zOrder, tag);
    else
        CFloatLayer::addChild(child, zOrder, tag);
}


void CWindow::setWindowTitle(const char *lpcszInputTitle)
{
    if (m_pNCBar != NULL)
    {
        m_pNCBar->setText(lpcszInputTitle);
    }
}

const char *CWindow::getWindowTitle()
{
    if (m_pNCBar != NULL)
    {
        return m_pNCBar->getText();
    }
    return NULL;
}


//end--

CCScene *CWindow::getFullScreenScene()
{
    CC_SAFE_RETAIN(m_pScene);
    
    if (m_pScene == NULL)
    {
        m_pScene = CCScene::create();
        
        CWindow *pWindow = CWindow::create("窗口", "HelloWorld.png", "HelloWorld.png", "CloseNormal.png", m_pContainer);
        
        m_pScene->addChild(pWindow);
        
        return m_pScene;
        
    }
    
    return m_pScene;
}





