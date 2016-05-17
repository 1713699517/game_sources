   
    class CWebView : public CUserControl
    {
    public:

        static const char *urlEncode(const char *lpcszUrl);
        static const char *urlDecode(const char *lpcszUrl);
        
        CWebView();

        static CWebView *create();
        bool init();

        void setPreferredSize(const CCSize &value);
        CCSize getPreferredSize();

        void loadGet(const char *lpcszUrl);
        
        void loadPost(const char *lpcszUrl);


        const char *getResponseText();
        const char *getResponseHTML();
    };