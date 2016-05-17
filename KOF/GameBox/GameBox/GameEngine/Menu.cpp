//
//  Menu.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#include "Menu.h"
#include "Button.h"


#include "MemoryAllocator.h"

using namespace ptola::gui;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CMenu);


CMenu::CMenu() :
m_pCellSize(0),
m_pContainer(NULL)
{
    
}

CMenu::~CMenu()
{
    
}

CMenu* CMenu::create(CCSize& cellSize, enumLayoutDirection eDirection,CCScale9Sprite* bg_Spirte)
{
    CMenu *pRet = new CMenu();
    if(pRet && pRet->init(cellSize,eDirection,bg_Spirte))
    {
        pRet->autorelease();
        return pRet;
    }
    
    CC_SAFE_DELETE(pRet);
    return NULL;
}


bool CMenu::init(CCSize &cellSize, enumLayoutDirection eDirection,CCScale9Sprite* bg_Spirte)
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

    m_pSprite = bg_Spirte;
    m_pSprite->setAnchorPoint(ccp(0.5f,0.5f));
    
    addChild(bg_Spirte);
    
    m_pContainer->setAnchorPoint(ccp(0.5f,0.5f));
    CFloatLayer::addChild(m_pContainer);
    

    setAnchorPoint(ccp(0.5f, 0.5f));
     
    //    CCArray * pArrayOfItems = getChildren();
    //
    // //   unsigned int sum = getChildrenCount();
    //
    //    CCObject* pObj = NULL;
    //    if (pArrayOfItems != NULL)
    //    {
    //        int z=0;
    //        CCObject* pObj = NULL;
    //        CCARRAY_FOREACH(pArrayOfItems, pObj)
    //        {
    //            CCMenuItem* item = (CCMenuItem*)pObj;
    //            m_pContainer->addChild(item);
    //           // z++;
    //        }
    //    }
    

    
    return onInitialized(true);
    
}

CCArray *CMenu::getChildren()
{
    if( getInitialized() )
        return m_pContainer->getChildren();
    else
        return CFloatLayer::getChildren();
}

unsigned int CMenu::getChildrenCount()
{
    if(getInitialized())
        return m_pContainer->getChildrenCount();
    else
        return CFloatLayer::getChildrenCount();
}

void CMenu::addChild(cocos2d::CCNode *child)
{
    //check if is CMenuItem
    //   CCAssert( dynamic_cast<CMenuItem*>(child) != NULL, "Menu only supports MenuItem objects as children");
    if( getInitialized() )
        m_pContainer->addChild(child);
    else
        CFloatLayer::addChild(child);
}

void CMenu::addChild(CCNode* child, int zOrder)
{
    //check if is CMenuItem
    //   CCAssert( dynamic_cast<CMenuItem*>(child) != NULL, "Menu only supports MenuItem objects as children");
    if( getInitialized() )
        m_pContainer->addChild(child, zOrder);
    else
        CFloatLayer::addChild(child, zOrder);
}

void CMenu::addChild(CCNode* child, int zOrder, int tag)
{
    //check if is CMenuItem
    //    CCAssert( dynamic_cast<CMenuItem*>(child) != NULL, "Menu only supports MenuItem objects as children");
    if( getInitialized() )
        m_pContainer->addChild(child, zOrder, tag);
    else
        CFloatLayer::addChild(child, zOrder, tag);
}

void CMenu::show(CCNode *pParent, const cocos2d::CCPoint &pos, enumActionType eActionType)
{
    show(pParent, pos.x, pos.y, eActionType);
}

void CMenu::show(CCNode *pParent, float fx, float fy, enumActionType eActionType)
{
    //getActionType
    setPosition(ccp(fx,fy));
    pParent->addChild(this);
 

    CCArray * pArrayOfItems = m_pContainer->getChildren();
    unsigned int sum = m_pContainer->getChildrenCount();
    for(unsigned int i = 0;i<sum;i++)
    {
        CCAction *pAction = getActionByType(eActionType);
        CCObject* pChild = pArrayOfItems->objectAtIndex(i);
        CCNode *pNode = dynamic_cast<CCNode*>(pChild);
        if (pChild && pNode)
        {
            pNode->runAction(pAction);
        }
            
    }
}

void CMenu::hide(enumActionType eActionType)
{
    if( eActionType == eAT_None )
    {
        removeFromParentAndCleanup(false);
    }
    else
    {
        CCArray * pArrayOfItems = m_pContainer->getChildren();
        unsigned int sum = m_pContainer->getChildrenCount();
        for(unsigned int i = 0;i<sum;i++)
        {
            CCAction *pAction = getActionByType(eActionType);
            CCObject* pChild = pArrayOfItems->objectAtIndex(i);
            CCNode *pNode = dynamic_cast<CCNode*>(pChild);
            if (pChild && pNode)
            {
                CCCallFuncN* callback = CCCallFuncN::create(this, callfuncN_selector( CMenu::actionCallback));
                
               pNode->runAction(CCSequence::create((CCActionInterval*)pAction,callback,NULL ));
            }
            
        }
        
    }
}

void CMenu::actionCallback()
{
    removeFromParentAndCleanup(false);
}




