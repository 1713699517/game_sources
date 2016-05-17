//
//  Login.h
//  GameBox
//
//  Created by Mac on 13-12-6.
//
//

#ifndef __GameBox__UC_ANDROID_LOGIN__
#define __GameBox__UC_ANDROID_LOGIN__

#include "cocos2d.h"
#include "Constant.h"
#include "UserCache.h"

#if (AGENT_SDK_CODE == 10)
class UC_Android_Login: public CCLayer
{
public:
    
    CREATE_FUNC(UC_Android_Login);
    
    bool init();
    
    static CCScene *scene();
    
};
#endif

#endif /* defined(__GameBox__Login__) */
