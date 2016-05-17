//
//  TestScene.cpp
//  GameBox
//
//  Created by Caspar on 13-4-24.
//
//

#include "TestScene.h"
#include "PathResolver.h"
#include "Device.h"
#include "Application.h"
#include "FileStream.h"
#include "MemoryStream.h"
#include "Sprite.h"
#include "MovieClip.h"
#include "Button.h"
#include "TcpClient.h"
#include "PageScrollView.h"
#include "Joystick.h"
#include "RichTextBox.h"
#include "Tab.h"
#include "SpriteRGBA.h"
#include "LabelColor.h"
#include "MemoryManager.h"

using namespace ptola;
using namespace ptola::io;
using namespace ptola::gui;
using namespace ptola::network;
using namespace ptola::input;
using namespace ptola::memory;

bool TestScene::init()
{
    if( !CCLayer::init() )
        return false;
//    CFileStream fs("a.txt","r+b");
//
//    CMemoryStream stream(32);
//    CCLOG("%d %d", stream.getLength(), stream.getPosition());
//    int n = 100;
//    stream.write((char *)&n, 0, sizeof(int));
//    CCLOG("%d %d", stream.getLength(), stream.getPosition());
//    stream.seek(0, eSO_Begin);
//    int m = 0;
//    stream.read((char *)&m, 0, sizeof(int));
//
//    CCLOG("r = %d", m);
//
//    CMemoryStream s2 = stream;
//    n = 120;
//    s2.write((char *)&n, 0, sizeof(int));
//    
//
//    CApplication *pApp = CApplication::sharedApplication();
//    char szString[512] = {0};
//
//    sprintf( szString, "%s" , pApp->getResourcePath());
//
//    pLabelX = NULL;
//
//    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
//    pLabel = CCLabelTTF::create("测试中文", "Arial", 30.0f);
//    pLabel->setColor(ccc3(255,255,0));
//    pLabel->setPosition(ccp(winSize.width/2, winSize.height/2));
//    addChild(pLabel);
//
//    setTouchMode(kCCTouchesOneByOne);
//    setTouchEnabled(true);
//
//    CSprite *pSprite = CSprite::create("bbutton.png");
//    pSprite->setPosition(ccp(100,100));
//    pSprite->setTouchesEnabled(true);
//    addChild(pSprite);
//
//    CSprite *pSprite2 = CSprite::create("bbutton.png");
//    pSprite2->setPosition(ccp(200,200));
//    pSprite2->setTouchesEnabled(true);
//    addChild(pSprite2);
//
//    pmc = CMovieClip::create("role01.ccbi", NULL);
//    pmc->setPosition(ccp(100,230));
//    addChild(pmc);

//    CDevice *pDevice = CDevice::sharedDevice();
//    CCLOG("networktype = %d", pDevice->getNetworkStatus() );
//    CCSize s = pmc->getContentSize();
//    CCLOG("%.2f, %.2f ffffff",s.width, s.height);


//    CButton *pBtn = CButton::create("my label", "bbutton.png","checked","Icon-Small-50.png");
//    pBtn->setPosition(ccp(100,330));
//    pBtn->registerNetworkMessageScriptHandler(1);
//    pBtn->addEventListener("TouchBegan", this, eventhandler_selector(TestScene::onTouchTest));
//    addChild(pBtn);
//
//    CButton *pSnd = CButton::create("smg", "bbutton.png");
//    pSnd->setPosition(ccp(230,330));
//    //pSnd->registerNetworkMessageScriptHandler(2);
//    pSnd->addEventListener("TouchBegan", this, eventhandler_selector(TestScene::onTouchTest2));
//    addChild(pSnd);
    
//    CCLayer *tempLayer =CCLayer::create();
//    CCSprite *tempS ;
//    for(int i=0;i<2;i++)
//    {
//        tempS=CCSprite::create("HelloWorld.png");
//        tempS->setAnchorPoint(ccp(0,0));
//        //        tempS->setPosition(ccp(0,tempS->getContentSize().height*i));
//        tempS->setPosition(ccp(tempS->getContentSize().width*i,0));
//        tempLayer->addChild(tempS);
//        char tempstr[200] ;
//        sprintf(tempstr,"%d", i);
//        CCLabelTTF *label = CCLabelTTF::create(tempstr, "Helvetica", 20.0);
//        label->setPosition(CCPointZero);
//        label->setAnchorPoint(CCPointZero);
//        label->setTag(123);
//        tempS->addChild(label);
//    }
//    
//    CPageScrollView* m_pScrollView = CPageScrollView::create();
//    m_pScrollView->setPosition(220, 200);
//    m_pScrollView->setViewSize(tempS->getContentSize());
//    m_pScrollView->setContainer(tempLayer);
//    m_pScrollView->setDirection(kCCScrollViewDirectionHorizontal);
//    m_pScrollView->SetContainerPageAndSize(2, m_pScrollView->getViewSize());
//    m_pScrollView->SetPage(1);
//    this->addChild(m_pScrollView, 2);


//    CJoyStick *pStick = CJoyStick::create("joyStick_Background.png", "joyStick_Stick.png");
//    pStick->setFireMode(eJSTM_HalfScreenTouchPoint);
//    pStick->setMaxRadius(60.0f);
//    pStick->setAutoHide(false);
//    pStick->setFireInterval(0.3f);
//    pStick->setFirePosition(ccp(150.f,150.f));
//    addChild(pStick);

//    CCSize vis = CCDirector::sharedDirector()->getVisibleSize();
//    CCSize _size = CCSizeMake(320, 480);
//    CPageScrollView *pPageScrollView = CPageScrollView::create(eLD_Horizontal, _size);
//    pPageScrollView->setPosition(ccp(vis.width / 2, 30));
//    addChild(pPageScrollView);
//
//    CContainer *pContainer1 = CContainer::create();
//    CCSprite *pSprite = CCSprite::create("Default.png");
//    pContainer1->addChild(pSprite);
//
//    CContainer *pContainer2 = CContainer::create();
//    CCSprite *pSprite2 = CCSprite::create("Default.png");
//    pContainer2->addChild(pSprite2);
//    
//    CContainer *pContainer3 = CContainer::create();
//    CCSprite *pSprite3 = CCSprite::create("Default.png");
//    pContainer3->addChild(pSprite3);
//
//    pPageScrollView->addPage(pContainer1);
//    pPageScrollView->addPage(pContainer2);
//    pPageScrollView->addPage(pContainer3);
//
//
//    pPageScrollView->setPage(1, false);


//    ccColor4B c4 = ccc4(255,255,255,255);
//    CRichTextBox *pBox = CRichTextBox::create(CCSizeMake(400, 60), c4);
//    pBox->setPosition(ccp(0,60));
//    addChild(pBox);




    
//    CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("General.plist");
//


    
//    CTabPage *pPage1 = CTabPage::createWithSpriteFrameName("label1", "general_pages_normal.png");
//    CContainer *pContainer1 = CContainer::create();
//    CCLabelTTF *pLabel1 = CCLabelTTF::create("Label 1", "Arial", 30.0f);
//    pContainer1->addChild(pLabel1);
//
//
//    CTabPage *pPage2 = CTabPage::createWithSpriteFrameName("label2", "general_pages_normal.png");
//    CContainer *pContainer2 = CContainer::create();
//    CCLabelTTF *pLabel2 = CCLabelTTF::create("Label 2", "Arial", 30.0f);
//    pContainer2->addChild(pLabel2);
//
//    CTab *pTab = CTab::create(eLD_Horizontal, CCSizeMake(50, 60));
//    pTab->setPosition(200,200);
//    addChild(pTab);
//
//    pTab->addTab(pPage1, pContainer1);
//    pTab->addTab(pPage2, pContainer2);

//    CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("General.plist");
//    CSpriteRGBA *pSpriteRGBA = CSpriteRGBA::createWithSpriteFrameName("general_four_button_normal.png");
//    //pSpriteRGBA->shaderDotColor(0.299f, 0.587f, 0.114f, 1.0f);
//    pSpriteRGBA->shaderMulColor(0.5f, 0.5f, 0.5f, 1.0f);
//
//    pSpriteRGBA->setPosition(ccp(300,300));
//    addChild(pSpriteRGBA);

    
//    CLabelColor *pLabel = CLabelColor::create();
//
//    char szAAA[512] = {0};
//
//    CTcpClient *pClient = CTcpClient::sharedTcpClient();
//    sprintf(szAAA, "<color:0,255,0,255> %ld", sizeof(pClient) );
//    pLabel->appendText(szAAA, "Arial", 20.0f);
//
////    pLabel->appendText("卢饼干", ccc4(255,0,0,255), "Arial", 20.0f);
////    pLabel->appendText("是个", ccc4(255,255,255,255), "Arial", 20.0f);
////    pLabel->appendText("混蛋", ccc4(255,255,0,255), "Arial", 20.0f);
//    addChild(pLabel);
//    pLabel->setPosition(ccp(200,200));

//    CHorizontalLayout *ply = CHorizontalLayout::create();
//    ply->setCellSize(CCSizeMake(100, 80));
////    ply->setColumnNodeSum(3);
//    ply->setHorizontalDirection(false);
//    ply->setLineNodeSum(3);
//    addChild(ply);
//    ply->setPosition(ccp(600, 200));
//
//    for( int i = 0 ; i < 7 ; i++ )
//    {
//        CSprite *pSp = CSprite::create("orange_edit.png");
//        ply->addChild(pSp);
//    }

    unsigned int aaa = CMemoryManager::sharedMemoryManager()->getTotalMemory();
    unsigned int bbb = CMemoryManager::sharedMemoryManager()->getFreeMemory();
    unsigned int ccc = CMemoryManager::sharedMemoryManager()->getUsedMemory();
    CCLOG("mmm %ud ,%ud ,%ud", aaa, bbb, ccc);
    return true;
}

void TestScene::onTouchTest(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CCLOG("teawtewqtwet");
    IPAddress addr;
    addr.SetHostName("192.168.1.156", false);
    CTcpClient::sharedTcpClient()->connect(addr, 8442);
    CCLOG("saaaaalalalal");
}

void TestScene::onTouchTest2(cocos2d::CCObject *pSender, ptola::event::CEvent *pEvent)
{
    CReqMessage req;
    SReqHeader *pReqHeader = req.getHeader();
    pReqHeader->uMsgId = 501;

    CDataWriter writer( req.getStreamData() );
    req.serialize(&writer);
    writer.writeInt8(9);
    writer.writeInt16(123);
    writer.writeInt32(1010101);
    writer.writeString("刘韬");
    writer.writeUTF("很操蛋,很蛋疼");
    pReqHeader->uLength = writer.getPosition();
    CTcpClient::sharedTcpClient()->send(&req);
    CCLOG("fff");
}

CCScene *TestScene::scene()
{
    CCScene *pRet = CCScene::create();
    if( pRet != NULL && pRet->init() )
    {
        TestScene *pTest = TestScene::create();
        if( pTest != NULL )
        {
            pRet->addChild(pTest);
        }
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CC_SAFE_DELETE(pRet);
        return NULL;
    }
}


bool TestScene::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
    static int i = 0;
    i++;
    if( i % 3 == 0 )
        pmc->play("attack");
    else if( i % 3 == 1 )
        pmc->play("mobile");
    else
        pmc->play("stand");
//    CDevice *pDevice = CDevice::sharedDevice();
//    CCSize screenSize = pDevice->getScreenSize();
//    
//    char szString[512] = {0};
//    sprintf( szString, "fnw %d / %.2f : %.2f\nerr=%s", pDevice->getDeviceOrientation(), screenSize.width, screenSize.height, pDevice->getDeviceIMEI() );
//    pLabel->setString(szString);
//
//    if( pLabelX == NULL )
//    {
//        pLabelX = CCLabelTTF::create("OKOK", "Arial", 20.0f);
//        pLabelX->setPosition(ccp(100,100));
//        addChild(pLabelX);
//    }
//    if( pDevice->getDeviceOrientationIsLandscape() )
//        pDevice->setDeviceOrientation(Portrait);
//    else
//        pDevice->setDeviceOrientation(LandscapeLeft);
    return false;
}
