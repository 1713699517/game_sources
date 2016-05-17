//
//  NCBar.h
//  GameBox
//
//  Created by Caspar on 13-5-9.
//
//

#ifndef __GameBox__NCBar__
#define __GameBox__NCBar__

#include "Button.h"
#include "Sprite.h"
#include "ptola.h"

namespace ptola
{
namespace gui
{

    class CNCBar : public CUserControl, public ILabel
    {
    public:

        MEMORY_MANAGE_OBJECT(CNCBar);
        
        CNCBar();
        ~CNCBar();
        CREATE_FUNC(CNCBar);
        bool init();
    public:


        
        static CNCBar *create(CCLabelTTF *pLabel, CButton *pBtn, CSprite *pSprite);
        virtual bool initWithFile(CCLabelTTF *pLabel, CButton *pBtn, CSprite *pSprite);
        
        static CNCBar *create(const char *lpcszLabel, const char *lpcszBtn, const char *lpcszSprite);
        virtual bool initWithFile(const char *lpcszLabel, const char *lpcszBtn, const char *lpcszSprite);
        
        static CNCBar *createWithSpriteFrameName(const char *lpcszLabel, const char *lpcszBtn, const char *lpcszSprite);
        virtual bool initWithSpriteFrameName(const char *lpcszLabel, const char *lpcszBtn, const char *lpcszSprite);
        
        void setBackgroundSprite(CSprite *pBackground);
        CSprite *getBackgroundSprite();
        
        void setCloseButton(CButton *pButton);
        CButton *getCloseButton();
        
        
        void setPreferredSize( const CCSize &size );
        CCSize &getPreferredSize();
        
        void menuCallBack(CCObject *pSender);
        //---
        
        virtual void setText(const char *lpcszText);
        virtual const char *getText();

        virtual ccColor4B getColor();
        virtual void setColor(ccColor4B &color);

        virtual float getFontSize();
        virtual void setFontSize(float fFontSize);

        virtual const char *getFontFamily();
        virtual void setFontFamily(const char *lpcszFontFamily);

    private:
        CCLabelTTF *m_pTitle;
        CButton *m_pButton;
        CSprite *m_pBackground;
        
        CCSize m_sizePreferedSize;
    };

}
}

#endif /* defined(__GameBox__NCBar__) */
