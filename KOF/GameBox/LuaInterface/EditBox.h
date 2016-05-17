class CEditBox : public CUserControl
{
public:
        
            static CEditBox *create(const CCSize &size,CCScale9Sprite* pNormal9SpriteBg, int nMaxLength,const char *lpcszPlaceHolder, EditBoxInputFlag kEditBoxFlag);
        
            static CEditBox *create(const CCSize &size,const char* lpcszNormal9SpriteBg, int nMaxLength,const char *lpcszPlaceHolder, EditBoxInputFlag kEditBoxFlag);
        
        public:
        void setEditBoxMaxLength(int nMaxLength);
        int getEditBoxMaxLength();
        
        void setTextString(const char* lpcszLabel);
        const char *getTextString();

	void setFont(const char *lpcszFontFamily, float fFontSize);
	void setFontColor(const ccColor3B &_color);
            
            void setEditBoxInputMode(EditBoxInputMode kMode);
            EditBoxInputMode getEditBoxInputMode();
};