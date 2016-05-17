//
//  Layout.h
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#ifndef __GameBox__Layout__
#define __GameBox__Layout__

#include "Container.h"
#include "ptola.h"

namespace ptola
{
    namespace gui
    {
        
        enum enumLayoutDirection
        {
            eLD_Relative
            ,eLD_Horizontal
            ,eLD_Vertical
        };
        
        class CLayout : public CContainer
        {
        public:

            MEMORY_MANAGE_OBJECT(CLayout);
            
            CLayout();
            CLayout(CCSize CellSize);
            ~CLayout();
            
            CREATE_FUNC(CLayout);
            
            bool init();
            
            static CLayout* create(enumLayoutDirection);
            
            virtual bool performLayout();
            
            CCSize &getCellSize();
            void setCellSize(const CCSize &value);
            
            float getCellHorizontalSpace();
            void setCellHorizontalSpace(float fValue);
            
            float getCellVerticalSpace();
            void setCellVerticalSpace(float fValue);
            
            int getLayoutRow(){return m_nRow;}
            
            int getLayoutColumn(){return m_nColumn;}
            
            int getLayoutDirection();
            
            virtual void addChild(CCNode *child);
            virtual void addChild(CCNode* child, int zOrder);
            virtual void addChild(CCNode* child, int zOrder, int tag);

            virtual void removeChild(CCNode *child);
            virtual void removeChild(CCNode *child, bool cleanup);

            void setHorizontalDirection(bool m_bvalue){m_bIsHorizontalDirection = m_bvalue;};
            
            bool getHorizontalDirection(){return m_bIsHorizontalDirection;};
            
            void setVerticalDirection(bool m_bvalue){m_bIsVerticalDirection = m_bvalue;};
            
            void setLineNodeSum(int m_sum){m_nLineNodeSum = m_sum;}
            
            int getLineNodeSum(){return m_nLineNodeSum ;}
            
            int getColumnNodeSum(){return m_nColumnNodeSum;}
            void setColumnNodeSum(int m_Value){m_nColumnNodeSum = m_Value;}

            
            
            bool getVerticalDirection(){return m_bIsVerticalDirection;};

            enumLayoutDirection getDirection(){ return m_eDirection; }
        protected:
            CCSize m_CellSize;
            int m_nRow;
            int m_nColumn;
            bool m_bIsHorizontalDirection;
            bool m_bIsVerticalDirection;
            
            int m_nLineNodeSum;
            int m_nColumnNodeSum;
            float m_fCellHorizontalSpace;   //水平间隔
            float m_fCellVerticalSpace;     //垂直间隔
            enumLayoutDirection m_eDirection;
            
        };
        
    }
}

#endif /* defined(__GameBox__Layout__) */
