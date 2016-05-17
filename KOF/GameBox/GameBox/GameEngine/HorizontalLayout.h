//
//  HorizontalLayout.h
//  GameBox
//
//  Created by Capsar on 2013-5-8.
//
//

#ifndef __GameBox__HorizontalLayout__
#define __GameBox__HorizontalLayout__

#include "Layout.h"
#include "ptola.h"

using namespace std;

namespace ptola
{
namespace gui
{
    class CHorizontalLayout : public CLayout
    {
    public:

        MEMORY_MANAGE_OBJECT(CHorizontalLayout);
        
        CHorizontalLayout();
        ~CHorizontalLayout();
        virtual bool performLayout();
        
        CREATE_FUNC(CHorizontalLayout);
        

        bool init();
        
        virtual void addChild(CCNode *child);
        virtual void addChild(CCNode* child, int zOrder);
        virtual void addChild(CCNode* child, int zOrder, int tag);


    };
}
}

#endif /* defined(__GameBox__HorizontalLayout__) */
