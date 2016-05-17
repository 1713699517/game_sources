    class CVerticalLayout : public CLayout
    {
    public:
        
        static CVerticalLayout *create();
        void addChild(CCNode *child);
        void addChild(CCNode* child, int zOrder);
        void addChild(CCNode* child, int zOrder, int tag);
                
        bool performLayout();
        
        
    };
