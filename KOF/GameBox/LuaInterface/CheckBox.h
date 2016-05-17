    class CCheckBox : public CUserControl
    {
    public:

        static CCheckBox *create(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText);
        
        static CCheckBox *create(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText,enumTextAlign align);
        
        
        virtual bool getChecked();
        virtual void setChecked(bool bChecked);

        enumTextAlign getTextAlign();
        void setTextAlign(enumTextAlign align);

        virtual CCLabelTTF *getLabel();

        virtual const char *getText();
        virtual void setText(const char *lpcszText);

        virtual ccColor4B getColor();
        virtual void setColor(ccColor4B &color);

        virtual const char *getFontFamily();
        virtual void setFontFamily(const char *lpcszFontFamily);

        virtual float getFontSize();
        virtual void setFontSize(float fFontSize);
        
        const char *getGroupName();
        void setGroupName(const char *lpcszGroupName);
                
    };
