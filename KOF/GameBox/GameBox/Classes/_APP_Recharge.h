//
//  _APP_Recharge.h
//  GameBox
//
//  Created by minfei xu on 13-11-25.
//
//

#ifndef __GameBox___APP_Recharge__
#define __GameBox___APP_Recharge__

#include <iostream>
#include "Constant.h"


#if (AGENT_SDK_CODE == 3 )

#include "Button.h"
#include "Sprite.h"
#include "EditBox.h"
#include "CCScale9Sprite.h"
#include "RichTextBox.h"
#include "PageScrollView.h"
#include "_APP_IOS_IAP.h"

using namespace cocos2d;
using namespace ptola::gui;


class CAPP_Recharge : public CCNode, public IAPP_IOS_IAP
{
public:
    CAPP_Recharge();
    
    CREATE_FUNC(CAPP_Recharge);
    bool init();
    void loadResources();
    void unloadResources();
    void initParameter();
    void initView();
    void loadMainView();

    
    virtual void onProductInfoCallback();
    virtual void onPurchasedProduct(const char *lpcszOrderID, const char *lpcszProductID, void *pData, size_t len);
    
    
    bool shouldOverrideUrl(const char *lpcszUrl);
    
private:
    void onRechargeCallBack(CCNode *pNode, void *pData);

    CButton *createItem(int tag, int dPrice, int demPri, string proName);        //创建金额选项
    void setHightLight( CButton *button ); //设置高亮
    
    CContainer *m_mainContainer;
    CCSize pCellSize;            //金额选项 大小
    CSprite *m_phightImg;        //选中金额 高亮
    CSprite *m_pselectImg;       //选中圈圈 高亮
    int pMoney;                  //选择的金额
    bool m_pIsFirst;             //是否第一次充值
    
    CButton *m_pCloseButton;     //关闭 按钮
    CPageScrollView *m_pScrollView;

    vector<SProductInfo> m_rechargeInfo;//存储充值信息
    
    //关闭回调
    void closeButtononBeganTouch(CCObject *pSender, CEvent *pEvent);
    //选择金额回调
    void buyButtonBeganTouch(CCObject *pSender, CEvent *pEvent);
    //高亮回调回调
    void cellBgButtonBeganTouch(CCObject *pSender, CEvent *pEvent);
    
};

#endif


#endif /* defined(__GameBox___APP_Recharge__) */
