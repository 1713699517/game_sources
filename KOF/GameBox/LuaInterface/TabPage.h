
    class CTabPage : public CButton
    {
    public:

        static CTabPage* create(const char *normalLabel,const char *normolBackGroundSprite);
        static CTabPage* create(const char *normalLabel,const char *normolBackGroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite);

        static CTabPage *createWithSpriteFrameName(const char *normalLabel, const char *normalBackgroundSprite);
        static CTabPage *createWithSpriteFrameName(const char *normalLabel,const char *normalBackgroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite);

        const CContainer *getContainer();
        void setContainer(const CContainer *pContainer);

        CTab *getTab();

    };