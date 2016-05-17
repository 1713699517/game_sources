//
//  Tips.h
//  GameBox
//
//  Created by wrc on 13-5-9.
//
//

#ifndef __GameBox__Tips__
#define __GameBox__Tips__

#include "Layout.h"
#include "FloatLayer.h"
#include "CCScale9Sprite.h"

USING_NS_CC;
using namespace cocos2d::extension;
namespace ptola
{
namespace gui
{

    class CTips : public CFloatLayer
    {
    public:

        MEMORY_MANAGE_OBJECT(CTips);
        
        CTips();
        ~CTips();

        //        CREATE_FUNC(CTips);
  //      bool init();

        static CTips *create(CCSize &cellSize, enumLayoutDirection eDirection,CCScale9Sprite* bg_Sprite);
        bool init(CCSize &cellSize, enumLayoutDirection eDirection,CCScale9Sprite* bg_Sprite);

        virtual unsigned int getChildrenCount();
        virtual CCArray *getChildren();

        virtual void addChild(CCNode *child);
        virtual void addChild(CCNode* child, int zOrder);
        virtual void addChild(CCNode* child, int zOrder, int tag);
        
        CLayout * getLayout(){return m_pContainer;};
        void setLayout(CLayout *m_Layout) {m_pContainer = m_Layout;};
        
    private:
        CLayout *m_pContainer;
        CCScale9Sprite* m_pSprite;
    };
}
}

#endif /* defined(__GameBox__Tips__) */
