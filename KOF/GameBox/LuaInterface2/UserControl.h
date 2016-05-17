    enum enumTextAlign
    {
        eTA_Left
        ,eTA_Center
        ,eTA_Right
    };

    class CUserControl : public CCNode
    {
    public:
        void registerNetworkMessageScriptHandler(LUA_FUNCTION nScriptHandler);
        void unregisterNetworkMessageScriptHandler();
        
        void registerControlScriptHandler(LUA_FUNCTION nScriptHandler, const char *lpcszLog=NULL);
        void unregisterControlScriptHandler();

        void setControlName( const char *lpcszControlName );
        const char *getControlName();
        CUserControl *getChildByName( const char *lpcszControlName );
        bool getInitialized();

        void setTouchesEnabled(bool bTouchEnabled);
        bool getTouchesEnabled();

        int getTouchesPriority();
        void setTouchesPriority(int nPriority);

        bool getDoubleTouchEnabled();
        void setDoubleTouchEnabled(bool bDoubleTouchEnabled);

        bool getFullScreenTouchEnabled();
        void setFullScreenTouchEnabled(bool bFullScreenTouchEnabled);

        ccTouchesMode getTouchesMode();
        void setTouchesMode(ccTouchesMode eMode);
        
        void registerTouchesDispatcher();
        void unregisterTouchesDispatcher();

        void onEnter();
        void onExit();
        bool containsTouch(CCTouch *pTouch);
        bool containsPoint(CCPoint *pGLPoint);
        
        bool isTouchInside(CCTouch *pTouch);
        void onTouchInside();
        void setViewId(int nViewId);
        int getViewId();

        void setMemoryWarnPercent(float fPercent);
        float getMemoryWarnPercent();
        
        CCAction *performSelector(float fDelay, LUA_FUNCTION nHandler);
        void unperformSelector(CCAction *pAction);

        virtual void addLuaEventListener(const char *lpcszEventName, LUA_FUNCTION selector);
        virtual void removeLuaEventListener(const char *lpcszEventName, LUA_FUNCTION selector);
        virtual void removeLuaAllEventListener();
        virtual void dispatchLuaEvent(const char *lpcszEventName, int nLuaTable);
        virtual bool hasLuaEventListener(const char *lpcszEventName);
        virtual void removeLuaEventListeners(const char *lpcszEventName);
        virtual bool isVisibility();
    };
