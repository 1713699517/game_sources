//
//  UpdateLogView.h
//  GameBox
//
//  Created by Caspar on 13-10-22.
//
//

#ifndef __GameBox__UpdateLogView__
#define __GameBox__UpdateLogView__

#include "AWebView.h"
#include "Sprite.h"
#include "Button.h"
#include "Container.h"

USING_NS_CC;
using namespace ptola;
using namespace ptola::gui;

class CGameUpdateScene;

class CUpdateLogView : public CContainer
{
public:
    CUpdateLogView();
//    CREATE_FUNC(CUpdateLogView);
    ~CUpdateLogView();
    
    static CUpdateLogView* create(CGameUpdateScene *updataScene,bool isUpdate);
    
    bool init(CGameUpdateScene *updataScene,bool isUpdate);
    void endUpdata();

private:
    void onUpdateLogLoaded(CCObject *pSender, CEvent *pEvent);
    void onBeganTouchGoInButton(CCObject *pSender, CEvent *pEvent);
    bool m_isUpdate;
    CWebView *m_pWebView;
    CButton *m_pGoInBtn;
    
    CGameUpdateScene *m_updataScene;
};
#endif /* defined(__GameBox__UpdateLogView__) */
