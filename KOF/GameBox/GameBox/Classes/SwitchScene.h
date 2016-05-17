//
//  SwitchScene.h
//  GameBox
//
//  Created by wrc on 13-8-30.
//
//

#ifndef __GameBox__SwitchScene__
#define __GameBox__SwitchScene__

#include "cocos2d.h"
#include "cocos-ext.h"

USING_NS_CC;
USING_NS_CC_EXT;

class CSwitchScene : public CCLayer
{
public:
    CSwitchScene();
    ~CSwitchScene();

    CREATE_FUNC(CSwitchScene);

    bool init();

    static CCScene *scene();
public:

private:
    void __sdkhandle(CCObject *pObject, CCControlEvent event);
    void __internalhandle(CCObject *pObject, CCControlEvent event);
};

#endif /* defined(__GameBox__SwitchScene__) */
