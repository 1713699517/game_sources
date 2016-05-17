//
//  MemroyAllocator.cpp
//  GameBox
//
//  Created by Caspar on 13-7-3.
//
//

#include "MemoryAllocator.h"

using namespace ptola::memory;

CMemoryAllocator *CMemoryAllocator::sharedMemoryAllocator()
{
    static CMemoryAllocator theMemoryAllocator;
    return &theMemoryAllocator;
}