//
//  Menu.h
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#ifndef __GameBox__Menu__
#define __GameBox__Menu__

#include "Layout.h"
#include "FloatLayer.h"
#include "HorizontalLayout.h"
#include "VerticalLayout.h"
#include "Button.h"
#include "ptola.h"

namespace ptola
{
namespace gui
{
 
        class CMenu : public CFloatLayer
        {
            public:

            MEMORY_MANAGE_OBJECT(CMenu);
            
                CMenu();
                ~CMenu();
                
                static CMenu *create(CCSize& cellSize, enumLayoutDirection eDirection,CCScale9Sprite* bg_Spirte);
                

                bool init(CCSize& cellSize, enumLayoutDirection eDirection,CCScale9Sprite* bg_Spirte);

                
                virtual unsigned int getChildrenCount();
                virtual CCArray *getChildren();
                
                virtual void addChild(CCNode *child);
                virtual void addChild(CCNode* child, int zOrder);
                virtual void addChild(CCNode* child, int zOrder, int tag);
            
                CCSize* getMenuSize() {return m_pCellSize;};
                void setMenuSize(CCSize* mSize) {m_pCellSize =  mSize;};
            
                CLayout * getLayout(){return m_pContainer;};
                void setLayout(CLayout *m_Layout) {m_pContainer = m_Layout;};
            
                
            virtual void show(CCNode *pParent, const CCPoint &pos, enumActionType eActionType = eAT_None);
            
            
            virtual void show(CCNode *pParent, float fx, float fy, enumActionType eActionType = eAT_None);
            
            virtual void hide(enumActionType eActionType = eAT_None);
            
            
            void actionCallback();
            
            private:
                CLayout *m_pContainer;
                CCSize *m_pCellSize;
            CCScale9Sprite* m_pSprite;

            
            };

}
}

#endif /* defined(__GameBox__Menu__) */
