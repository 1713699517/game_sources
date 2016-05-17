//
//  CCTouchSet.h
//  GameBox
//
//  Created by Caspar on 2013-6-15.
//
//

#ifndef GameBox_CCTouchSet_h
#define GameBox_CCTouchSet_h

#include "cocos2d.h"
USING_NS_CC;

namespace ptola
{
namespace script
{

    class CCTouchSet : public CCObject
    {
    public:
        CCTouchSet(CCSet *pSet);

        int count();

        CCTouch *anyObject();
        
        CCTouch *at(int nIndex);

    private:
        CCSet *m_pSet;
    };

}
}

#endif
