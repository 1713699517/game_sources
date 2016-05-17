
    class CLanguageManager
    {
    public:
        static CLanguageManager *sharedLanguageManager();

        void setLocate(ccLanguageType lang);
        ccLanguageType getLocate();

        const char *getString(const char *key);
    };
