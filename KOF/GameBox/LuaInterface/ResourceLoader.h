
    class CResourceLoader : public CCObject
    {
    public:
        static CResourceLoader *sharedResourceLoader();

    public:

        void appendFile(const char *lpcszFile);
        void startLoad();
        bool isLoading();


        void clearUnusedResources();
    public: //lua eventListener
        virtual void addLuaEventListener(const char *lpcszEventName, int selector);
        virtual void removeLuaEventListener(const char *lpcszEventName, int selector);
        virtual void removeLuaAllEventListener();
        virtual void dispatchLuaEvent(const char *lpcszEventName, ...);
        virtual void dispatchLuaEvent(const char *lpcszEventName, std::vector<SLuaEventArg *> *args);
        virtual void dispatchLuaEvent(const char *lpcszEventName, int nLuaTable);
        virtual bool hasLuaEventListener(const char *lpcszEventName);
        virtual void removeLuaEventListeners(const char *lpcszEventName);
    };
