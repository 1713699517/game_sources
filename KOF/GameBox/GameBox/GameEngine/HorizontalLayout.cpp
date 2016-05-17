//
//  HorizontalLayout.cpp
//  GameBox
//
//  Created by Capsar on 2013-5-8.
//
//

#include "HorizontalLayout.h"

#include "MemoryAllocator.h"

using namespace ptola::gui;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CHorizontalLayout);




CHorizontalLayout::CHorizontalLayout()
{
    m_eDirection = eLD_Horizontal;
}

CHorizontalLayout::~CHorizontalLayout()
{
    
}

bool CHorizontalLayout::init()
{
    if( !CLayout::init() )
        return onInitialized(false);
    return onInitialized(true);
}

bool CHorizontalLayout::performLayout()
{
    if(CLayout::performLayout()==false)
        return false;
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

        m_nRow = ((j)/m_nLineNodeSum);

        x = (j-m_nRow*m_nLineNodeSum) * m_CellSize.width+m_CellSize.width/2+m_fCellHorizontalSpace*(j-m_nRow*m_nLineNodeSum);

        if(!m_bIsHorizontalDirection)
            x = -x;
        
        y = m_nRow * m_CellSize.height+m_fCellVerticalSpace*m_nRow;
        
        if(m_bIsVerticalDirection==false)
            y = -y;
        
        pNode->setPosition(ccp(x,y));
        
    }
    return true;
}

void CHorizontalLayout::addChild(CCNode *child)
{
    addChild(child,0);
}
void CHorizontalLayout::addChild(CCNode* child, int zOrder)
{
    addChild(child,zOrder,child->getTag());
}

void CHorizontalLayout::addChild(CCNode* child, int zOrder, int tag)
{
    CLayout::addChild(child,zOrder,tag);
}

