//
//  UserControl.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-28.
//
//

#include <stdarg.h>
#include "UserControl.h"
#include "NotificationConstant.h"
#include "LuaScriptFunctionInvoker.h"
#include "DateTime.h"
#include "MemoryAllocator.h"

using namespace ptola::memory;



USING_NS_CC;
using namespace ptola;
using namespace ptola::network;
using namespace ptola::gui;
using namespace ptola::script;

#define DOUBLE_TOUCH_CONDITION_DELAY 0.3f        //300毫秒



MEMORY_MANAGE_OBJECT_IMPL(CUserControl);

CUserControl::CUserControl()
: m_pControlScriptHandler(NULL)
, m_pNetworkMessageScriptHandler(NULL)
, m_bFullScreenTouchEnabled(false)
, m_bTouchEnabled(false)
, m_bDoubleTouchEnabled(false)
, m_lDoubleTouchStart(0L)
, m_nTouchPriority(0)
, m_eTouchMode(kCCTouchesOneByOne)
, m_strControlName("\0")
, m_bInitialized(false)
, m_nViewId(0)
, m_fMemoryLevel(0.0f)
{

}

CUserControl::~CUserControl()
{
    unregisterNetworkMessageScriptHandler();
    unregisterControlScriptHandler();
}

void CUserControl::setControlName(const char *lpcszControlName)
{
    m_strControlName = lpcszControlName;
}

const char *CUserControl::getControlName()
{
    return m_strControlName.c_str();
}

bool CUserControl::getInitialized()
{
    return m_bInitialized;
}

CUserControl *CUserControl::getChildByName(const char *lpcszControlName)
{
    CCObject *pElement = NULL;
    CCArray *pChildren = getChildren();
    CCARRAY_FOREACH(pChildren, pElement)
    {
        CUserControl *pControl = dynamic_cast<CUserControl *>(pElement);
        if( pControl != NULL && strcmp( pControl->getControlName() , lpcszControlName) == 0 )
        {
            return pControl;
        }
    }
    return NULL;
}

void CUserControl::registerControlScriptHandler(int nScriptHandler, const char *lpcszLog)
{
    unregisterControlScriptHandler();
    m_pControlScriptHandler = CControlScriptHandler::create(nScriptHandler);
    CC_SAFE_RETAIN(m_pControlScriptHandler);

    CCLOG("%s (%s) [%d] log=%s" , getControlName(), typeid(this).name(), nScriptHandler, (lpcszLog==NULL?"":lpcszLog));
}

void CUserControl::unregisterControlScriptHandler()
{
    CC_SAFE_RELEASE(m_pControlScriptHandler);

}

void CUserControl::registerNetworkMessageScriptHandler(int nScriptHandler)
{
    unregisterNetworkMessageScriptHandler();
    m_pNetworkMessageScriptHandler = CNetworkMessageScriptHandler::create(nScriptHandler);
    CC_SAFE_RETAIN(m_pNetworkMessageScriptHandler);
    CCNotificationCenter::sharedNotificationCenter()->addObserver(this, callfuncO_selector(CUserControl::executeNetworkMessageScript), NOTIFYCONST_NETWORK_MESSAGE, NULL);
}

void CUserControl::unregisterNetworkMessageScriptHandler()
{
    if( m_pNetworkMessageScriptHandler != NULL )
    {
        CCNotificationCenter::sharedNotificationCenter()->removeObserver(this, NOTIFYCONST_NETWORK_MESSAGE);
        CC_SAFE_RELEASE(m_pNetworkMessageScriptHandler);
    }
}

void CUserControl::executeNetworkMessageScript(CCObject *pMsg)
{
    CAckMessage *pAck = dynamic_cast<CAckMessage *>(pMsg);
//    if( pAck != NULL )
//    {
//        //test
//        if( pAck->getHeader()->uMsgId == 510 )
//        {
//            CDataReader reader( pAck->getStreamData() );
//            unsigned int srvt = (reader.readUnsignedInt());
//            unsigned char uchArg1 = reader.readByte();
//            int nuch = (int)uchArg1;
//            unsigned short ustArg2 = (reader.readUnsignedShort());
//            std::string strArg3;
//            reader.readString(strArg3);
//            std::string strArg4;
//            reader.readStringLong(strArg4);
//
//            CCLOG("%u %d %d %s %s", srvt, uchArg1, ustArg2, strArg3.c_str(), strArg4.c_str());
//            //
//            reader.close();
//        }
//    }
    if( m_pNetworkMessageScriptHandler != NULL && pAck != NULL )
    {
        
        CCScriptEngineManager::sharedManager()->getScriptEngine()->executeEvent(m_pNetworkMessageScriptHandler->getHandler(), NOTIFYCONST_NETWORK_MESSAGE, pAck, "CAckMessage");
    }
}


void CUserControl::onEnter()
{
    CCNode::onEnter();
    CLuaScriptFunctionInvoker::executeNodeEnterScript(m_pControlScriptHandler, this);
    if( m_bTouchEnabled )
    {
        registerTouchesDispatcher();
    }
}

void CUserControl::onExit()
{
    unregisterTouchesDispatcher();
    CLuaScriptFunctionInvoker::executeNodeExitScript(m_pControlScriptHandler, this);
    CCNode::onExit();
}

void CUserControl::onEnterTransitionDidFinish()
{
    CLuaScriptFunctionInvoker::executeTransitionFinishScript(m_pControlScriptHandler, this);
    CCNode::onEnterTransitionDidFinish();
}

void CUserControl::onExitTransitionDidStart()
{
    CCNode::onExitTransitionDidStart();
    CLuaScriptFunctionInvoker::executeTransitionStartScript(m_pControlScriptHandler, this);
}

bool CUserControl::onInitialized(bool bResult)
{
    m_bInitialized = bResult;
    return m_bInitialized;
}

//====================================================
/*
 Touch Relatives
*/
//====================================================
bool CUserControl::getTouchesEnabled()
{
    return m_bTouchEnabled;
}

void CUserControl::setTouchesEnabled(bool bTouchEnabled)
{
    if( m_bTouchEnabled == bTouchEnabled )
        return;
    m_bTouchEnabled = bTouchEnabled;
    if( isRunning() )
    {
        if( m_bTouchEnabled )
        {
            registerTouchesDispatcher();
        }
        else
        {
            unregisterTouchesDispatcher();
        }
    }
}

int CUserControl::getTouchesPriority()
{
    return m_nTouchPriority;
}

void CUserControl::setTouchesPriority(int nPriority)
{
    if( m_nTouchPriority == nPriority )
        return;
    m_nTouchPriority = nPriority;
    if( m_bTouchEnabled && isRunning() )
    {
        unregisterTouchesDispatcher();
        registerTouchesDispatcher();
    }
}

ccTouchesMode CUserControl::getTouchesMode()
{
    return m_eTouchMode;
}

void CUserControl::setTouchesMode(ccTouchesMode eMode)
{
    if( m_eTouchMode == eMode )
        return;
    m_eTouchMode = eMode;
    if( m_bTouchEnabled && isRunning() )
    {
        unregisterTouchesDispatcher();
        registerTouchesDispatcher();
    }
}

bool CUserControl::getDoubleTouchEnabled()
{
    return m_bDoubleTouchEnabled;
}

void CUserControl::setDoubleTouchEnabled(bool bDoubleTouchEnabled)
{
    m_bDoubleTouchEnabled = bDoubleTouchEnabled;
}

bool CUserControl::getFullScreenTouchEnabled()
{
    return m_bFullScreenTouchEnabled;
}

void CUserControl::setFullScreenTouchEnabled(bool bFullScreenTouchEnabled)
{
    if( m_bFullScreenTouchEnabled == bFullScreenTouchEnabled )
        return;
    m_bFullScreenTouchEnabled = bFullScreenTouchEnabled;
    if( m_bFullScreenTouchEnabled && isRunning() )
    {
        unregisterTouchesDispatcher();
        registerTouchesDispatcher();
    }
}

void CUserControl::registerTouchesDispatcher()
{
    if( !m_bTouchEnabled )
        return;
    if( m_eTouchMode == kCCTouchesOneByOne )
    {
        CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, m_nTouchPriority, true);
    }
    else
    {
        CCDirector::sharedDirector()->getTouchDispatcher()->addStandardDelegate(this, m_nTouchPriority);
    }
}

void CUserControl::unregisterTouchesDispatcher()
{
    CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
}

bool CUserControl::containsTouch(CCTouch *pTouch)
{
    if( isIgnoreAnchorPointForPosition() )
    {
        CCPoint touchPoint = convertTouchToNodeSpace( pTouch );
        return containsPoint(&touchPoint);
    }
    else
    {
        CCPoint touchPointAR = convertTouchToNodeSpaceAR( pTouch );
        return containsPoint(&touchPointAR);
    }
}

bool CUserControl::containsPoint(CCPoint *pGLPoint)
{
    return boundingBox().containsPoint(*pGLPoint);
}

bool CUserControl::isTouchInside(CCTouch *pTouch)
{
    if( getFullScreenTouchEnabled() )
        return true;
    return containsTouch(pTouch);
}

void CUserControl::onTouchInside()
{
    
}

bool CUserControl::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
    if( !isVisibility() || !isTouchInside(pTouch) )
        return false;
//    CCPoint touchPoint = pTouch->getLocationInView();
    
    onTouchInside();
    CEvent evt("TouchBegan", this, pTouch);
    m_eventDispatcher.dispatchEvent(this, &evt);
    
    CCPoint touchPoint = pTouch->getLocation();
    if( getFullScreenTouchEnabled() )
    {
        CLuaScriptFunctionInvoker::executeTouchScript(m_pControlScriptHandler, "TouchBegan", this, "CUserControl", touchPoint.x, touchPoint.y );
        return true;
    }
    
    if( CLuaScriptFunctionInvoker::executeTouchScript(m_pControlScriptHandler, "TouchBegan", this, "CUserControl", touchPoint.x, touchPoint.y ) )
    {
        //CCLOG("xxx===%f,   y===%f\n",touchPoint.x, touchPoint.y);
        return true;
    }
    else
    {
        //CCLOG("xxx===%f,   y===%f\n",touchPoint.x, touchPoint.y);
        return false;
    }
}

void CUserControl::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent)
{
    CEvent evt("TouchMoved", this, pTouch);
    m_eventDispatcher.dispatchEvent(this, &evt);
    CCPoint touchPoint = pTouch->getLocation();
    CLuaScriptFunctionInvoker::executeTouchScript(m_pControlScriptHandler, "TouchMoved", this, "CUserControl", touchPoint.x, touchPoint.y );
}

void CUserControl::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent)
{
    if( getDoubleTouchEnabled() )
    {
        if( m_lDoubleTouchStart == 0L )
        {
            CDateTime now1;
            m_lDoubleTouchStart = now1.getMicroseconds();
            scheduleOnce(schedule_selector(CUserControl::onDoubleClickTimeCallback), DOUBLE_TOUCH_CONDITION_DELAY);
            m_fTouchX = pTouch->getLocation().x;
            m_fTouchY = pTouch->getLocation().y;
        }
        else
        {
            //fire touch event
            unschedule(schedule_selector(CUserControl::onDoubleClickTimeCallback));
            CDateTime now2;
            if( now2.getMicroseconds() - m_lDoubleTouchStart < (long)(DOUBLE_TOUCH_CONDITION_DELAY * 1000000.0f))
            {
                ccTouchDoubleEnded(pTouch, pEvent);
            }
            m_lDoubleTouchStart = 0L;
        }
    }
    else
    {
        CEvent evt("TouchEnded", this, pTouch);
        m_eventDispatcher.dispatchEvent(this, &evt);
        CCPoint touchPoint = pTouch->getLocation();
        CLuaScriptFunctionInvoker::executeTouchScript(m_pControlScriptHandler, "TouchEnded", this, "CUserControl", touchPoint.x, touchPoint.y );
    }
}

void CUserControl::onDoubleClickTimeCallback(float fDuration)
{
    //time out fire touchended
    CCTouch tempTouch;
    tempTouch.setTouchInfo(0, m_fTouchX, m_fTouchY);
    CEvent evt("TouchEnded", this, &tempTouch);
    m_eventDispatcher.dispatchEvent(this, &evt);
    CLuaScriptFunctionInvoker::executeTouchScript(m_pControlScriptHandler, "TouchEnded", this, "CUserControl", m_fTouchX, m_fTouchY );
    m_lDoubleTouchStart = 0L;
}

void CUserControl::ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent)
{
    CEvent evt("TouchCancelled", this, pTouch);
    m_eventDispatcher.dispatchEvent(this, &evt);
    CCPoint touchPoint = pTouch->getLocation();
    CLuaScriptFunctionInvoker::executeTouchScript(m_pControlScriptHandler, "TouchCancelled", this, "CUserControl", touchPoint.x, touchPoint.y );
}

void CUserControl::ccTouchDoubleEnded(CCTouch *pTouch, CCEvent *pEvent)
{
    CEvent evt("DoubleTouchEnded", this, pTouch);
    m_eventDispatcher.dispatchEvent(this, &evt);
    CCPoint touchPoint = pTouch->getLocation();
    CLuaScriptFunctionInvoker::executeTouchScript(m_pControlScriptHandler, "DoubleTouchEnded", this, "CUserControl", touchPoint.x, touchPoint.y );
}

void CUserControl::ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent)
{
    if( !isVisibility() )
        return;
    CLuaScriptFunctionInvoker::executeTouchesScript(m_pControlScriptHandler, "TouchesBegan", this, "CUserControl", pTouches );
}

void CUserControl::ccTouchesMoved(CCSet *pTouches, CCEvent *pEvent)
{
    if( !isVisibility() )
        return;
    CLuaScriptFunctionInvoker::executeTouchesScript(m_pControlScriptHandler, "TouchesMoved", this, "CUserControl", pTouches );
}

void CUserControl::ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent)
{
    if( !isVisibility() )
        return;
    CLuaScriptFunctionInvoker::executeTouchesScript(m_pControlScriptHandler, "TouchesEnded", this, "CUserControl", pTouches );
}

void CUserControl::ccTouchesCancelled(CCSet *pTouches, CCEvent *pEvent)
{
    CLuaScriptFunctionInvoker::executeTouchesScript(m_pControlScriptHandler, "TouchesCancelled", this, "CUserControl", pTouches );
}

//eventListener
void CUserControl::addEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector)
{
    m_eventDispatcher.addEventListener(lpcszEventName, pTarget, selector);
}

void CUserControl::removeEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector)
{
    m_eventDispatcher.removeEventListener(lpcszEventName, pTarget, selector);
}

void CUserControl::removeEventListeners(const char *lpcszEventName)
{
    m_eventDispatcher.removeEventListeners(lpcszEventName);
}

void CUserControl::removeAllEventListener()
{
    m_eventDispatcher.removeAllEventListener();
}

void CUserControl::dispatchEvent(CCObject *pSender, CEvent *pEvent)
{
    m_eventDispatcher.dispatchEvent(pSender, pEvent);
}

bool CUserControl::hasEventListener(const char *lpcszEventName)
{
    return m_eventDispatcher.hasEventListener(lpcszEventName);
}

void CUserControl::addLuaEventListener(const char *lpcszEventName, int selector)
{
    m_luaEventDispatcher.addEventListener(lpcszEventName, selector);
}

void CUserControl::removeLuaEventListener(const char *lpcszEventName, int selector)
{
    m_luaEventDispatcher.removeEventListener(lpcszEventName, selector);
}

void CUserControl::removeLuaEventListeners(const char *lpcszEventName)
{
    m_luaEventDispatcher.removeEventListeners(lpcszEventName);
}

void CUserControl::removeLuaAllEventListener()
{
    m_luaEventDispatcher.removeAllEventListener();
}

bool CUserControl::hasLuaEventListener(const char *lpcszEventName)
{
    return m_luaEventDispatcher.hasEventListener(lpcszEventName);
}

void CUserControl::dispatchCLuaEvent(const char *lpcszEventName, ...)
{
    std::vector<SLuaEventArg *> vecArgs;
    va_list args;
    va_start(args, lpcszEventName);
    SLuaEventArg *i = va_arg(args, SLuaEventArg*);
    while(i != NULL)
    {
        vecArgs.push_back(i);
        i = va_arg(args, SLuaEventArg*);
    }
    va_end(args);
    m_luaEventDispatcher.dispatchEvent(lpcszEventName, &vecArgs);
}

void CUserControl::dispatchCLuaEvent(const char *lpcszEventName, std::vector<SLuaEventArg *> *args)
{
    m_luaEventDispatcher.dispatchEvent(lpcszEventName, args);
}

void CUserControl::dispatchLuaEvent(const char *lpcszEventName, int nLuaTable)
{
    m_luaEventDispatcher.dispatchEvent(lpcszEventName, nLuaTable);
}

void CUserControl::setViewId(int nViewId)
{
    m_nViewId = nViewId;
}

int CUserControl::getViewId()
{
    return m_nViewId;
}

bool CUserControl::isVisibility()
{
    CCNode *pNode = (CCNode *)this;
    do
    {
        if( pNode->isRunning() && !pNode->isVisible() )
        {
            return false;
        }
    }
    while ( (pNode = pNode->getParent()) != NULL );
    return true;
}

void CUserControl::setMemoryWarnPercent(float fPercent)
{
    if( fPercent <= 0.0f )
        fPercent = 0.0f;
    if( fPercent == 0 )
    {
        CCNotificationCenter::sharedNotificationCenter()->removeObserver(this, MEMORYWARN_MESSAGE);
    }
    else
    {
        CCNotificationCenter::sharedNotificationCenter()->addObserver(this, callfuncO_selector(CUserControl::executeMemoryWarnScript), MEMORYWARN_MESSAGE, NULL);
    }
    m_fMemoryLevel = fPercent;
}

float CUserControl::getMemoryWarnPercent()
{
    return m_fMemoryLevel;
}

void CUserControl::executeMemoryWarnScript(cocos2d::CCObject *pIntLevel)
{
    CCFloat *pLevel = dynamic_cast<CCFloat *>(pIntLevel);
    if( pLevel != NULL )
    {
        float fLevel = pLevel->getValue();
        if( fLevel >= m_fMemoryLevel )
        {
            CLuaScriptFunctionInvoker::executeMemoryWarn(m_pControlScriptHandler, this, "CUserControl", fLevel);
        }
    }
}

CCAction *CUserControl::performSelector(float fDelay, int nHandler)
{
    if( fDelay <= 0.0f )
    {
        return runAction(CCCallFunc::create(nHandler));
    }
    else
    {
        return runAction(CCSequence::create(CCDelayTime::create(fDelay), CCCallFunc::create(nHandler), NULL));
    }
}

void CUserControl::unperformSelector(CCAction *pAction)
{
    stopAction(pAction);
}
