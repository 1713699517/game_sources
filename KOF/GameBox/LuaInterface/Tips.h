    class CTips : public CFloatLayer
    {
    public:

        static CTips *create(CCSize &cellSize, enumLayoutDirection eDirection,CCScale9Sprite* bg_Sprite);

        unsigned int getChildrenCount();
        CCArray *getChildren();

        void addChild(CCNode *child);
        void addChild(CCNode* child, int zOrder);
        void addChild(CCNode* child, int zOrder, int tag);
        
        CLayout * getLayout();
        void setLayout(CLayout *m_Layout);
        
    };