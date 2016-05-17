//
//  CCTouchSet.cpp
//  GameBox
//
//  Created by Caspar on 2013-6-15.
//
//

#include "CCTouchSet.h"

using namespace ptola::script;

CCTouchSet::CCTouchSet(CCSet *pSet)
: m_pSet(pSet)
{
}

int CCTouchSet::count()
{
    return m_pSet == NULL ? 0 : m_pSet->count();
}

CCTouch *CCTouchSet::anyObject()
{
    return m_pSet == NULL ? NULL : (CCTouch *)m_pSet->anyObject();
}

CCTouch *CCTouchSet::at(int nIndex)
{
    return m_pSet == NULL ? NULL : (CCTouch *)m_pSet->at(nIndex);
}