    class CIcon : public CUserControl
    {
    public:

        static CIcon* create();

        static CIcon* create(const char *lpcszResourceName);

        static CIcon* createWithSpriteFrameName(const char *lpcszResourceName);
    };
