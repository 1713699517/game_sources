
    class CHorizontalLayout : public CLayout
    {
    public:
        bool performLayout();
        
        static CHorizontalLayout* create();
        
       
        void addChild(CCNode *child);
        void addChild(CCNode* child, int zOrder);
        void addChild(CCNode* child, int zOrder, int tag);

    };