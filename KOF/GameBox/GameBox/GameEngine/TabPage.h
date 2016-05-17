//
//  TabPage.h
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#ifndef __GameBox__TabPage__
#define __GameBox__TabPage__

#include "Button.h"
#include "Container.h"
#include "Tab.h"
#include "ptola.h"

namespace ptola
{
namespace gui
{
    class CTab;
    class CTabPage : public CButton
    {
    public:

        MEMORY_MANAGE_OBJECT(CTabPage);
        
        CTabPage();
        ~CTabPage();

        static CTabPage* create(const char *normalLabel,const char *normalBackgroundSprite);
        static CTabPage* create(const char *normalLabel,const char *normalBackgroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite);

        static CTabPage *createWithSpriteFrameName(const char *normalLabel, const char *normalBackgroundSprite);
        static CTabPage *createWithSpriteFrameName(const char *normalLabel,const char *normalBackgroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite);

        const CContainer *getContainer();
        void setContainer(const CContainer *pContainer);

        virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);


        bool initWithSpriteFrameName(const char *normalLabel,const char *normalBackgroundSprite,const char *checkedLabel,const char *checkedBackGroundSprite);

        bool initWithFile(const char *normalLabel,const char *normalBackgroundSprite);
        bool initWithFile(const char *normalLabel,const char *normalBackgroundSprite,const char *checkedLabel,const char *checkedBackGroundSprite);

        CTab *getTab();

    private:
        const CContainer *m_pContainer;

    };

}
}

#endif /* defined(__GameBox__TabPage__) */
