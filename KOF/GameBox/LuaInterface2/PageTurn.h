    class CPageTurn : public CUserControl
    {
    public:

        static CPageTurn *create(CContainer *pContainer,unsigned int uCurrentPage,unsigned int uMaxPages);
        
        
        void setCurrentPage(unsigned int uPage);
        unsigned int getCurrentPage();

        void setMaxPages(unsigned int uPages);
        unsigned int getMaxPages();
        
        void setText(const char *lpcszText);
        const char *getText();

        ccColor4B getColor();
        void setColor(ccColor4B &color);

        float getFontSize();
        void setFontSize(float fFontSize);

        const char *getFontFamily();
        void setFontFamily(const char *lpcszFontFamily);

        CCLabelTTF *getLabel();
        
        void goPreviousPage(CCObject *pSender);
        
        void goNextPage(CCObject *pSender);
        
        bool containsPoint(CCPoint *pGLPoint);
        void onTouchInside();
        
    };

