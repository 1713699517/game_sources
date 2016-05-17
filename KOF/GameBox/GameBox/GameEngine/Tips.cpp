//
//  Tips.cpp
//  GameBox
//
//  Created by wrc on 13-5-9.
//
//

#include "Tips.h"
#include "HorizontalLayout.h"
#include "VerticalLayout.h"
#include "cocos2d.h"
#include "CCScale9Sprite.h"
#include "MemoryAllocator.h"

using namespace ptola::memory;

using namespace ptola::gui;


MEMORY_MANAGE_OBJECT_IMPL(CTips);


CTips::CTips():
m_pContainer(NULL)
{

}

CTips::~CTips()
{

}

bool CTips::init(CCSize &cellSize, enumLayoutDirection eDirection,CCScale9Sprite* bg_Sprite)
{
    if( !CFloatLayer::init() )
        return onInitialized(false);
    
    if(eDirection == eLD_Horizontal){
        m_pContainer = CHorizontalLayout::create();
    }
    else if (eDirection == eLD_Vertical){
        m_pContainer =CVerticalLayout::create();
    }
    else{
        m_pContainer =CLayout::create();
    }
    
    m_pSprite = bg_Sprite;
    addChild(bg_Sprite);
    
    
    m_pContainer->setAnchorPoint(ccp(0.5f,0.5f));
    CFloatLayer::addChild(m_pContainer);

    setAnchorPoint(ccp(0.5f,0.5f));
    
    return onInitialized(true);
}

CTips* CTips::create(CCSize& cellSize, enumLayoutDirection eDirection,CCScale9Sprite* bg_Sprite)
{
    CTips *pRet = new CTips();
    if(pRet && pRet->init(cellSize,eDirection,bg_Sprite))
    {
        pRet->autorelease();
        return pRet;
    }
    
    CC_SAFE_DELETE(pRet);
    return NULL;
}


CCArray *CTips::getChildren()
{
    if( getInitialized() )
        return m_pContainer->getChildren();
    else
        return CFloatLayer::getChildren();
    
}

unsigned int CTips::getChildrenCount()
{
    if( getInitialized())
        return m_pContainer->getChildrenCount();
    else
        return CFloatLayer::getChildrenCount();
}


void CTips::addChild(cocos2d::CCNode *child)
{
    if( getInitialized())
        m_pContainer->addChild(child);
    else
        CFloatLayer::addChild(child);
}

void CTips::addChild(CCNode* child, int zOrder)
{
    if(getInitialized())
        m_pContainer->addChild(child, zOrder);
    else
        CFloatLayer::addChild(child, zOrder);
}

void CTips::addChild(CCNode* child, int zOrder, int tag)
{
    if(getInitialized())
        m_pContainer->addChild(child, zOrder, tag);
    else
        CFloatLayer::addChild(child,zOrder,tag);
}

