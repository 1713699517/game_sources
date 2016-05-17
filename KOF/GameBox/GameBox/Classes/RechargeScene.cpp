//
//  RechargeScene.cpp
//  GameBox
//
//  Created by wrc on 13-8-27.
//
//

#include "RechargeScene.h"

#include "_553_Recharge.h"
#include "_PP_IOS_Recharge.h"

#include "MI_Recharge.h"
#include "Wdj_Recharge.h"
#include "PP_Recharge.h"
#include "_APP_Recharge.h"
#include "_91_Android_Recharge.h"

#include "_OPPO_Android_Recharge.h"

#include "_360_Android_Recharge.h"
#include "UC_Android_Recharge.h"
#include "_baidu_Recharge.h"



static std::map<std::string, std::string> m_RechargeDatas;

const char *CRechargeScene::getRechargeData(const char *lpcszKey)
{
    std::map<std::string,std::string>::iterator it = m_RechargeDatas.find(lpcszKey);
    if( it == m_RechargeDatas.end() )
        return NULL;
    else
        return it->second.c_str();
}

void CRechargeScene::setRechargeData(const char *lpcszKey, const char *lpcszValue)
{
    m_RechargeDatas[ lpcszKey ] = lpcszValue;
}




CCScene *CRechargeScene::create()
{
    CRechargeScene *pLayer = new CRechargeScene;
    if( pLayer != NULL && pLayer->init() )
    {
        CCScene *pScene = CCScene::create();
        pScene->addChild(pLayer);
        return pScene;
    }
    else
    {
        CC_SAFE_DELETE(pLayer);
        return NULL;
    }
}

bool CRechargeScene::init()
{
    if( !CCLayer::init() )
        return false;
    
#if (AGENT_SDK_CODE == 1)
    C553_Recharge *p553Node = C553_Recharge::create();
    if( p553Node != NULL )
    {
        addChild(p553Node);
        return true;
    }
#elif (AGENT_SDK_CODE == 2)
    C360_Android_Recharge *p360AndroidNode = C360_Android_Recharge::create();
    if( p360AndroidNode != NULL )
    {
        addChild(p360AndroidNode);
        return true;
    }
#elif (AGENT_SDK_CODE == 3)
    CAPP_Recharge *pAppNode = CAPP_Recharge::create();
    if( pAppNode != NULL )
    {
        addChild(pAppNode);
        return true;
    }
#elif (AGENT_SDK_CODE == 4)
    C553_Recharge *p553Node = C553_Recharge::create();
    if( p553Node != NULL )
    {
        addChild(p553Node);
        return true;
    }
#elif (AGENT_SDK_CODE == 5)
    CPP_Recharge *pPPNode = CPP_Recharge::create();
    if( pPPNode != NULL )
    {
        addChild(pPPNode);
        return true;
    }
    //    CPP_IOS_Recharge *pPPNode = CPP_IOS_Recharge::create();
    //    if( pPPNode != NULL )
    //    {
    //        addChild(pPPNode);
    //        return true;
    //    }
#elif (AGENT_SDK_CODE == 7)
    CMI_Recharge *pMiNode = CMI_Recharge::create();
    if( pMiNode != NULL )
    {
        addChild(pMiNode);
        return true;
    }
#elif (AGENT_SDK_CODE == 8)
    COPPO_Recharge *pCOPPONode = COPPO_Recharge::create();
    if( pCOPPONode != NULL )
    {
        addChild(pCOPPONode);
        return true;
    }
#elif (AGENT_SDK_CODE == 9)
    C91Android_Recharge *pMiNode = C91Android_Recharge::create();
    if( pMiNode != NULL )
    {
        addChild(pMiNode);
        return true;
    }
#elif (AGENT_SDK_CODE == 10)
    CUC_Recharge *pMiNode = CUC_Recharge::create();
    if( pMiNode != NULL )
    {
        addChild(pMiNode);
        return true;
    }
#elif (AGENT_SDK_CODE == 12)
    CBaidu_Recharge *pMiNode = CBaidu_Recharge::create();
    if( pMiNode != NULL )
    {
        addChild(pMiNode);
        return true;
    }
#elif (AGENT_SDK_CODE == 13)
    CWdj_Recharge *pWdjNode = CWdj_Recharge::create();
    if( pWdjNode != NULL )
    {
        addChild(pWdjNode);
        return true;
    }
#endif
    CCLOG("SDK Recharge Error!");
    return false;
}
