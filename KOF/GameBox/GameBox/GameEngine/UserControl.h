//
//  UserControl.h
//  GameBox
//
//  Created by Caspar on 2013-4-28.
//
//

#ifndef __GameBox__UserControl__
#define __GameBox__UserControl__

#include "cocos2d.h"
#include "LuaScriptHandler.h"
#include "Msg.h"
#include "EventDispatcher.h"
#include "LuaEventDispatcher.h"
#include "ptola.h"

USING_NS_CC;
using namespace ptola::network;
using namespace ptola::script;
using namespace ptola::event;

namespace ptola
{
namespace gui
{

    typedef void (CCObject::*SEL_ControlEventHandler)(CCObject *pSender, CCEvent *pEvent);

    enum enumTextAlign
    {
        eTA_Left
        ,eTA_Center
        ,eTA_Right
    };

//    enum enumControlEventType
//    {
//        "Load"                    //读取成功时
//        "AnimationComplete"       //播放完动画时
//        "TouchBegan"              //单点触控开始
//        "TouchMoved"              //单点触控移动
//        "TouchEnded"              //单点触控结束
//        "TouchCancelled"          //单点触控取消
//        "DoubleTouch"             //单点触控双击
//        "TouchesBegan"            //多点触控开始
//        "TouchesMoved"            //多点触控移动
//        "TouchesEnded"            //多点触控结束
//        "TouchesCancelled"        //多点触控取消
//        "Enter"                   //进入场景
//        "Exit"                    //离开场景
//        "AssignMember"            //签入成员
//
//
//        "LoadProgress"            //资源管理器读取中
//        "LoadComplete"            //资源管理器读取完毕
//
//        "InitAsset"               //初始化asset目录时
//        "ProgressAsset"           //处理asset目录时
//        "CompleteAsset"           //完成处理asset目录时
//
//        "WebViewCallBack"         //WebView读取完成后回调
//
//        "JoyStickCallBack"        //虚拟摇杆回调(事件类型, 弧度, 半径)(eventType, radian, radius)
//        "JoyStickEnded"           //虚拟摇杆放手回调
//
//        "PageScrolled"            //ScrollView回调(事件类型, 对象, int 页)
//        "TabPageChanged"          //CTab控件,标签页改变时回调
//        "EditBoxReturn"           //CEditBox控件回调,当输入完成时(eventType, obj_ceditbox, str_string)
//        "RichTextBoxCallBack"     //RichTextBox控件回调，当点击含命令行的文字时（eventType, actionName, ... args）
//        "MemoryWarn"              //内存警告 (eventType, fPercent)
//        "TransitionStart"         //场景切换开始
//        "TransitionFinish"        //场景切换结束
//    };




    class CUserControl : public CCNode, public CCTouchDelegate
    {
    public:

        MEMORY_MANAGE_OBJECT(CUserControl);
        
        CUserControl();
        ~CUserControl();

    public:
        void registerNetworkMessageScriptHandler(int nScriptHandler);
        void unregisterNetworkMessageScriptHandler();
        
        void registerControlScriptHandler(int nScriptHandler, const char *lpcszLog = NULL);
        void unregisterControlScriptHandler();

    public: //init
        void setControlName( const char *lpcszControlName );
        const char *getControlName();
        CUserControl *getChildByName( const char *lpcszControlName );
        bool getInitialized();
    public: //touch
        virtual void setTouchesEnabled(bool bTouchEnabled);
        virtual bool getTouchesEnabled();

        virtual int getTouchesPriority();
        virtual void setTouchesPriority(int nPriority);

        virtual bool getDoubleTouchEnabled();
        virtual void setDoubleTouchEnabled(bool bDoubleTouchEnabled);

        virtual bool getFullScreenTouchEnabled();
        virtual void setFullScreenTouchEnabled(bool bFullScreenTouchEnabled);

        ccTouchesMode getTouchesMode();
        void setTouchesMode(ccTouchesMode eMode);
        
        virtual void registerTouchesDispatcher();
        virtual void unregisterTouchesDispatcher();

        virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
        virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
        virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
        virtual void ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent);
        virtual void ccTouchDoubleEnded( CCTouch *pTouch, CCEvent *pEvent );

        virtual void ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent);
        virtual void ccTouchesMoved(CCSet *pTouches, CCEvent *pEvent);
        virtual void ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent);
        virtual void ccTouchesCancelled(CCSet *pTouches, CCEvent *pEvent);
        
        virtual void onEnter();
        virtual void onExit();
        virtual void onEnterTransitionDidFinish();
        virtual void onExitTransitionDidStart();
        virtual bool containsTouch(CCTouch *pTouch);
        virtual bool containsPoint(CCPoint *pGLPoint);
        
        virtual bool isTouchInside(CCTouch *pTouch);
        virtual void onTouchInside();

        virtual void setViewId(int nViewId);
        virtual int getViewId();

        virtual void setMemoryWarnPercent(float fLevel);
        virtual float getMemoryWarnPercent();

        virtual CCAction *performSelector(float fDelay, int nHandler);
        virtual void unperformSelector(CCAction *pAction);
    public: //eventListener
        virtual void addEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector);
        virtual void removeEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector);
        virtual void removeAllEventListener();
        virtual void dispatchEvent(CCObject *pSender, CEvent *pEvent);
        virtual bool hasEventListener(const char *lpcszEventName);
        virtual void removeEventListeners(const char *lpcszEventName);
    public: //lua eventListener
        virtual void addLuaEventListener(const char *lpcszEventName, int selector);
        virtual void removeLuaEventListener(const char *lpcszEventName, int selector);
        virtual void removeLuaAllEventListener();
        virtual void dispatchCLuaEvent(const char *lpcszEventName, ...);
        virtual void dispatchCLuaEvent(const char *lpcszEventName, std::vector<SLuaEventArg *> *args);
        virtual void dispatchLuaEvent(const char *lpcszEventName, int nLuaTable);
        virtual bool hasLuaEventListener(const char *lpcszEventName);
        virtual void removeLuaEventListeners(const char *lpcszEventName);
        virtual bool isVisibility();
    protected:
        virtual void executeNetworkMessageScript(CCObject *pAckMessage);
        virtual void executeMemoryWarnScript(CCObject *pIntLevel);
        virtual bool onInitialized(bool bResult);
        //script
        CControlScriptHandler *m_pControlScriptHandler;
        CNetworkMessageScriptHandler *m_pNetworkMessageScriptHandler;
    private:

        //touch
        void onDoubleClickTimeCallback(float fDuration);
        bool m_bFullScreenTouchEnabled;
        bool m_bTouchEnabled;
        bool m_bDoubleTouchEnabled;
        long m_lDoubleTouchStart;
        float m_fTouchX, m_fTouchY;
        int  m_nTouchPriority;
        ccTouchesMode m_eTouchMode;

        //control
        std::string m_strControlName;
        bool m_bInitialized;
        int m_nViewId;

        //event
        CEventDispatcher m_eventDispatcher;
        CLuaEventDispatcher m_luaEventDispatcher;

        //
        float m_fMemoryLevel;
    };

}
}

#endif /* defined(__GameBox__UserControl__) */
