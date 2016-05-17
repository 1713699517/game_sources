    class CRichTextBox : public CUserControl
    {
    public:
        void setBackgroundColor(ccColor4B &rColor);

        static CRichTextBox *create(const CCSize &_size, ccColor4B &_backgroundColor);

        void scrollTo(const CCPoint &_scrollPoint);
        void scrollToBottom();
        CCSize &getScrollSize();
        CCPoint &getScrollPoint();
        void clearAll();
        void scrollToBottomNextFrame();

        void setAutoScrollDown(bool bAutoScrollDown);
        bool getAutoScrollDown();

        void setCurrentStyle(const char *lpcszFontFamily, float fFontSize, ccColor4B &color);

        void appendRichText(const char *lpcszData, const char *lpcszActionName = NULL, const char *Arg0 = NULL, const char *Arg1 = NULL, const char *Arg2 = NULL, const char *Arg3 = NULL , const char *Arg4 = NULL);

        void appendRichNode(const CCNode *lpcData, const char *lpcszActionName = NULL, const char *Arg0 = NULL, const char *Arg1 = NULL, const char *Arg2 = NULL, const char *Arg3 = NULL , const char *Arg4 = NULL);
        
    };
