//
//  Wdj_Recharge.cpp
//  GameBox
//
//  Created by minfei xu on 13-10-25.
//
//

#include "Wdj_Recharge.h"
#if (AGENT_SDK_CODE == 13 )

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#endif
#include "RechargeScene.h"


#include "HorizontalLayout.h"
#include "Container.h"
#include "LanguageManager.h"
using namespace cocos2d;

extern "C"


CWdj_Recharge::CWdj_Recharge()
:m_phightImg(NULL)
,m_pselectImg(NULL)
,pCellSize(CCSizeMake(135.0, 40.0))
,m_pCloseButton(NULL)
,m_pRechargeBtn(NULL)
,m_pselectBg(NULL)
,pMoney(0)
,m_pIsFirst(false)
,m_isTouchClose(false)
{

}

bool CWdj_Recharge::init()
{
    if( !CCNode::init() )
        return false;
    
    CCLOG("CWdj_Recharge::init()");
    
    loadResources();
    initParameter();
    initView();
    
    return true;

}

void CWdj_Recharge::loadResources()
{
    CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("RechargeResources/RechargeResources.plist");
}

void CWdj_Recharge::unloadResources()
{
    CCSpriteFrameCache::sharedSpriteFrameCache()->removeSpriteFramesFromFile("RechargeResources/RechargeResources.plist");
    CCTextureCache::sharedTextureCache()->removeTextureForKey("RechargeResources/RechargeResources.pvr.ccz");
}

void CWdj_Recharge::initParameter()
{
    //可选金额
    m_pMoneySet.insert(10);
    m_pMoneySet.insert(30);
    m_pMoneySet.insert(50);
    m_pMoneySet.insert(100);
    m_pMoneySet.insert(200);
    m_pMoneySet.insert(500);
    m_pMoneySet.insert(1000);
    m_pMoneySet.insert(2000);
    m_pMoneySet.insert(5000);
}

void CWdj_Recharge::initView()
{
    string isFirst = CRechargeScene::getRechargeData("isFirst");
    if( isFirst == "TRUE" )
    {
        m_pIsFirst = true;
    }
    
    CCSize visibleSize = CCDirector::sharedDirector()->getVisibleSize();
    CCSize mainSize    = CCSizeMake( 854.0f, visibleSize.height );
    
    CContainer *mainContainer = CContainer::create();
    mainContainer->setControlName("this CPP_Recharge mainContainer 111");
    mainContainer->setPosition(ccp( visibleSize.width/2-mainSize.width/2, 0 ));
    addChild(mainContainer,10);
    
    //背景1
    CSprite *m_bigBackground = CSprite::createWithSpriteFrameName("peneral_background.jpg");
    m_bigBackground->setPosition(ccp(visibleSize.width/2, visibleSize.height/2));
    addChild(m_bigBackground,1);
    
    //背景2
    CSprite *m_background = CSprite::createWithSpriteFrameName("general_first_underframe.png");
    m_background->setPreferredSize(mainSize);
    m_background->setPosition(ccp(mainSize.width/2, mainSize.height/2));
    mainContainer->addChild(m_background);
    
    //关闭按钮
    m_pCloseButton = CButton::createWithSpriteFrameName("", "general_close_normal.png");
    m_pCloseButton->setControlName("this CPP_Recharge m_pCloseButton");
    CCSize closeBtnSize = m_pCloseButton->getPreferredSize();
    m_pCloseButton->setPosition(ccp(mainSize.width - closeBtnSize.width / 2,mainSize.height - closeBtnSize.height / 2));
    m_pCloseButton->addEventListener("TouchBegan", this, eventhandler_selector(CWdj_Recharge::closeButtononBeganTouch));
    mainContainer->addChild(m_pCloseButton);
    
    //标题:充值中心
    CSprite *pTitle = CSprite::createWithSpriteFrameName("recharge_word_czzx.png");
    pTitle->setControlName("this CPP_Recharge pTitle 65");
    pTitle->setPosition(ccp( mainSize.width/2.0f,mainSize.height-pTitle->getPreferredSize().height/2-5 ));
    mainContainer->addChild(pTitle);
    
    //公告背景
    CSprite *pGongGao = CSprite::createWithSpriteFrameName("recharge_notice_underframe.png");
    pGongGao->setControlName("this CPP_Recharge pGongGao 65");
    pGongGao->setPosition(ccp( pGongGao->getPreferredSize().width/2.0f, pGongGao->getPreferredSize().height/2.0f ));
    mainContainer->addChild(pGongGao, 10);
    //公告标题
    CSprite *pGongGaoTitle = CSprite::createWithSpriteFrameName("recharge_word_czssbhl.png");
    pGongGaoTitle->setControlName("this CPP_Recharge pGongGaoTitle 65");
    pGongGaoTitle->setPosition(ccp( pGongGao->getPreferredSize().width/2.0f - 7.0f, 515 ));
    mainContainer->addChild(pGongGaoTitle, 11);
    //公告内容
    string rechargeInfo = ptola::configuration::CLanguageManager::sharedLanguageManager()->getString(("RechargeInfo"));
    CCLabelTTF *pRechargeInfo = CCLabelTTF::create(rechargeInfo.c_str(), "Arial", 20);
    pRechargeInfo->setColor(ccc3(255, 255, 255));
    pRechargeInfo->setDimensions(CCSizeMake(240.0f, 0.0f));
    pRechargeInfo->setHorizontalAlignment( kCCTextAlignmentLeft );
    pRechargeInfo->setPosition(ccp( pGongGao->getPreferredSize().width/2.0f, 300 ));
    mainContainer->addChild( pRechargeInfo, 11);
    
    
    
    //-----------------------------
    //     充值主UI
    //-----------------------------
    CCSize centerSize = CCSizeMake(612, 562);
    float  pos_X    = mainSize.width - 15 - centerSize.width;
    int    zOrder   = 6;
    int    fontSize = 27;
    
    //充值选项大背景
    CSprite *pMainBg = CSprite::createWithSpriteFrameName("general_second_underframe.png");
    pMainBg->setControlName("this CPP_Recharge pMainBg 65");
    pMainBg->setPreferredSize(centerSize);
    pMainBg->setPosition(ccp( pos_X+centerSize.width/2.0f, centerSize.height/2.0f + 7 ));
    mainContainer->addChild(pMainBg , zOrder-1 );
    
    //充值提示 :请选择您要充值的金额
    CSprite *pRechaeTitle1 = CSprite::createWithSpriteFrameName("recharge_word_qxz.png");
    pRechaeTitle1->setControlName("this CPP_Recharge pRechaeTitle1 65");
    pRechaeTitle1->setPosition(ccp( pos_X + pRechaeTitle1->getPreferredSize().width/2.0f + 90, 532.0f ));
    mainContainer->addChild(pRechaeTitle1, zOrder );
    
    CCLabelTTF *pRechaeTitle3 = CCLabelTTF::create("(1元 = 10钻石)", "Arial", fontSize-3);
    pRechaeTitle3->setColor(ccc3(255, 255, 0));
    pRechaeTitle3->setAnchorPoint(ccp( 0,0.5 ));
    pRechaeTitle3->setHorizontalAlignment( kCCTextAlignmentLeft );
    pRechaeTitle3->setPosition(ccp( pos_X + pRechaeTitle1->getPreferredSize().width + 100, 532.0f ));
    mainContainer->addChild(pRechaeTitle3, zOrder);
    
    CSprite *pLineImg = CSprite::createWithSpriteFrameName("general_dividing_line.png",CCRectMake(195, 0, 1, 3));
    pLineImg->setControlName("this CPP_Recharge pLineImg 65");
    pLineImg->setPreferredSize(CCSizeMake( 600, 4));
    pLineImg->setPosition(ccp( pos_X+centerSize.width/2.0f, 495 ));
    mainContainer->addChild(pLineImg, zOrder );
    
    //充值提示2 :1000元可以兑换10000钻石
    CSprite *pRechaeTitle2 = CSprite::createWithSpriteFrameName("rechatge_line.png");
    pRechaeTitle2->setControlName("this CPP_Recharge pRechaeTitle2 65");
    pRechaeTitle2->setPreferredSize(CCSizeMake(700, 52));
    pRechaeTitle2->setPosition(ccp( pos_X+pRechaeTitle2->getPreferredSize().width/2.0f+70.0f, 168.0f ));
    mainContainer->addChild(pRechaeTitle2, zOrder );
    
    //    m_pNoticText = CCLabelTTF::create("", "Arial", fontSize);
    //    m_pNoticText->setColor(ccc3(255, 255, 255));
    //    m_pNoticText->setAnchorPoint(ccp( 0,0.5 ));
    //    m_pNoticText->setHorizontalAlignment( kCCTextAlignmentLeft );
    //    m_pNoticText->setPosition(ccp( pos_X + 60, 185 ));
    //    mainContainer->addChild( m_pNoticText, zOrder);
    
    ccColor4B bgColor = ccc4(0.0f, 0.0f, 0.0f, 0.0f);
    m_pNoticText = CRichTextBox::create( pRechaeTitle2->getPreferredSize(), bgColor ) ;
	m_pNoticText->retain();
    m_pNoticText->setPosition(ccp( pos_X + 75.0f, 185.0f ));
	mainContainer->addChild( m_pNoticText, zOrder );
    
    //    if( m_pIsFirst )
    //    {
    //        //首次充值  充值提示3 :(首次充值送三倍钻石)
    //        CCLabelTTF *pRechaeTitle3 = CCLabelTTF::create("(首次充值送三倍钻石)", "Arial", fontSize-3);
    //        pRechaeTitle3->setColor(ccc3(50, 50, 255));
    //        pRechaeTitle3->setAnchorPoint(ccp( 0,0.5 ));
    //        pRechaeTitle3->setHorizontalAlignment( kCCTextAlignmentLeft );
    //        pRechaeTitle3->setPosition(ccp(pos_X + 120, 115));
    //        mainContainer->addChild(pRechaeTitle3, zOrder);
    //    }
    
    
    //充值按钮
    m_pRechargeBtn = CButton::createWithSpriteFrameName("确定充值", "general_button_normal.png");
    m_pRechargeBtn->setControlName("this CPP_Recharge m_pRechargeBtn");
    CCSize rechargeBtnSize = m_pRechargeBtn->getPreferredSize();
    m_pRechargeBtn->setPosition(ccp( pos_X+490,108));
    m_pRechargeBtn->addEventListener("TouchBegan", this, eventhandler_selector(CWdj_Recharge::rechargeButtononBeganTouch));
    mainContainer->addChild(m_pRechargeBtn,zOrder);
    
    /*
     --------------充值金额选择--------------
     */
    CHorizontalLayout *pLayout = CHorizontalLayout::create();
    pLayout->setCellSize( pCellSize );
    pLayout->setCellHorizontalSpace( 47 );
    pLayout->setCellVerticalSpace( 50 );
    pLayout->setVerticalDirection( false);
    pLayout->setHorizontalDirection( true );
    pLayout->setLineNodeSum(3);
    pLayout->setPosition( pos_X+77, 430 );
    mainContainer->addChild( pLayout, zOrder + 10 );
    
    //添加金额选项
    std::set<int>::const_iterator b=m_pMoneySet.begin();
    for(; b!=m_pMoneySet.end(); ++b)
    {
        CButton *item = createItem(*b);
        pLayout->addChild(item);
        
        if(b == m_pMoneySet.begin())
        {
            setHightLight(item);
        }
    }
    
    
}

CButton *CWdj_Recharge::createItem( int money )
{
    char str_money[100];
    sprintf(str_money, "%d 元",money);
    
    //按钮
    CButton *button = CButton::createWithSpriteFrameName("","recharge_derframe.png");
    button->setControlName("this CPP_Recharge button 250");
    button->setPreferredSize( pCellSize );
    button->setTag(money);
    button->addEventListener("TouchBegan", this, eventhandler_selector(CWdj_Recharge::selectMoneyBeganTouch));
    
    //背景圈圈
    CSprite *rideoBg = CSprite::createWithSpriteFrameName("recharge_underframe_nomal.png");
    rideoBg->setControlName("this CPP_Recharge createItem rideo 194");
    rideoBg->setPosition(ccp( pCellSize.width/2.0f - rideoBg->getPreferredSize().width/2.0f + 20.0f, 0 ));
    button->addChild(rideoBg,-10,998);
    
    //金额
    CCLabelTTF *moneyLabel = CCLabelTTF::create(str_money,"Arial",20);
    moneyLabel->setAnchorPoint(ccp( 0,0.5 ));
    moneyLabel->setPosition(ccp( -25, 0 ));
    button->addChild(moneyLabel,20);
    
    //选择圈圈
    CSprite *rideo = CSprite::createWithSpriteFrameName("general_pages_normal.png");
    rideo->setControlName("this CPP_Recharge createItem rideo 194");
    rideo->setPosition(ccp( -pCellSize.width/2.0f + rideo->getPreferredSize().width/2.0f, 0 ));
    
    button->addChild(rideo,10,999);
    
    return button;
    
}

void CWdj_Recharge::setHightLight( CButton *obj )
{
    //设置选中项的背景高亮效果
    if( m_phightImg != NULL )
    {
        m_phightImg->removeFromParentAndCleanup( true );
        m_phightImg = NULL;
    }
    
    m_phightImg = CSprite::createWithSpriteFrameName("recharge_underframe.png", CCRectMake(62, 0, 1, 34));
    m_phightImg->setPreferredSize(CCSizeMake(pCellSize.width+20.0f, pCellSize.height));
    obj->addChild( m_phightImg, 10);
    
    if(m_pselectBg != NULL)
    {
        m_pselectBg->setImageWithSpriteFrameName("recharge_underframe_nomal.png");
    }
    m_pselectBg = (CSprite*)obj->getChildByTag(998);
    if(m_pselectBg != NULL)
    {
        m_pselectBg->setImageWithSpriteFrameName("recharge_underframe_click.png");
    }
    
    //设置选中的圈圈的 高亮效果
    if( m_pselectImg != NULL )
    {
        m_pselectImg->removeFromParentAndCleanup( true );
        m_pselectImg = NULL;
    }
    
    CSprite *img = (CSprite*)obj->getChildByTag( 999 );
    m_pselectImg = CSprite::createWithSpriteFrameName("general_pages_pressing.png");
    img->addChild(m_pselectImg, 1);
    
    //保存选择金额
    pMoney = obj->getTag();
    
    int price = 10;
    if(m_pIsFirst)
    {
        //首充 三倍钻石
        price = price*3;
    }
    
    int fontSize = 27;
    char money_str[50];
    char zS_str[50];
    ccColor4B whiteColor = ccc4(255.0f, 255.0f, 255.0f, 255.0f);
    ccColor4B goldColor  = ccc4(255.0f, 255.0f, 0.0f, 255.0f);
    
    sprintf(money_str, "%d",pMoney);
    sprintf(zS_str, "%d",pMoney*price);
    
    m_pNoticText->clearAll();
    m_pNoticText->setCurrentStyle("Arial", fontSize, goldColor);
	m_pNoticText->appendRichText(money_str);
    
    m_pNoticText->setCurrentStyle("Arial", fontSize, whiteColor);
	m_pNoticText->appendRichText("元可以兑换");
    
    m_pNoticText->setCurrentStyle("Arial", fontSize, goldColor);
	m_pNoticText->appendRichText(zS_str);
    
    m_pNoticText->setCurrentStyle("Arial", fontSize, whiteColor);
	m_pNoticText->appendRichText("钻石");

    
}

void CWdj_Recharge::selectMoneyBeganTouch(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    
    CButton *obj = (CButton*)pSender;
    
    CCLOG("selectMoneyBeganTouch---->>> %d",obj->getTag());
    
    //设置高亮
    setHightLight( obj );
}

void CWdj_Recharge::closeButtononBeganTouch(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("Recharge closeButtononBeganTouch-->",pEvent);
    if(!m_isTouchClose)
    {
        CCDirector::sharedDirector()->popScene();
        unloadResources();
        m_isTouchClose = true;
    }
}


void CWdj_Recharge::rechargeButtononBeganTouch(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("Recharge rechargeButtononBeganTouch-->",pEvent);
    
//    string _money_str = m_pEditBox->getTextString();   //atoi(_money_str.c_str());
    int _money = pMoney;  //选择的金额
    CCLOG("_money=%d",_money);
    
    if(_money == 0 )
    {
        return;
    }
    
    //小米充值接口调用
    const char *serverid = CRechargeScene::getRechargeData("serverid");
    const char *roleid   = CRechargeScene::getRechargeData("roleid");
    char cpInfo[256];
    strcpy(cpInfo, roleid);
    strcat(cpInfo, "-");
    strcat(cpInfo, serverid);
    strcat(cpInfo, "-");
    
    char payid[256] = {0};
    sprintf(payid, "%s%d", roleid, time(NULL));
    strcat(cpInfo, payid);
    
    JniMethodInfo minfo;//定义Jni函数信息结构体 
    if ( JniHelper::getStaticMethodInfo(minfo,"com/haowan123/kof/wdj/GameBox", "recharge","(ILjava/lang/String;)V") )
    {
        jint money      = _money;
        jstring _cpInfo = minfo.env->NewStringUTF( cpInfo );
        //调用此函数
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID,money,_cpInfo);
        
    }
    else
    {
        CCLOG("CWdj_Recharge::getNetworkStatus method missed!");
    }
    
     
    
//    CCDirector::sharedDirector()->popScene();
    
    //调用
}

#endif