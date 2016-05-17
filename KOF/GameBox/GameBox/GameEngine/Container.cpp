//
//  Container.cpp
//  GameBox
//
//  Created by Capsar on 2013-5-8.
//
//

#include "Container.h"
#include "MemoryAllocator.h"

using namespace ptola::gui;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CContainer);

CContainer::CContainer()
: m_bIsForm(false)
{

}

CContainer::~CContainer()
{
    
}

bool CContainer::init()
{
    if( !CUserControl::init() )
        return onInitialized(false);
    return onInitialized(true);
}

void CContainer::setIsForm(bool bIsForm)
{
    m_bIsForm = bIsForm;
}

bool CContainer::getIsForm()
{
    return m_bIsForm;
}