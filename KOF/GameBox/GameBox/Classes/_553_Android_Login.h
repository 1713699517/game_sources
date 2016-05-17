//
//  _553_Android_Login.h
//  GameBox
//
//  Created by Caspar on 13-9-25.
//
//

#ifndef __GameBox___553_Android_Login__
#define __GameBox___553_Android_Login__

#include "cocos2d.h"
#include "Constant.h"

#if (AGENT_SDK_CODE == 4)
USING_NS_CC;

class C553_Android_Login : public CCLayer
{
public:
    CREATE_FUNC(C553_Android_Login);

    bool init();

    static CCScene *scene();
};

#endif

#endif /* defined(__GameBox___553_Android_Login__) */
