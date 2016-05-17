    class CWindow : public CFloatLayer
    {
    public:
        
        static CWindow *create(CCLabelTTF *pLabel, CSprite *pBackground, CSprite *pBarBackground, CButton *pCloseBtn, CContainer *pContainer, bool bDefaultBar);

        static CWindow *create(const char *lpcszTitle, const char *lpcszBackground, const char *lpcszBarBackground, const char *lpcszClose, CContainer *pContainer, bool bDefaultBar);

        static CWindow *createWithSpriteFrameName(const char *lpcszTitle, const char *lpcszBackground, const char *lpcszBarBackground,const char *lpcszClose, CContainer *pContainer, bool bDefaultBar);

        static CWindow *create(CSprite *pBackground, CButton *pCloseBtn, CContainer *pContainer);

        static CWindow *create(const char *lpcszBackground, const char *lpcszClose, CContainer *pContainer);

        static CWindow *createWithSpriteFrameName(const char *lpcszBackground, const char *lpcszClose, CContainer *pContainer);

        void setWindowTitle(const char *lpcszInputTitle);
        const char *getWindowTitle();
        
        CCScene *getFullScreenScene();
    };

