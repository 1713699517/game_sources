//
//  Layout.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#include "Layout.h"
#include "HorizontalLayout.h"
#include "VerticalLayout.h"

#include "MemoryAllocator.h"

using namespace ptola::gui;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CLayout);


CLayout::CLayout()
: m_eDirection(eLD_Relative),
m_CellSize(CCSizeMake(100, 100)),
m_fCellHorizontalSpace(0.0f),
m_bIsVerticalDirection(true),
m_bIsHorizontalDirection(true),
m_nColumnNodeSum(5),
m_nLineNodeSum(5),
m_fCellVerticalSpace(0.0f)
{
    
}

CLayout::CLayout(CCSize CellSize):
m_eDirection(eLD_Relative),
m_CellSize(CellSize),
m_bIsVerticalDirection(true),
m_bIsHorizontalDirection(true),
m_nColumnNodeSum(5),
m_nLineNodeSum(5),
m_fCellHorizontalSpace(0.0f),
m_fCellVerticalSpace(0.0f)
{
    
}

CLayout::~CLayout()
{
    
}

bool CLayout::init()
{
    return true;
}

bool CLayout::performLayout()
{
    
    return true;
}

CCSize &CLayout::getCellSize()
{
    return m_CellSize;
}

void CLayout::setCellSize(const cocos2d::CCSize &value)
{
    m_CellSize = value;
    
    performLayout();
}

void CLayout::setCellHorizontalSpace(float fValue)
{
    m_fCellHorizontalSpace = fValue;
    
    performLayout();
}

float CLayout::getCellHorizontalSpace()
{
    return m_fCellHorizontalSpace ;
}

float CLayout::getCellVerticalSpace()
{
    return m_fCellVerticalSpace ;
}

void CLayout::setCellVerticalSpace(float fValue)
{
    m_fCellVerticalSpace = fValue;
    performLayout();
}

void CLayout::addChild(cocos2d::CCNode *child)
{
    CContainer::addChild(child);
    performLayout();
}

void CLayout::addChild(CCNode* child, int zOrder)
{
    CContainer::addChild(child, zOrder);
    performLayout();
}

void CLayout::addChild(CCNode* child, int zOrder, int tag)
{
    CContainer::addChild(child, zOrder, tag);
    performLayout();
}

void CLayout::removeChild(CCNode *child)
{
    CContainer::removeChild(child);
    performLayout();
}

void CLayout::removeChild(CCNode *child, bool cleanup)
{
    CContainer::removeChild(child, cleanup);
    performLayout();
}

CLayout* CLayout::create(enumLayoutDirection m_value)
{
    CLayout *pRet = NULL;
    
    if(m_value == eLD_Relative)
        pRet = new CLayout();
    
    if(m_value == eLD_Horizontal)
        pRet = new CHorizontalLayout();
    
    if(m_value == eLD_Vertical)
        pRet = new CVerticalLayout();
    
    if (pRet!=NULL && pRet->init())
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

int CLayout::getLayoutDirection()
{
    return m_eDirection;
}
