//
//  _PP_IOS_Recharge.h
//  GameBox
//
//  Created by wrc on 13-10-15.
//
//

#ifndef __GameBox___PP_IOS_Recharge__
#define __GameBox___PP_IOS_Recharge__

#include "Constant.h"



#if (AGENT_SDK_CODE == 5)


#include "cocos2d.h"

USING_NS_CC;

class CPP_IOS_Recharge : public CCNode
{
public:
    
    CREATE_FUNC(CPP_IOS_Recharge);
    bool init();
    
    CC_SYNTHESIZE( int, m_nPrice, Price );
};

#endif

#endif /* defined(__GameBox___PP_IOS_Recharge__) */
