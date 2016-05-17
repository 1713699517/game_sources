
    class CAlertDialog : public CFloatLayer
    {
    public:

        static CAlertDialog *sharedAlertDialog();

        void appendMessage( const char *lpcszMessage );

        
        static CAlertDialog *create(CCSize &cellSize,enumLayoutDirection eDirection);
        bool init(CCSize &cellSize, enumLayoutDirection eDirection);
        
        void setVerticalLayout(CVerticalLayout *vLayout);
        CVerticalLayout *getVerticalLayout();
        
        float getDisplayTime();
        void setDisplayTime(float fTime);

        virtual unsigned int getChildrenCount();
        virtual CCArray *getChildren();

        void removeAlertDialog();
        
        virtual void addChild(CCNode *child);
        virtual void addChild(CCNode* child, int zOrder);
        virtual void addChild(CCNode* child, int zOrder, int tag);
        
    };
    
    