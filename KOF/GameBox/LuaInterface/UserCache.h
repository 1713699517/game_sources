    class CUserCache : public CCObject
    {
    public:
        static CUserCache *sharedUserCache();
        void setObject(const char *key, const char *value);
        const char *getObject(const char *key);
        void removeObject(const char *key);
    };