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
//        "MemoryWarn"              //内存警告 (eventType, nLevel)
//    };

    class CUserControl : public CCNode
    {
    public:

    public:
        void registerNetworkMessageScriptHandler(int nScriptHandler);
        void unregisterNetworkMessageScriptHandler();
        
        void registerControlScriptHandler(int nScriptHandler, const char *lpcszLog);
        void unregisterControlScriptHandler();

    public: //init
        void setControlName( const char *lpcszControlName );
        const char *getControlName();
        CUserControl *getChildByName( const char *lpcszControlName );
        bool getInitialized();
    public: //touch
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
        
        CCAction *performSelector(float fDelay, int nHandler);
        void unperformSelector(CCAction *pAction);
    public: //lua eventListener
        virtual void addLuaEventListener(const char *lpcszEventName, int selector);
        virtual void removeLuaEventListener(const char *lpcszEventName, int selector);
        virtual void removeLuaAllEventListener();
        virtual void dispatchLuaEvent(const char *lpcszEventName, ...);
        virtual void dispatchLuaEvent(const char *lpcszEventName, std::vector<SLuaEventArg *> *args);
        virtual void dispatchLuaEvent(const char *lpcszEventName, int nLuaTable);
        virtual bool hasLuaEventListener(const char *lpcszEventName);
        virtual void removeLuaEventListeners(const char *lpcszEventName);
        virtual bool isVisibility();
    };
