//
//  VerticalLayout.h
//  GameBox
//
//  Created by Caspar on 13-5-8.
//
//

#ifndef __GameBox__VerticalLayout__
#define __GameBox__VerticalLayout__

#include "Layout.h"

namespace ptola
{
namespace gui
{
    class CVerticalLayout : public CLayout
    {
    public:

        MEMORY_MANAGE_OBJECT(CVerticalLayout);
        
        CVerticalLayout();
        ~CVerticalLayout();
        
        bool init ();
        CREATE_FUNC(CVerticalLayout);
        virtual void addChild(CCNode *child);
        virtual void addChild(CCNode* child, int zOrder);
        virtual void addChild(CCNode* child, int zOrder, int tag);

        
        virtual bool performLayout();
        

        
    };

}
}
#endif /* defined(__GameBox__VerticalLayout__) */
