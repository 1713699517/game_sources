//
//  TouchContainer.cpp
//  GameBox
//
//  Created by Caspar on 13-9-18.
//
//

#include "TouchContainer.h"

#include "MemoryAllocator.h"

using namespace ptola::gui;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CTouchContainer);

CTouchContainer::CTouchContainer()
{

}

CTouchContainer::~CTouchContainer()
{

}

bool CTouchContainer::init()
{
    if( !CContainer::init() )
        return onInitialized(false);
    return onInitialized(true);
}

bool CTouchContainer::containsPoint(cocos2d::CCPoint *pPoint)
{
    return true;
}