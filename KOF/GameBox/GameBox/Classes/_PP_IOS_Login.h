//
//  _PP_IOS_Login.h
//  GameBox
//
//  Created by Caspar on 13-9-27.
//
//

#ifndef __GameBox___PP_IOS_Login__
#define __GameBox___PP_IOS_Login__

#include "Constant.h"

#if(AGENT_SDK_CODE == 5)
#include "cocos2d.h"

USING_NS_CC;

class CPP_IOS_Login : public CCLayer
{
public:
    CREATE_FUNC(CPP_IOS_Login);
    bool init();

    static CCScene *scene();
};

#endif

#endif /* defined(__GameBox___PP_IOS_Login__) */
