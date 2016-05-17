//
//  Button.h
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#ifndef __GameBox__Button__
#define __GameBox__Button__

#include "cocos2d.h"
#include "cocos-ext.h"
#include "ILabel.h"
#include "UserControl.h"
#include "ptola.h"
#include "SpriteRGBA.h"

USING_NS_CC;
USING_NS_CC_EXT;

namespace ptola
{
namespace gui
{
    
    enum eTextAlignment
    {
        kTextAlignmentCenter = 0,
        kTextAlignmentLeft = 1,
        kTextAlignmentRight = 2
    };

    class CButton : public CUserControl, ILabel
    {
    public:
        CButton();
        ~CButton();

        MEMORY_MANAGE_OBJECT(CButton);

        //06.14 hlc  增加一个文字左右中对齐的方法 add
        void setVerticalAlignment(eTextAlignment textAlignment);
        eTextAlignment getVerticalAlignment();
        //06.14 end
        
        virtual void setText(const char *lpcszText);
        virtual const char *getText();
                
        virtual ccColor4B getColor();
        virtual void setColor(ccColor4B &color);

        virtual float getFontSize();
        virtual void setFontSize(float fFontSize);

        virtual const char *getFontFamily();
        virtual void setFontFamily(const char *lpcszFontFamily);

        bool getChecked();
        void setChecked(bool bChecked);
        

        static CButton* create(CCLabelTTF* label, CSpriteRGBA* backgroundSprite);
        virtual bool initWithFile(CCLabelTTF* label, CSpriteRGBA* backgroundSprite);
        
        static CButton* create(CCLabelTTF* label, CSpriteRGBA* backgroundSprite, CCLabelTTF* checkedLabel, CSpriteRGBA* checkedBackgroundSprite, bool bDefaultChecked=false);
        virtual bool initWithFile(CCLabelTTF* label, CSpriteRGBA* backgroundSprite, CCLabelTTF* checkedLabel, CSpriteRGBA* checkedBackgroundSprite, bool bDefaultChecked=false);
        
        
        static CButton* create(const char *normalLabel,const char *normolBackGroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite, bool bDefaultChecked=false);
        virtual bool initWithFile(const char *normalLabel,const char *normolBackGroundSprite,const char * checkedLabel,const char *checkedBackGroundSprite, bool bDefaultChecked=false);

        static CButton* create(const char *normalLabel,const char *normolBackGroundSprite);
        virtual bool initWithFile(const char *normalLabel,const char *normolBackGroundSprite);


        static CButton* createWithSpriteFrameName(const char *normalLabel,const char *normolBackGroundSprite);
        virtual bool initWithSpriteFrameName(const char *normalLabel,const char *normolBackGroundSprite);

        static CButton *createWithSpriteFrameName(const char *normalLabel, const char *normalBackgroundSprite, const char *checkedLabel, const char *checkedBackGroundSprite, bool bDefaultChecked=false);
        virtual bool initWithSpriteFrameName(const char *normalLabel, const char *normalBackgroundSprite, const char *checkedLabel, const char *checkedBackGroundSprite, bool bDefaultChecked=false);

        virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
        virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
        
        virtual const CCSize &getContentSize();
        
        virtual bool containsPoint(CCPoint *pGLPoint);

        virtual void onTouchInside();
        
        void setPreferredSize( const CCSize &size );
        CCSize &getPreferredSize();

        virtual void setTouchesEnabled(bool bTouchEnabled);
    public:
        void setHightLight();
        void setDefault();
        void setDark();
        void setGray();
        void setPressed();
        
    private:
        void onLayout();
        CCSize m_sizePreferedSize;
        bool m_bChecked;
        CCLabelTTF *m_pLabel;
        CSpriteRGBA *m_pBackground;
        CCLabelTTF *m_pCheckedLabel;
        CSpriteRGBA *m_pCheckBackground;
        
        eTextAlignment m_eTextAlignment;
        
//        CCControlButton *m_pNormalButton;
//        CCControlButton *m_pCheckedButton;
    };

}
}

#endif /* defined(__GameBox__Button__) */
