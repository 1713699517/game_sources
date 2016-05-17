
    class CEvent : public CCObject
    {
    public:
        CEvent(const char *lpcszEventName, CCObject *lpTarget, CCObject *lpData);
    public:
        static CEvent *create(const char *lpcszEventName, CCObject *lpTarget, CCObject *lpData );

        const char *getEventName();
        bool getHandled();
        void stopPropagation();
        CCObject *getTarget();
        CCObject *getData();
    };