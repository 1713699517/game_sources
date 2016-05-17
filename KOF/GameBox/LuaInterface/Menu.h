
        class CMenu : public CFloatLayer
        {
            public:
                
                static CMenu *create(CCSize& cellSize, enumLayoutDirection eDirection,CCScale9Sprite* bg_Spirte);
                

                
                virtual unsigned int getChildrenCount();
                virtual CCArray *getChildren();
                
                virtual void addChild(CCNode *child);
                virtual void addChild(CCNode* child, int zOrder);
                virtual void addChild(CCNode* child, int zOrder, int tag);
            
                CCSize* getMenuSize() {return m_pCellSize;};
                void setMenuSize(CCSize* mSize) {m_pCellSize =  mSize;};
            
                CLayout * getLayout(){return m_pContainer;};
                void setLayout(CLayout *m_Layout) {m_pContainer = m_Layout;};
            
                
            virtual void show(CCNode *pParent, const CCPoint &pos, enumActionType eActionType);
            
            
            virtual void show(CCNode *pParent, float fx, float fy, enumActionType eActionType);
            
            virtual void hide(enumActionType eActionType);
            
            
            
            };
