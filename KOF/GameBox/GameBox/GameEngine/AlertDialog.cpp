//
//  AlertDialog.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#include "AlertDialog.h"
#include "VerticalLayout.h"


#define DEFAULT_CALERTDIALOG_FONT_FAMILY    "Helvetica"
#define DEFAULT_CALERTDIALOG_FONT_SIZE      30

using namespace ptola::gui;


CAlertDialog *CAlertDialog::sharedAlertDialog()
{
    static CAlertDialog dialog;
    return &dialog;
}


CAlertDialog::CAlertDialog()
: m_fTime(5.0f)
, m_pButtonClose(NULL)
, m_pMessageLayout(NULL)
, m_size(CCSizeMake(280, 220))
{
    init(NULL);
}

CAlertDialog::~CAlertDialog()
{
    CC_SAFE_RELEASE_NULL(m_pParent);
    CC_SAFE_RELEASE_NULL(m_pButtonClose);
    CC_SAFE_RELEASE_NULL(m_pMessageLayout);
}

bool CAlertDialog::init(CCNode *pParent)
{
    m_pParent = pParent;
    
    return CFloatLayer::init();
}




CAlertDialog *CAlertDialog::create(CCSize &cellSize,enumLayoutDirection eDirection)
{
    CAlertDialog *pRet = new CAlertDialog();
    
    if (pRet && pRet->init(cellSize, eDirection))
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

bool CAlertDialog::init(CCSize &cellSize, enumLayoutDirection eDirection)
{
    setAlertDialogSize(cellSize);
    
    if( !CFloatLayer::init() )
        return onInitialized(false);
    
    setAnchorPoint(ccp(0.5f,0.5f));
    
    //addChild(pParent);
    
    //关闭按钮
    m_pButtonClose= CButton::create("确定", "bbutton.png");
    m_pButtonClose->setPosition(ccp(cellSize.width/2, cellSize.height/2));
    m_pButtonClose->addEventListener("TouchBegan", this, eventhandler_selector(CAlertDialog::closeCallBack));
    addChild(m_pButtonClose);
    
    //5.0秒后自动消失
    appendMessage("testtesttesttesttesttesttest");
    //--schedule(schedule_selector(CAlertDialog::removeAlertDialog), m_fTime);
    
    m_pMessageLayout = CVerticalLayout::create();
    m_pMessageLayout->setAnchorPoint(ccp(0.5f,0.5f));

    CFloatLayer::addChild(m_pMessageLayout);
    
    CC_SAFE_RETAIN(m_pParent);
    CC_SAFE_RETAIN(m_pButtonClose);
    CC_SAFE_RETAIN(m_pMessageLayout);
    
    return onInitialized(true);
}

void CAlertDialog::appendMessage(const char *lpcszMessage)
{
    CCLabelTTF *pLabel = CCLabelTTF::create(lpcszMessage, DEFAULT_CALERTDIALOG_FONT_FAMILY, DEFAULT_CALERTDIALOG_FONT_SIZE);
    addChild(pLabel);
    pLabel->setPosition(ccp(m_size.width/2, m_size.height/2+m_pButtonClose->getContentSize().height));
    
    
    schedule(schedule_selector(CAlertDialog::removeAlertDialog), m_fTime);
}

void CAlertDialog::removeAlertDialog()
{
    
    unschedule(schedule_selector(CAlertDialog::removeAlertDialog));
    
    removeFromParentAndCleanup(true);
    
}

float CAlertDialog::getDisplayTime()
{
    return m_fTime;
}


void CAlertDialog::setDisplayTime(float fTime)
{
    if (m_fTime == fTime) {
        return;
    }
    
    m_fTime = fTime;
    //hide
}


unsigned int CAlertDialog::getChildrenCount()
{
    if( getInitialized())
        return m_pMessageLayout->getChildrenCount();
    else
        return CFloatLayer::getChildrenCount();
}

CCArray *CAlertDialog::getChildren()
{
    if ( getInitialized() )
    {
        return m_pMessageLayout->getChildren();
    }
    else
    {
        return CFloatLayer::getChildren();
    }
}

void CAlertDialog::addChild(cocos2d::CCNode *child)
{
    if( getInitialized())
        m_pMessageLayout->addChild(child);
    else
        CFloatLayer::addChild(child);
}

void CAlertDialog::addChild(CCNode* child, int zOrder)
{
    if(getInitialized())
        m_pMessageLayout->addChild(child, zOrder);
    else
        CFloatLayer::addChild(child, zOrder);
}

void CAlertDialog::addChild(CCNode* child, int zOrder, int tag)
{
    if(getInitialized())
        m_pMessageLayout->addChild(child, zOrder, tag);
    else
        CFloatLayer::addChild(child,zOrder,tag);
}

void CAlertDialog::closeCallBack(CCObject *pSender)
{
    removeFromParentAndCleanup(true);
}

//2013.06.06  hlc 新增提示框大小
void CAlertDialog::setAlertDialogSize(CCSize &size)
{
    m_size = size;
}

const CCSize &CAlertDialog::getAlertDialogSize()
{
    return m_size;
}


