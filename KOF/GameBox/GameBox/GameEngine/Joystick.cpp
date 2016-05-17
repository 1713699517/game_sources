//
//  Joystick.cpp
//  GameBox
//
//  Created by Caspar on 2013-6-7.
//
//

#include "Joystick.h"
#include "PMath.h"
#include "ptola.h"
#include "LuaScriptFunctionInvoker.h"
#include <math.h>

#define JOY_STICK

using namespace ptola::math;
using namespace ptola::input;

CJoyStick::CJoyStick()
: m_fFireInterval(0.5f)
, m_fMaxRadius(128.0f)
, m_fMaxDisplayRadius(128.0f)
, m_bAutoHide(true)
, m_exTouchMode(eJSTM_HalfScreenTouchPoint)
, m_cpFirePosition(CCPointZero)
, m_pBackground(NULL)
, m_pStick(NULL)
, m_highLightLastIndex(-1)
, m_nTouchId(-1)
{
    memset( m_pLightupDirection, 0, sizeof(CSprite *) * JOYSTICK_DIRECTION_COUNT);
    CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile(JOYSTICK_PLIST_FILE);
}

CJoyStick::~CJoyStick()
{
    CC_SAFE_RELEASE(m_pBackground);
    CC_SAFE_RELEASE(m_pStick);
}

CJoyStick *CJoyStick::create(const char *lpcszBackground, const char *lpcszStick, const char *lpcszCirclePeace)
{
    CJoyStick *pRet = new CJoyStick;
    if( pRet != NULL && pRet->init(lpcszBackground, lpcszStick, lpcszCirclePeace) )
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

bool CJoyStick::init(const char *lpcszBackground, const char *lpcszStick, const char *lpcszCirclePeace)
{
    CSprite *pBackground = CSprite::createWithSpriteFrameName(lpcszBackground);
    CSprite *pStick = CSprite::createWithSpriteFrameName(lpcszStick);
    return init( pBackground, pStick , lpcszCirclePeace);
}

CJoyStick *CJoyStick::create(CSprite *pBackground, CSprite *pStick, const char *lpcszCirclePeace)
{
    CJoyStick *pRet = new CJoyStick;
    if( pRet != NULL && pRet->init(pBackground, pStick, lpcszCirclePeace) )
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

bool CJoyStick::init(CSprite *pBackground, CSprite *pStick, const char *lpcszCirclePeace)
{
    if( CUserControl::getInitialized() )
        return onInitialized(false);
    if( !CUserControl::init() )
        return onInitialized(false);

    m_pBackground = pBackground;
    CC_SAFE_RETAIN(m_pBackground);
    addChild(m_pBackground);

    float fEveryAngle = 360.0f / (float)(JOYSTICK_DIRECTION_COUNT);
    for(int i = 0 ; i < JOYSTICK_DIRECTION_COUNT ; i++)
    {
        CSprite *pPeace = CSprite::createWithSpriteFrameName(lpcszCirclePeace);
        pPeace->setAnchorPoint(ccp(0.0f, 0.5f));
        pPeace->setRotation(fEveryAngle * (float)i);
        addChild(pPeace);
        m_pLightupDirection[i] = pPeace;
    }


    m_pStick = pStick;
    CC_SAFE_RETAIN(m_pStick);
    addChild(m_pStick);

    setTouchesMode(kCCTouchesAllAtOnce);
    setTouchesPriority(kCCMenuHandlerPriority);
    setTouchesEnabled(true);
    return onInitialized(true);
}

void CJoyStick::setFireInterval(float _fireInterval)
{
    m_fFireInterval = _fireInterval;
}

float CJoyStick::getFireInterval()
{
    return m_fFireInterval;
}

void CJoyStick::setMaxRadius(float _maxRadius)
{
    m_fMaxRadius = _maxRadius;
}

float CJoyStick::getMaxRadius()
{
    return m_fMaxRadius;
}

void CJoyStick::setMaxStickRadius(float _maxRadius)
{
    m_fMaxDisplayRadius = _maxRadius;
}

float CJoyStick::getMaxStickRadius()
{
    return m_fMaxDisplayRadius;
}

void CJoyStick::setAutoHide(bool _bAutoHide)
{
    m_bAutoHide = _bAutoHide;
}

bool CJoyStick::getAutoHide()
{
    return m_bAutoHide;
}

enumJoyStickTouchMode CJoyStick::getFireMode()
{
    return m_exTouchMode;
}

void CJoyStick::setFireMode(enumJoyStickTouchMode eValue)
{
    m_exTouchMode = eValue;
}

void CJoyStick::setFirePosition(const CCPoint &pos)
{
    m_cpFirePosition = pos;
    if( m_pBackground != NULL )
        m_pBackground->setPosition(pos);
    if( m_pStick != NULL )
        m_pStick->setPosition(pos);

    float fEveryAngle = 360.0f / (float)(JOYSTICK_DIRECTION_COUNT);
    for( int i = 0 ; i < JOYSTICK_DIRECTION_COUNT ; i++ )
    {
        if(m_pLightupDirection[i] == NULL)
            continue;

        float fAngle = fEveryAngle * (float)i;
        if( fAngle >= 0.0f && fAngle < 180.0f )
        {
            fAngle = 180.0f - fAngle;
        }
        else
        {
            fAngle = -fAngle + 180;
        }
        float fRadian = CMath::angleToRadian(fAngle);
        CCPoint nPos = ccp( pos.x - 57 * cosf( fRadian ), pos.y - 57 * sinf( fRadian ) );
        m_pLightupDirection[i]->setPosition(nPos);
    }
}

const CCPoint &CJoyStick::getFirePosition()
{
    return m_cpFirePosition;
}

void CJoyStick::onEnter()
{
    if( m_bAutoHide )
    {
        if( m_pBackground )
        {
            m_pBackground->removeFromParentAndCleanup(false);
        }
        if( m_pStick )
        {
            m_pStick->removeFromParentAndCleanup(false);
        }
    }
    else
    {
        m_pBackground->setPosition(m_cpFirePosition);
        m_pStick->setPosition(m_cpFirePosition);

        float fEveryAngle = 360.0f / (float)(JOYSTICK_DIRECTION_COUNT);
        for( int i = 0 ; i < JOYSTICK_DIRECTION_COUNT ; i++ )
        {
            if(m_pLightupDirection[i] == NULL)
                continue;

            float fAngle = fEveryAngle * (float)i;
            if( fAngle >= 0.0f && fAngle < 180.0f )
            {
                fAngle = 180.0f - fAngle;
            }
            else
            {
                fAngle = -fAngle + 180;
            }
            float fRadian = CMath::angleToRadian(fAngle);

            CCPoint nPos = ccp( m_cpFirePosition.x - 57 * cosf( fRadian ), m_cpFirePosition.y - 57 * sinf( fRadian ) );
            m_pLightupDirection[i]->setPosition(nPos);
        }
    }
    CUserControl::onEnter();
}


void CJoyStick::ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent)
{
    if( m_nTouchId != -1 )
        return;
    if( m_exTouchMode == eJSTM_Fixed )
    {
        for(CCSetIterator it = pTouches->begin();
            it != pTouches->end() ; it++ )
        {
            CCTouch *pTouch = (CCTouch *)*it;
            float fTouchDistance = ccpDistance(pTouch->getLocation(), m_cpFirePosition);
            if(m_fMaxRadius >= fTouchDistance)
            {
                m_nTouchId = pTouch->getID();
                schedule(schedule_selector(CJoyStick::fireCallback), m_fFireInterval);
                if( m_bAutoHide )
                {
                    addChild(m_pBackground);
                    addChild(m_pStick);
                }
                if( m_pStick != NULL )
                {
                    if (m_fMaxDisplayRadius >= fTouchDistance)
                    {
                        m_pStick->setPosition(pTouch->getLocation());
                    }
                    else
                    {
                        float _fAngle = CMath::pointsToAngle(pTouch->getLocation(), m_cpFirePosition);
                        //angle
                        float _fRadian = CMath::angleToRadian( _fAngle );
                        //
                        m_pStick->setPosition(ccp(
                                                  m_cpFirePosition.x - m_fMaxDisplayRadius * cosf(_fRadian),
                                                  m_cpFirePosition.y - m_fMaxDisplayRadius * sinf(_fRadian)
                                                  ));
                    }
                }
                fireCallback(0.0f);
                return;
            }
        }
        m_nTouchId = -1;
    }
    else if( m_exTouchMode == eJSTM_HalfScreenTouchPoint )
    {
        if( m_nTouchId >= 0 )
            return;
        for( CCSetIterator it = pTouches->begin();
            it != pTouches->end(); it++ )
        {
            CCTouch *pTouch = (CCTouch *)*it;
            CCPoint touchPoint = pTouch->getLocation();
            //half screen
            if( touchPoint.x < CCDirector::sharedDirector()->getWinSize().width / 2.0f )
            {
                m_nTouchId = pTouch->getID();
                schedule(schedule_selector(CJoyStick::fireCallback), m_fFireInterval);
                if( m_bAutoHide )
                {
                    addChild(m_pBackground);
                    addChild(m_pStick);
                }
                if( m_pBackground != NULL )
                {
                    m_pBackground->setPosition(touchPoint);
                }
                if( m_pStick != NULL )
                {
                    m_pStick->setPosition(touchPoint);
                }
                return;
            }
        }
        m_nTouchId = -1;
    }
}

void CJoyStick::ccTouchesMoved(CCSet *pTouches, CCEvent *pEvent)
{
    if( m_nTouchId == -1 )
        return;
    for( CCSetIterator it = pTouches->begin() ;
        it != pTouches->end(); it++ )
    {
        CCTouch *pTouch = (CCTouch *)*it;
        if( pTouch->getID() == m_nTouchId )
        {
            //move
            CCPoint touchPoint = pTouch->getLocation();
            CCPoint touchStart = m_exTouchMode==eJSTM_Fixed?m_cpFirePosition:pTouch->getStartLocation();
            float _fAngle = CMath::pointsToAngle(touchPoint, touchStart);
            if( _fAngle == m_preAngle )
                return;
            if( m_fMaxDisplayRadius >= ccpDistance(touchPoint, touchStart))
            {
                if( m_pStick != NULL )
                {
                    m_pStick->setPosition(touchPoint);
                }
            }
            else
            {
                if( m_pStick != NULL )
                {
                    //angle
                    float _fRadian = CMath::angleToRadian( _fAngle );
                    //
                    m_pStick->setPosition(ccp(
                        (m_exTouchMode==eJSTM_Fixed?m_cpFirePosition.x:touchStart.x) - m_fMaxDisplayRadius * cosf(_fRadian),
                        (m_exTouchMode==eJSTM_Fixed?m_cpFirePosition.y:touchStart.y) - m_fMaxDisplayRadius * sinf(_fRadian)
                                          ));

                }
            }

//            if( _fAngle < 0.0 )
//            {
//                _fAngle = 180.0f + fabs(_fAngle);
//            }
//            else
//            {
//                _fAngle = 180.0f - _fAngle;
//            }
//            float _fEveryAngle = 360.0f / (float)JOYSTICK_DIRECTION_COUNT;
//            float _fHalfAngle = _fEveryAngle / 2.0f;
//            int nIndex = -1;
//            for( int i = 0 ; i < JOYSTICK_DIRECTION_COUNT ; i++ )
//            {
//                bool bIn = false;
//                if( i == 0 )
//                {
//                    bIn = ( (_fAngle < _fHalfAngle && _fAngle >= 0.0f) || (_fAngle < 360.0f && _fAngle >= (360.0f - _fHalfAngle)) );
//                }
//                else
//                {
//                    bIn = (( _fAngle > _fHalfAngle + (float)(i-1) * _fEveryAngle ) && _fAngle < _fHalfAngle + (float)i * _fEveryAngle );
//                }
//                if( bIn )
//                {
//                    nIndex = i;
//                    break;
//                }
//            }
//
//            if( nIndex > -1 && nIndex != m_highLightLastIndex )
//            {
//                if( m_highLightLastIndex > -1 )
//                {
//                    m_pLightupDirection[m_highLightLastIndex]->shaderMulColor(1.0f, 1.0f, 1.0f, 1.0f);
//                }
//                m_pLightupDirection[ nIndex ]->shaderMulColor(5.0f, 5.0f, 5.0f, 2.0f);
//                m_highLightLastIndex = nIndex;
//            }

            m_preAngle = _fAngle;
            return;
        }
    }
}

void CJoyStick::ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent)
{
    if( m_nTouchId == -1 )
        return;
    for( CCSetIterator it = pTouches->begin() ;
        it != pTouches->end(); it++ )
    {
        CCTouch *pTouch = (CCTouch *)*it;
        if( pTouch->getID() == m_nTouchId )
        {
            if( m_bAutoHide )
            {
                if( m_pBackground != NULL )
                    m_pBackground->removeFromParentAndCleanup(false);
                if( m_pStick != NULL )
                    m_pStick->removeFromParentAndCleanup(false);
            }
            else
            {
                m_pStick->setPosition((m_exTouchMode==eJSTM_Fixed?m_cpFirePosition:pTouch->getStartLocation()));
            }
//            for( int i = 0 ; i < JOYSTICK_DIRECTION_COUNT ; i++ )
//            {
//                m_pLightupDirection[i]->shaderMulColor(1.0f, 1.0f, 1.0f, 1.0f);
//            }
            // m_highLightLastIndex = -1;
            m_nTouchId = -1;
            unschedule(schedule_selector(CJoyStick::fireCallback));
            CLuaScriptFunctionInvoker::executeJoyStickEnded(m_pControlScriptHandler);
            return;
        }
    }
}

void CJoyStick::ccTouchesCancelled(CCSet *pTouches, CCEvent *pEvent)
{
    CUserControl::ccTouchesCancelled(pTouches, pEvent);
}

void CJoyStick::fireCallback(float dt)
{
    if( m_pControlScriptHandler == NULL )
        return;
    float _fRadian = CMath::angleToRadian( CMath::pointsToAngle(m_pStick->getPosition(), m_pBackground->getPosition()) );
    float _fRadius = ccpDistance(m_pStick->getPosition(), m_pBackground->getPosition());
    //fire
    CLuaScriptFunctionInvoker::executeJoyStickCallback(m_pControlScriptHandler, _fRadian, _fRadius);
}







