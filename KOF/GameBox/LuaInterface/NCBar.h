    class CNCBar : public CUserControl
    {
    public:
        static CNCBar *create();
    public:


        
        static CNCBar *create(CCLabelTTF *pLabel, CButton *pBtn, CSprite *pSprite);
        
        static CNCBar *create(const char *lpcszLabel, const char *lpcszBtn, const char *lpcszSprite);
        
        static CNCBar *createWithSpriteFrameName(const char *lpcszLabel, const char *lpcszBtn, const char *lpcszSprite);
        
        void setBackgroundSprite(CSprite *pBackground);
        CSprite *getBackgroundSprite();
        
        void setCloseButton(CButton *pButton);
        CButton *getCloseButton();
        
        
        void setPreferredSize( const CCSize &size );
        CCSize &getPreferredSize();
    };

#endif /* defined(__GameBox__NCBar__) */
