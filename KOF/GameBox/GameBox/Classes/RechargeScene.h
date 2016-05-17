//
//  RechargeScene.h
//  GameBox
//
//  Created by wrc on 13-8-27.
//
//

#ifndef __GameBox__RechargeScene__
#define __GameBox__RechargeScene__

#include "Constant.h"
#include "cocos2d.h"



using namespace cocos2d;

class CRechargeScene : public CCLayer
{
public:
    static void setRechargeData(const char *lpcszKey, const char *lpcszValue);
    static const char *getRechargeData(const char *lpcszKey);

    static CCScene *create();

    bool init();

};

#endif /* defined(__GameBox__RechargeScene__) */
