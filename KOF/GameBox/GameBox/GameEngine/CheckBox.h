//
//  CheckBox.h
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#ifndef __GameBox__CheckBox__
#define __GameBox__CheckBox__

#include "UserControl.h"
#include "ILabel.h"
#include "HorizontalLayout.h"
#include "Button.h"
#include "Sprite.h"
#include "ptola.h"

namespace ptola
{
namespace gui
{

    class CCheckBox : public CUserControl, public ILabel
    {
    public:

        MEMORY_MANAGE_OBJECT(CCheckBox);
        
        CCheckBox();
        ~CCheckBox();

        //2013.07.02 hlc   add 添加支持读取plist图片的方法
        
        static CCheckBox *create(CSprite *pNormalImg, CSprite *pCheckedImg, CCLabelTTF *pLabel, enumTextAlign align);
        bool initWithFile(CSprite *pNormalImg, CSprite *pCheckedImg, CCLabelTTF *pLabel, enumTextAlign align);
        
        static CCheckBox *createWithSpriteFrameName(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText,enumTextAlign align);
        bool initWithFile(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText,enumTextAlign align);

        //2013.07.02end
        
        static CCheckBox *create(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText);
        
        static CCheckBox *create(const char*lpcszNormalName,const char *lpcszCheckedSprite,const char*lpcszText,enumTextAlign align);
        
        
        bool initWithParameters(const char *lpcszNormalName,const char *lpcszCheckedSprite,const char *lpcszText);
        
        bool initWithParameters(const char *lpcszNormalName,const char *lpcszCheckedSprite,const char *lpcszText,enumTextAlign align);

        virtual bool getChecked();
        virtual void setChecked(bool bChecked);

        enumTextAlign getTextAlign();
        void setTextAlign(enumTextAlign align);

        virtual CCLabelTTF *getLabel();

        virtual const char *getText();
        virtual void setText(const char *lpcszText);

        virtual ccColor4B getColor();
        virtual void setColor(ccColor4B &color);

        virtual const char *getFontFamily();
        virtual void setFontFamily(const char *lpcszFontFamily);

        virtual float getFontSize();
        virtual void setFontSize(float fFontSize);
        
        const char *getGroupName();
        void setGroupName(const char *lpcszGroupName);
        
    public:
        virtual bool containsPoint(CCPoint *pGLPoint);
        
        virtual void onTouchInside();
        
        
        
        virtual void performStateChanged();
    private:

        CSprite *m_pNormalSprite;
        CSprite *m_pCheckedSprite;
        CCLabelTTF *m_pTextLabel;
        bool m_bCheckState;
        
        enumTextAlign m_eTextAlign;
        
        string m_strGroupName;
        
    };

}
}

#endif /* defined(__GameBox__CheckBox__) */
