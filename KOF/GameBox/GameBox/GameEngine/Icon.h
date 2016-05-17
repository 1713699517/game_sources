//
//  Icon.h
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#ifndef __GameBox__Icon__
#define __GameBox__Icon__
#include "UserControl.h"
USING_NS_CC;

namespace ptola
{
namespace gui
{

    class CIcon : public CUserControl
    {
    public:

        MEMORY_MANAGE_OBJECT(CIcon);
        
        CIcon();
        ~CIcon();

        CREATE_FUNC(CIcon);
        bool init();

        static CIcon* create(const char *lpcszResourceName);
        bool init(const char *lpcszResourceName);
        
        //还需实现动画效果
        static CIcon* createWithSpriteFrameName(const char *lpcszResourceName);
        bool initWithSpriteFrameName(const char *lpcszResourceName);
        
        void onTouchInside();

    public:
        virtual bool containsPoint(CCPoint *pPoint);
    protected:
        virtual CCNode *initialize(const char *lpcszResourceName);
    private://.ccbi
        CCNode *m_pSprite;
    };

}
}

#endif /* defined(__GameBox__Icon__) */
