//
//  RadioBox.cpp
//  GameBox
//
//  Created by Caspar on 13-5-8.
//
//

#include "RadioBox.h"
#include "MemoryAllocator.h"


using namespace ptola::event;
using namespace ptola::memory;

using namespace ptola::gui;


MEMORY_MANAGE_OBJECT_IMPL(CRadioBox);

CRadioBox::CRadioBox()
: m_bChecked(false)
{

}

CRadioBox::~CRadioBox()
{
    
}


void CRadioBox::setChecked(bool bChecked)
{
    if (m_bChecked == bChecked)
    {
        return;
    }
    
    m_bChecked = bChecked;
    performGroupStateChanged();
}


void CRadioBox::performGroupStateChanged()
{
    CContainer *pParentContainer = NULL;
    CCNode *pParent = getParent();
    while( pParent != NULL )
    {
        CContainer *pContainer = dynamic_cast<CContainer *>(pParent);
        if( pContainer != NULL && pContainer->getIsForm() )
        {
            pParentContainer = pContainer;
            break;
        }
        pParent = pParent->getParent();
    }
    
    if(pParentContainer == NULL)
        return;
    
    
}

