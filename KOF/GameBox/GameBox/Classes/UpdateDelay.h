//
//  UpdateDelay.h
//  GameBox
//
//  Created by minfei xu on 13-12-4.
//
//

#ifndef __GameBox__UpdateDelay__
#define __GameBox__UpdateDelay__

#include <iostream>

#include "cocos2d.h"
#include "cocos-ext.h"

USING_NS_CC;
USING_NS_CC_EXT;

class CUpdateDelay : public CCNode
{
public:
    CUpdateDelay();
    ~CUpdateDelay();
//    CREATE_FUNC(CUpdateDelay);
    static CUpdateDelay *create();
    
    bool init();
    
    void goUpdate();
    void delayGoToUpdate();
    
private:
};

#endif /* defined(__GameBox__UpdateDelay__) */
