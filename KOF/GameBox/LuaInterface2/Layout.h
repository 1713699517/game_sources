    enum enumLayoutDirection
    {
        eLD_Relative = 0
        ,eLD_Horizontal
        ,eLD_Vertical
    };

    class CLayout : public CContainer
    {
    public:
        
        static CLayout * create();

        
        static CLayout* create(enumLayoutDirection);

        virtual bool performLayout();

        CCSize &getCellSize();
        void setCellSize(const CCSize &value);

        float getCellHorizontalSpace();
        void setCellHorizontalSpace(float fValue);

        float getCellVerticalSpace();
        void setCellVerticalSpace(float fValue);
        
        int getLayoutRow();
        
        int getLayoutColumn();
        
        enumLayoutDirection getLayoutDirection();

        virtual void addChild(CCNode *child);
        virtual void addChild(CCNode* child, int zOrder);
        virtual void addChild(CCNode* child, int zOrder, int tag);

        void setHorizontalDirection(bool m_bvalue);
        bool getHorizontalDirection();

        void setVerticalDirection(bool m_bvalue);
        bool getVerticalDirection();


        void setLineNodeSum(int m_sum);

        int getLineNodeSum();

        int getColumnNodeSum();
        void setColumnNodeSum(int m_Value);
    };

