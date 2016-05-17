//
//  UpdateDelay.cpp
//  GameBox
//
//  Created by minfei xu on 13-12-4.
//
//

#include "UpdateDelay.h"

#include "GameUpdateScene.h"

CUpdateDelay::CUpdateDelay()
{
    
}

CUpdateDelay::~CUpdateDelay()
{
    
}

CUpdateDelay *CUpdateDelay::create()
{
    CUpdateDelay *pRet = new CUpdateDelay;
    if( pRet != NULL && pRet->init() )
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

bool CUpdateDelay::init()
{
    if(!CCNode::init())
    {
        return false;
    }
    
    CCLayer *layer = CCLayer::create();
    addChild(layer);
    
//  delayGoToUpdate();
    
    return true;
}

void CUpdateDelay::delayGoToUpdate()
{
    CCLOG("this------>delayGoToUpdate(CUpdateDelay)");
    scheduleOnce(schedule_selector(CUpdateDelay::goUpdate), 0.5);
}

void CUpdateDelay::goUpdate()
{
    CCLOG("this------>goUpdate(CUpdateDelay)");
    CCDirector *pDirector = CCDirector::sharedDirector();
    int nLevelLimit = CCUserDefault::sharedUserDefault()->getIntegerForKey("LevelResource", 0);
    CCScene *pUpdateScene = CGameUpdateScene::scene(nLevelLimit);
    pDirector->replaceScene(pUpdateScene);
    
    pDirector->setShowBundleVersion(true);
}
