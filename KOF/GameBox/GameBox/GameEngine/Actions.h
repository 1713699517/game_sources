

#ifndef __GameBox__CActions__
#define __GameBox__CActions__

//#define CC__DLL


#include "cocos2d.h"
#include "cocos-ext.h"

USING_NS_CC;
USING_NS_CC_EXT;

class CActionMoveBy : public CCActionInterval
{
    
public:
    /** initializes the action */
    bool initWithDuration(float duration, const CCPoint& deltaPosition);
    
    virtual CCObject* copyWithZone(CCZone* pZone);
    virtual void startWithTarget(CCNode *pTarget);
    virtual CCActionInterval* reverse(void);
    virtual void update(float t);
    
public:
    /** creates the action */
    static CActionMoveBy* create(float duration, const CCPoint& deltaPosition);
protected:
    CCPoint m_positionDelta;
    CCPoint m_startPosition;
    CCPoint m_previousPosition;

};


#endif
