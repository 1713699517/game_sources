//
//  ILabel.h
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#ifndef GameBox_ILabel_h
#define GameBox_ILabel_h

#include "cocos2d.h"

USING_NS_CC;

namespace ptola
{
namespace gui
{

    class ILabel
    {
    public:
        virtual void setText(const char *lpcszText) = 0;
        virtual const char *getText() = 0;

        virtual ccColor4B getColor() = 0;
        virtual void setColor(ccColor4B &color) = 0;

        virtual float getFontSize() = 0;
        virtual void setFontSize(float fFontSize) = 0;

        virtual const char *getFontFamily() = 0;
        virtual void setFontFamily(const char *lpcszFontFamily) = 0;

        
    };

}
}

#endif
