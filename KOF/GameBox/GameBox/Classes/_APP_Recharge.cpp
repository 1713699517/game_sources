//
//  _APP_Recharge.cpp
//  GameBox
//
//  Created by minfei xu on 13-11-25.
//
//

#include "_APP_Recharge.h"
#include <algorithm>

#if (AGENT_SDK_CODE == 3 )

#include "RechargeScene.h"

#include "DateTime.h"
#include "AWebView.h"
#include "HorizontalLayout.h"
#include "Container.h"
#include "MD5Crypto.h"
#include "json.h"

using namespace cocos2d;
using namespace ptola;

extern "C"


CAPP_Recharge::CAPP_Recharge()
:m_phightImg(NULL)
,m_pselectImg(NULL)
,pCellSize(CCSizeMake(180.0, 250.0))
,m_pCloseButton(NULL)
,pMoney(0)
,m_pIsFirst(false)
{
    
}

bool CAPP_Recharge::init()
{
    if( !CCNode::init() )
        return false;
    
    loadResources();
    initParameter();
    initView();
    
    return true;
    
}

void CAPP_Recharge::loadResources()
{
    CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("RechargeResources/RechargeResources.plist");
}

void CAPP_Recharge::unloadResources()
{
    CCSpriteFrameCache::sharedSpriteFrameCache()->removeSpriteFramesFromFile("RechargeResources/RechargeResources.plist");
    CCTextureCache::sharedTextureCache()->removeTextureForKey("RechargeResources/RechargeResources.pvr.ccz");
    
    CCTexture2D *r = CCTextureCache::sharedTextureCache()->textureForKey("taskDialog/taskNpcResources/so_10319.png");
    if(r != NULL)
    {
        CCSpriteFrameCache::sharedSpriteFrameCache()->removeSpriteFramesFromTexture(r);
        CCTextureCache::sharedTextureCache()->removeTexture(r);
        r = NULL;
    }
    
    r = CCTextureCache::sharedTextureCache()->textureForKey("taskDialog/taskNpcResources/so_10316.png");
    if(r != NULL)
    {
        CCSpriteFrameCache::sharedSpriteFrameCache()->removeSpriteFramesFromTexture(r);
        CCTextureCache::sharedTextureCache()->removeTexture(r);
        r = NULL;
    }
    
    r = CCTextureCache::sharedTextureCache()->textureForKey("taskDialog/taskNpcResources/so_10341.png");
    if(r != NULL)
    {
        CCSpriteFrameCache::sharedSpriteFrameCache()->removeSpriteFramesFromTexture(r);
        CCTextureCache::sharedTextureCache()->removeTexture(r);
        r = NULL;
    }
    
//    for (int i=1; i <= m_rechargeInfo.size(); i++) {
//        char str[100];
//        sprintf(str, "RechargeResources/%s.png",m_rechargeInfo[i].pic.c_str());
//        
//        r = CCTextureCache::sharedTextureCache()->textureForKey(str);
//        if(r != NULL)
//        {
//            CCSpriteFrameCache::sharedSpriteFrameCache()->removeSpriteFramesFromTexture(r);
//            CCTextureCache::sharedTextureCache()->removeTexture(r);
//            r = NULL;
//        }
//    }
}

void CAPP_Recharge::initParameter()
{
    CCLOG("qqqqqqqqwwwqwqqqqqqqqqqq   111");
    // CAPP_IOS_IAP::sharedAPP_IOS_IAP()->initialize(this);
}


bool SortByM1( const SProductInfo &v1, const SProductInfo &v2)
{
    return v1.dPrice < v2.dPrice;//升序排列
}

void CAPP_Recharge::onProductInfoCallback()
{
    CCLOG("qqqqqqqqwwwqwqqqqqqqqqqq   222");
    // std::map<std::string, SProductInfo> prodectInfo = CAPP_IOS_IAP::sharedAPP_IOS_IAP()->getProductList();
    // std::map<std::string, SProductInfo>::iterator it = prodectInfo.begin();
    // m_rechargeInfo.clear();
    // for (; it!=prodectInfo.end(); ++it) {
    //     SProductInfo info = it->second;
    //     m_rechargeInfo.push_back(info);
    // }

    // std::sort(m_rechargeInfo.begin(), m_rechargeInfo.end(),SortByM1);
    
    // for (int i=0; i<m_rechargeInfo.size(); i++) {
    //     CCLOG("------>%d  %s      -->%s      name=%s",(int)m_rechargeInfo[i].dPrice,m_rechargeInfo[i].szDescription,m_rechargeInfo[i].szProductID,m_rechargeInfo[i].szProductName);
    // }
    
    // loadMainView();

}

void CAPP_Recharge::onPurchasedProduct(const char *lpcszOrderID,const char *lpcszProductID, void *pData, size_t len)
{
    CCLOG("buy %s", lpcszOrderID);
    if( len > 102400 )
        return;
    CCHttpRequest *pRequest = new CCHttpRequest;
    pRequest->setUrl(AGENT_APPSTORE_SDK_RECHARGE_HOST);
    pRequest->setRequestType(CCHttpRequest::kHttpPost);
    pRequest->setTag(lpcszOrderID);

    bool bSandBox = false;
    char *pEnviroment = strstr((char *)pData, "environment");
    if( pEnviroment != NULL )
    {
        char *pSandBox = strstr( pEnviroment, "Sandbox" );
        bSandBox = pSandBox != NULL && (size_t)(pSandBox - pEnviroment) < 20;
    }
    //environment

    char szPurchaseInfo[4096];
    memset( szPurchaseInfo, 0, sizeof(char) * 4096);
    strncpy(szPurchaseInfo, (char *)pData, len);
//    char *purchaseInfo = strstr((char *)pData, "purchase-info");
//    if( purchaseInfo != NULL )
//    {
//        char *pPurchaseStart = strstr((char *)(purchaseInfo + 16), "\"");
//        if( pPurchaseStart != NULL )
//        {
//            char *pPurchaseEnd = strstr((char *)(pPurchaseStart + 1), "\"");
//            if( pPurchaseEnd != NULL )
//            {
//                strncpy(szPurchaseInfo, pPurchaseStart + 1, (pPurchaseEnd - pPurchaseStart) - 1);
//            }
//        }
//    }

    CDateTime nowTime;
    int nLocalTime          = nowTime.getTotalSeconds();
    char szLocalTime[32];
    sprintf(szLocalTime, "%d", nLocalTime);
    
    char szBuffer[102400];
    char szBuffer2[102400];
    strcpy(szBuffer, "cid=");
    strcat(szBuffer, CID_w_217);

    strcat(szBuffer, "&sid=");
    strcat(szBuffer, CRechargeScene::getRechargeData("serverid"));

    strcat(szBuffer, "&account=");
    strcat(szBuffer, CWebView::urlEncode(CRechargeScene::getRechargeData("username")));

    std::string strUUID = CCUserDefault::sharedUserDefault()->getStringForKey("uuid");
    strcat(szBuffer, "&uuid=");
    strcat(szBuffer, strUUID.c_str());

    strcat(szBuffer, "&uid=");
    strcat(szBuffer, CRechargeScene::getRechargeData("roleid"));

    strcat(szBuffer, "&receipt=");
    strcat(szBuffer, szPurchaseInfo);

    strcat(szBuffer, "&oid=");
    strcat(szBuffer, lpcszOrderID);

    strcat(szBuffer, "&id=");
    strcat(szBuffer, lpcszProductID);

    strcat(szBuffer, "&sandbox=");
    strcat(szBuffer, (bSandBox?"1":"0"));

    strcat(szBuffer, "&time=");
    strcat(szBuffer, szLocalTime);


    strcpy(szBuffer2, szBuffer);
    strcat(szBuffer2, "&sign=");
    strcat(szBuffer2, CMD5Crypto::md5(szBuffer, strlen(szBuffer)));

    pRequest->setRequestData(szBuffer2, strlen(szBuffer2));
    CCLOG("Recharge Data=%s", szBuffer2);
    pRequest->setResponseCallback(this, callfuncND_selector(CAPP_Recharge::onRechargeCallBack));
    CCHttpClient::getInstance()->send(pRequest);
    pRequest->release();
}

void CAPP_Recharge::onRechargeCallBack(CCNode *pNode, void *pData)
{
    CCHttpResponse *pResponse = (CCHttpResponse *)(pData);
    if( pResponse == NULL )
        return;
    CCHttpRequest *pRequest = pResponse->getHttpRequest();
    if( pRequest == NULL )
        return;
    const char *lpcszOrderID = pRequest->getTag();
    
    std::vector<char> *pResponseBuffer = pResponse->getResponseData();
    std::string strBuffer( pResponseBuffer->begin(), pResponseBuffer->end() );

    Json::Value retJson;
    Json::Reader jsonReader;
    if( jsonReader.parse(strBuffer.c_str(), retJson) )
    {
        int nRef = retJson["ref"].asInt();
        if( nRef == 1 )
        {
            CCMessageBox("购买成功", "成功");
        }
        else
        {
            char szBuffer[512];
            sprintf(szBuffer, "购买失败，请联系客服！订单ID:%s", lpcszOrderID);
            CCMessageBox(szBuffer, "失败");
        }
    }
}

void CAPP_Recharge::initView()
{
    string isFirst = CRechargeScene::getRechargeData("isFirst");
    if( isFirst == "TRUE" )
    {
        m_pIsFirst = true;
    }
    
    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    CCSize mainSize    = CCSizeMake( 854.0f, visibleSize.height );
    
    m_mainContainer = CContainer::create();
    m_mainContainer->setControlName("this CMI_Recharge m_mainContainer 111");
    m_mainContainer->setPosition(ccp( visibleSize.width/2-mainSize.width/2, 0 ));
    addChild(m_mainContainer,10);
    
    //背景1
    CSprite *m_bigBackground = CSprite::createWithSpriteFrameName("peneral_background.jpg");
    m_bigBackground->setPosition(ccp(visibleSize.width/2, visibleSize.height/2));
    addChild(m_bigBackground,1);
    
    //背景2
    CSprite *m_background = CSprite::createWithSpriteFrameName("general_first_underframe.png");
    m_background->setPreferredSize(mainSize);
    m_background->setPosition(ccp(mainSize.width/2, mainSize.height/2));
    m_mainContainer->addChild(m_background);
    
    //关闭按钮
    m_pCloseButton = CButton::createWithSpriteFrameName("", "general_close_normal.png");
    m_pCloseButton->setControlName("this CMI_Recharge m_pCloseButton");
    CCSize closeBtnSize = m_pCloseButton->getPreferredSize();
    m_pCloseButton->setPosition(ccp(mainSize.width - closeBtnSize.width / 2,mainSize.height - closeBtnSize.height / 2));
    m_pCloseButton->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Recharge::closeButtononBeganTouch));
    m_mainContainer->addChild(m_pCloseButton);
    
    //3个人物
    CSprite *pRole1 = CSprite::create("taskDialog/taskNpcResources/so_10319.png");
    pRole1->setControlName("this CMI_Recharge pRole1 65");
    pRole1->setPosition(ccp( pRole1->getPreferredSize().width/2.0f - 50.0f, pRole1->getPreferredSize().height/2.0f ));
    m_mainContainer->addChild(pRole1, 10);
    
    CSprite *pRole2 = CSprite::create("taskDialog/taskNpcResources/so_10316.png");
    pRole2->setControlName("this CMI_Recharge pRole2 65");
    pRole2->setPosition(ccp( pRole2->getPreferredSize().width/2.0f - 15.0f, pRole2->getPreferredSize().height/2.0f - 130 ));
    m_mainContainer->addChild(pRole2, 11);
    
    CSprite *pRole3 = CSprite::create("taskDialog/taskNpcResources/so_10341.png");
    pRole3->setControlName("this CMI_Recharge pRole3 65");
    pRole3->setPosition(ccp( pRole3->getPreferredSize().width/2.0f + 45.0f, pRole3->getPreferredSize().height/2.0f - 100 ));
    m_mainContainer->addChild(pRole3, 12);
    
    //标题
    CSprite *pTitle = CSprite::createWithSpriteFrameName("recharge_word_czzx.png");
    pTitle->setControlName("this CMI_Recharge pTitle 65");
    pTitle->setPosition(ccp( mainSize.width/2.0f,mainSize.height-pTitle->getPreferredSize().height/2-5 ));
    m_mainContainer->addChild(pTitle);
    
    
    //-----------------------------
    //     充值主UI
    //-----------------------------
    CCSize centerSize = CCSizeMake(612, 540);
    float  pos_X    = mainSize.width - 15 - centerSize.width;
    int    zOrder   = 13;
    int    fontSize = 27;
    
    //2级背景
    CSprite *pMainBg = CSprite::createWithSpriteFrameName("general_second_underframe.png");
    pMainBg->setControlName("this CMI_Recharge pMainBg 65");
    pMainBg->setPreferredSize(centerSize);
    pMainBg->setPosition(ccp( pos_X+centerSize.width/2.0f, centerSize.height/2.0f + 7 ));
    m_mainContainer->addChild(pMainBg , zOrder-1 );
    
    if( m_pIsFirst )
    {
        //首次充值  充值提示3 :(首次充值送三倍钻石)
        CCLabelTTF *pRechaeTitle3 = CCLabelTTF::create("(首次充值送三倍钻石)", "Arial", fontSize-3);
        pRechaeTitle3->setColor(ccc3(255, 255, 0));
        pRechaeTitle3->setPosition(ccp(pos_X+centerSize.width/2.0f, 563));
        m_mainContainer->addChild(pRechaeTitle3, zOrder);
    }
    
}

void CAPP_Recharge::loadMainView()
{
    if(m_rechargeInfo.size() == 0)
    {
        return;
    }
    
    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    CCSize mainSize    = CCSizeMake( 854.0f, visibleSize.height );
    
    CCSize centerSize = CCSizeMake(612, 540);
    float  pos_X    = mainSize.width - 15 - centerSize.width;
    
    
    /*
     --------------充值金额选择--------------
     */
    CHorizontalLayout *pLayout = CHorizontalLayout::create();
    pLayout->setCellSize( pCellSize );
    pLayout->setCellHorizontalSpace( 16 );
    pLayout->setCellVerticalSpace( 7 );
    pLayout->setVerticalDirection( false);
    pLayout->setHorizontalDirection( true );
    pLayout->setLineNodeSum(3);
    pLayout->setPosition( pos_X + 20.0f, centerSize.height*0.75f );
    m_mainContainer->addChild(pLayout, 14);
    
    
    
    for(int i=0; i<m_rechargeInfo.size(); i++)
    {
        int dPrice = (int)m_rechargeInfo[i].dPrice;
        int demPri = atoi(m_rechargeInfo[i].szProductName);
        string proName = m_rechargeInfo[i].szProductID;
        
        
        CButton *item = createItem(i,dPrice,demPri,proName);
        pLayout->addChild(item);
        
        if(i == 1)
        {
            setHightLight(item);
        }
    }
}

CButton *CAPP_Recharge::createItem(int tag, int dPrice, int demPri, string proName)
{
    CCLOG("createItem----->dPrice=%d,demPri=%d,  proName=%s",dPrice,demPri,proName.c_str());
    int giveDom = demPri - dPrice * 10;
    
    //按钮
    CButton *cellBtn = CButton::createWithSpriteFrameName("","general_underframe_normal.png");
    cellBtn->setControlName("this CAPP_Recharge cellBtn 250");
    cellBtn->setTag(dPrice);
    cellBtn->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Recharge::cellBgButtonBeganTouch));
    cellBtn->setTouchesPriority(-1);
    cellBtn->setPreferredSize(pCellSize);
    
    CSprite *iConBg = CSprite::createWithSpriteFrameName("general_props_frame_normal.png");
    iConBg->setControlName("this CAPP_Recharge iConBg 250");
    
    char imgStr[100];
    sprintf(imgStr, "RechargeResources/%s.png",proName.c_str());
    CSprite *iCon = CSprite::create(imgStr);
    iCon->setControlName("this CAPP_Recharge iConBg 250");
    iConBg->addChild(iCon,-10);
    
    char notic1[100];
    char notic2[100];
    sprintf(notic1, "%d元=%d钻石" ,dPrice,10*dPrice);
    sprintf(notic2, "再送%d钻石" ,giveDom);
    CCLabelTTF *noticLabel1 = CCLabelTTF::create(notic1,"Arial",20);
    CCLabelTTF *noticLabel2 = CCLabelTTF::create(notic2,"Arial",20);
    noticLabel2->setColor(ccc3(255, 255, 0));
    
    CButton *button = CButton::createWithSpriteFrameName("购买","general_button_normal.png");
    button->setControlName("this CAPP_Recharge button 250");
    button->setTag(tag);
    button->setTouchesPriority(-3);
    button->addEventListener("TouchBegan", this, eventhandler_selector(CAPP_Recharge::buyButtonBeganTouch));
    
    CCSize iConBgSize = iConBg->getPreferredSize();
    CCSize buttonSize = button->getPreferredSize();
    
    iConBg->setPosition(ccp(0,pCellSize.height/2-iConBgSize.height/2-18));
    noticLabel1->setPosition(ccp(0,-6));
    noticLabel2->setPosition(ccp(0,-36));
    button->setPosition(ccp(0,-pCellSize.height/2+buttonSize.height/2+12));
    
    cellBtn->addChild(iConBg,10);
    cellBtn->addChild(noticLabel1,10);
    cellBtn->addChild(noticLabel2,10);
    cellBtn->addChild(button,10);
    
    return cellBtn;
    
}

void CAPP_Recharge::setHightLight( CButton *obj )
{
    //设置选中项的背景高亮效果
    if(m_pselectImg != NULL)
    {
        m_pselectImg->removeFromParentAndCleanup(true);
        m_pselectImg=NULL;
    }
    
    m_pselectImg = CSprite::createWithSpriteFrameName("general_underframe_click.png");
    m_pselectImg->setControlName("this CAPP_Recharge::setHightLight m_pselectImg 271");
    m_pselectImg->setPreferredSize(pCellSize);
    
    obj->addChild(m_pselectImg,1);
    
    pMoney = obj->getTag();
}


void CAPP_Recharge::closeButtononBeganTouch(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("Recharge closeButtononBeganTouch-->",pEvent);
    CCDirector::sharedDirector()->popScene();
    unloadResources();
}


void CAPP_Recharge::cellBgButtonBeganTouch(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("Recharge cellBgButtonBeganTouch-->",pEvent);
    
    CButton *obj = (CButton*)pSender;
    
    //设置高亮
    setHightLight( obj );
    
}

void CAPP_Recharge::buyButtonBeganTouch(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CButton *obj = (CButton*)pSender;
    int idx = obj->getTag();
    string productId = m_rechargeInfo[idx].szProductID;
    
    CCLOG("app recharge monry --> %s",productId.c_str());
    
    // CAPP_IOS_IAP::sharedAPP_IOS_IAP()->pay(productId.c_str());
    
}

#endif