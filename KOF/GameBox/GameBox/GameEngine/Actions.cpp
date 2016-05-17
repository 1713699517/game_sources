

#include "Actions.h"

/** creates the action */
CActionMoveBy* CActionMoveBy::create(float duration, const CCPoint& deltaPosition)
{
    CActionMoveBy *pRet = new CActionMoveBy();
    
    if (pRet && pRet->initWithDuration(duration, deltaPosition))
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CC_SAFE_DELETE(pRet);
        return NULL;
    }
    
}


bool CActionMoveBy::initWithDuration(float duration, const CCPoint& deltaPosition)
{
    if (CCActionInterval::initWithDuration(duration))
    {
        m_positionDelta = deltaPosition;
        return true;
    }
    
    return false;
}

CCObject* CActionMoveBy::copyWithZone(CCZone* pZone)
{
    CCZone* pNewZone = NULL;
    CActionMoveBy* pCopy = NULL;
    if(pZone && pZone->m_pCopyObject)
    {
        //in case of being called at sub class
        pCopy = (CActionMoveBy*)(pZone->m_pCopyObject);
    }
    else
    {
        pCopy = new CActionMoveBy();
        pZone = pNewZone = new CCZone(pCopy);
    }
    
    CCActionInterval::copyWithZone(pZone);
    
    pCopy->initWithDuration(m_fDuration, m_positionDelta);
    
    CC_SAFE_DELETE(pNewZone);
    return pCopy;

}

void CActionMoveBy::startWithTarget(CCNode *pTarget)
{
    CCActionInterval::startWithTarget(pTarget);
    m_previousPosition = m_startPosition = pTarget->getPosition();
}

CCActionInterval* CActionMoveBy::reverse(void)
{
    return CActionMoveBy::create(m_fDuration, ccp( -m_positionDelta.x, -m_positionDelta.y));
}

void CActionMoveBy::update(float t)
{
    if (m_pTarget)
    {
#if CC_ENABLE_STACKABLE_ACTIONS
        CCPoint currentPos = m_pTarget->getPosition();
        CCPoint diff = ccpSub(currentPos, m_previousPosition);
        m_startPosition = ccpAdd( m_startPosition, diff);
        CCPoint newPos =  ccpAdd( m_startPosition, ccpMult(m_positionDelta, t) );
        m_pTarget->setPosition(newPos);
        m_previousPosition = newPos;
        
        
#else
        m_pTarget->setPosition(ccpAdd( m_startPosition, ccpMult(m_positionDelta, t)));
#endif // CC_ENABLE_STACKABLE_ACTIONS
    }
}













