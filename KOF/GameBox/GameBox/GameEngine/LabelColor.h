//
//  LabelColor.h
//  GameBox
//
//  Created by Caspar on 13-7-29.
//
//

#ifndef __GameBox__LabelColor__
#define __GameBox__LabelColor__

#include "UserControl.h"

namespace ptola
{
namespace gui
{

    class CLabelColor : public CUserControl
    {
    public:
        static CLabelColor *create();
        
        bool init();

        void appendText(const char *pText, const ccColor4B &pColor, const char *lpcszFamilyName, float fFontSize);

        void appendText(const char *pText, const char *lpcszFamilyName, float fFontSize);
    private:
        void performLayout();
        float m_fPosX;
        int m_nCount;
    };

}
}
#endif /* defined(__GameBox__LabelColor__) */
