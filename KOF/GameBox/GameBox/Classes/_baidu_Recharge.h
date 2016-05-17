//
//  _baidu_Recharge.h
//  GameBox
//
//  Created by Mac on 13-12-9.
//
//

#ifndef __GameBox___baidu_Recharge__
#define __GameBox___baidu_Recharge__

#include "Constant.h"


#if (AGENT_SDK_CODE == 12 )

#include "Button.h"
#include "Sprite.h"
#include "EditBox.h"
#include "CCScale9Sprite.h"
#include "RichTextBox.h"

using namespace cocos2d;
using namespace ptola::gui;

class CBaidu_Recharge : public CCNode
{
public:
    CBaidu_Recharge();
    
    CREATE_FUNC(CBaidu_Recharge);
    bool init();
    void loadResources();
    void unloadResources();
    void initParameter();
    void initView();
    
    
    bool shouldOverrideUrl(const char *lpcszUrl);
    
private:
    CButton *createItem(int money);        //创建金额选项
    void setHightLight( CButton *button ); //设置高亮
    
    CCSize pCellSize;            //金额选项 大小
    CSprite *m_pselectBg;        //选中背景圈圈 高亮
    CSprite *m_phightImg;        //选中金额 高亮
    CSprite *m_pselectImg;       //选中圈圈 高亮
    std::set<int>  m_pMoneySet;  //可选金额set集合
    int pMoney;                  //选择的金额
    bool m_pIsFirst;             //是否第一次充值
    bool m_isTouchClose;         //是否点击了关闭按钮
    
    CButton *m_pCloseButton;     //关闭 按钮
    CButton *m_pRechargeBtn;     //确认充值 按钮
    CRichTextBox *m_pNoticText;   //充值提示
    //    CEditBox *m_pEditBox;
    
    
    //关闭回调
    void closeButtononBeganTouch(CCObject *pSender, CEvent *pEvent);
    //选择金额回调
    void selectMoneyBeganTouch(CCObject *pSender, CEvent *pEvent);
    //确认充值回调
    void rechargeButtononBeganTouch(CCObject *pSender, CEvent *pEvent);
    
};
#endif

#endif /* defined(__GameBox___baidu_Recharge__) */
