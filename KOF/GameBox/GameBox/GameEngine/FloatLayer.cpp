//
//  FloatLayer.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#include "FloatLayer.h"
#include "Actions.h"
#include "MemoryAllocator.h"

using namespace ptola::gui;
using namespace ptola::memory;


MEMORY_MANAGE_OBJECT_IMPL(CFloatLayer);


CFloatLayer::CFloatLayer()
{

}

CFloatLayer::~CFloatLayer()
{
    
}
//CFloatLayer* CFloatLayer::create(CCLabelTTF *b)
//{
//    CFloatLayer *pRet = new CFloatLayer();
//    if(pRet && pRet->init(b))
//    {
//        pRet->autorelease();
//        return pRet;
//    }
//    
//    CC_SAFE_DELETE(pRet);
//    return NULL;
//}

//bool CFloatLayer::init(CCLabelTTF* b)
//{
//    if(!CUserControl::init())
//        return false;
//   //m_b = CCLabelTTF::create("bb", "Arail", 10);
//    //this->addChild(m_b);
//    return true;
//}

bool CFloatLayer::init()
{
    return CUserControl::init();
}

void CFloatLayer::show(CCNode *pParent, const cocos2d::CCPoint &pos, enumActionType eActionType)
{
    show(pParent, pos.x, pos.y, eActionType);
}

void CFloatLayer::show(CCNode *pParent, float fx, float fy, enumActionType eActionType)
{
    //getActionType
    setPosition(ccp(fx,fy));
    pParent->addChild(this);
    CCAction *pAction = getActionByType(eActionType);
    if(pAction!=NULL)
        runAction(pAction);
 
}

void CFloatLayer::hide(enumActionType eActionType)
{
    if( eActionType == eAT_None )
    {
        removeFromParentAndCleanup(false);
    }
    else
    {
        CCAction *pAction = getActionByType(eActionType);
        

        CCCallFuncN* callback = CCCallFuncN::create(this, callfuncN_selector( CFloatLayer::actionCallback));
        
        runAction(CCSequence::create((CCActionInterval*)pAction,callback,NULL ));

    }
}

CCAction *CFloatLayer::getActionByType(enumActionType eActionType)
{
    //,eAT_FadeIn         //淡入
   // ,eAT_FadeOut        //淡出

    if( eAT_None == eActionType )
    {
        return NULL;
    }
    else if (eActionType == eAT_FadeIn)
    {

        CCFiniteTimeAction* fadeIn = CCFadeIn::create(5.0f);

        return (CCAction *)fadeIn;
    }
    else if(eActionType == eAT_FadeOut)
    {
        CCFiniteTimeAction* fadeOut = CCFadeOut::create(5.0f);
        return (CCAction*)fadeOut;
    }
    else if(eActionType == eAT_MoveBy_Left)
    {
        CCActionInterval *act = CActionMoveBy::create(0.3f,ccp(-720,0));
        CCFiniteTimeAction* moveBy = CCSequence::create(act,CCCallFunc::create(this, callfunc_selector(CFloatLayer::OpenBookCallBack)),NULL);
        return (CCAction*)moveBy;
    }
    else if(eActionType == eAT_MoveBy_Up)
    {
        CCActionInterval *act = CActionMoveBy::create(0.3f,ccp(0, 150));
        CCFiniteTimeAction* moveBy = CCSequence::create(act,CCCallFunc::create(this, callfunc_selector(CFloatLayer::OpenBookCallBack)),NULL);
        return (CCAction*)moveBy;
    }
    return NULL;
}

void CFloatLayer::OpenBookCallBack()
{
    unscheduleUpdate();
}

void CFloatLayer::actionCallback()
{
    removeFromParentAndCleanup(false);
}

