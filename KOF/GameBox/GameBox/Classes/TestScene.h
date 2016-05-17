//
//  TestScene.h
//  GameBox
//
//  Created by Caspar on 13-4-24.
//
//

#ifndef __GameBox__TestScene__
#define __GameBox__TestScene__

#include "cocos2d.h"
#include "Event.h"
#include "MovieClip.h"
#include "PageScrollView.h"

USING_NS_CC;
using namespace ptola::gui;

class TestScene : public CCLayer
{
public:
    CREATE_FUNC(TestScene);
    bool init();

    static CCScene *scene();

    virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
    
protected:
    CPageScrollView *m_pScrollView;


    CMovieClip *pmc;


    CCLabelTTF *pLabel;
    CCLabelTTF *pLabelX;

    void onTouchTest(CCObject *pSender, ptola::event::CEvent *pEvent);
    void onTouchTest2(CCObject *pSender, ptola::event::CEvent *pEvent);
};

#endif /* defined(__GameBox__TestScene__) */
