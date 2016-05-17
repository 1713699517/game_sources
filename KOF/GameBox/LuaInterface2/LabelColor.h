    class CLabelColor : public CUserControl
    {
    public:
        static CLabelColor *create();
        

        void appendText(const char *pText, const ccColor4B &pColor, const char *lpcszFamilyName, float fFontSize);

        void appendText(const char *pText, const char *lpcszFamilyName, float fFontSize);
    };
