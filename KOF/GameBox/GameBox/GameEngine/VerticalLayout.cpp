//
//  VerticalLayout.cpp
//  GameBox
//
//  Created by Caspar on 13-5-8.
//
//

#include "VerticalLayout.h"
#include "MemoryAllocator.h"

using namespace ptola::memory;
using namespace ptola::gui;

MEMORY_MANAGE_OBJECT_IMPL(CVerticalLayout);

CVerticalLayout::CVerticalLayout()
{
    m_eDirection = eLD_Vertical;
}

CVerticalLayout::~CVerticalLayout()
{
    
}


bool CVerticalLayout::init()
{
    if( !CLayout::init() )
        return onInitialized(false);
    return onInitialized(true);
}

bool CVerticalLayout::performLayout()
{
    if(CLayout::performLayout()==false) return false;
    CCArray* children = getChildren();
    
    float x,y;
    
    if(children==NULL)return false;
    for (unsigned int j = 0; j < children->count(); j++)
    {
        CCObject* pChild = children->objectAtIndex(j);
        if( pChild == NULL )
            continue;
        CCNode *pNode = dynamic_cast<CCNode *>(pChild);
        if( pNode == NULL )
            continue;
        
            m_nColumn = ((j)/m_nColumnNodeSum);
        
        x = m_nColumn * m_CellSize.width+m_CellSize.width/2+m_fCellHorizontalSpace*m_nColumn+m_fCellHorizontalSpace*m_nColumn;
        
        y =  (j-m_nColumn*m_nColumnNodeSum) *m_CellSize.height+m_CellSize.height/2+m_fCellVerticalSpace*(j-m_nColumn*m_nColumnNodeSum);
        if(m_bIsHorizontalDirection)
            x = -x;
        
        if(m_bIsVerticalDirection==false)
            y = -y;
        
        pNode->setPosition(ccp(x,y));
        
    }
    return true;
}

void CVerticalLayout::addChild(CCNode *child)
{
    addChild(child,0);
}
void CVerticalLayout::addChild(CCNode* child, int zOrder)
{
    addChild(child,zOrder,child->getTag());
}

void CVerticalLayout::addChild(CCNode* child, int zOrder, int tag)
{
    CLayout::addChild(child,zOrder,tag);
    performLayout();
}

