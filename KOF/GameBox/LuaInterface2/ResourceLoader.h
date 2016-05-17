
    class CResourceLoader : public CCObject
    {
    public:
        static CResourceLoader *sharedResourceLoader();

        void appendFile(const char *lpcszFile);
        
        void startLoad();
        
        bool isLoading();

        void clearUnusedResources();
        
        virtual void addLuaEventListener(const char *lpcszEventName, LUA_FUNCTION selector);
        
        virtual void removeLuaEventListener(const char *lpcszEventName, LUA_FUNCTION selector);
        
        virtual void removeLuaAllEventListener();
        
        virtual void dispatchLuaEvent(const char *lpcszEventName, std::vector<SLuaEventArg *> *args);
        
        virtual void dispatchLuaEvent(const char *lpcszEventName, int nLuaTable);
        
        virtual bool hasLuaEventListener(const char *lpcszEventName);
        
        virtual void removeLuaEventListeners(const char *lpcszEventName);
    };
