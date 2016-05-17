#include "cocos2d.h"

#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#include "LoginVerifyLua.h"

#include "Constant.h"


#if (AGENT_SDK_CODE == 5)
#import <PPAppPlatformKit/PPAppPlatformKit.h>
#endif

void LUA_EXECUTE_COMMAND(int nCommand)
{
    if (nCommand == 5)
    {
#if (AGENT_SDK_CODE == 5)
        [[PPAppPlatformKit sharedInstance] showCenter];
#endif
    }
}
#endif