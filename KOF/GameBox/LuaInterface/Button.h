    enum eTextAlignment
    {
        kTextAlignmentCenter = 0,
        kTextAlignmentLeft = 1,
        kTextAlignmentRight = 2
    };

    class CButton : public CUserControl
    {
    public:

        void setVerticalAlignment(eTextAlignment textAlignment);
        eTextAlignment getVerticalAlignment();
        
        virtual void setText(const char *lpcszText);
        virtual const char *getText();
                
        virtual ccColor4B getColor();
        virtual void setColor(ccColor4B &color);

        virtual float getFontSize();
        virtual void setFontSize(float fFontSize);

        virtual const char *getFontFamily();
        virtual void setFontFamily(const char *lpcszFontFamily);

        bool getChecked();
        void setChecked(bool bChecked);
        

        static CButton* create(CCLabelTTF* label, CSpriteRGBA* backgroundSprite);
        
        static CButton* create(CCLabelTTF* label, CSpriteRGBA* backgroundSprite, CCLabelTTF* checkedLabel, CSpriteRGBA* checkedBackgroundSprite, bool bDefaultChecked);
        
        
        static CButton* create(const char *normalLabel,const char *normolBackGroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite, bool bDefaultChecked);

        static CButton* create(const char *normalLabel,const char *normolBackGroundSprite);


        static CButton* createWithSpriteFrameName(const char *normalLabel,const char *normolBackGroundSprite);

        static CButton *createWithSpriteFrameName(const char *normalLabel, const char *normalBackgroundSprite, const char *checkedLabel, const char *checkedBackGroundSprite, bool bDefaultChecked);

        
        void setPreferredSize( const CCSize &size );
        CCSize &getPreferredSize();

    public:
        void setHightLight();
        void setDefault();
        void setDark();
        void setGray();
        void setPressed();
        
    };
