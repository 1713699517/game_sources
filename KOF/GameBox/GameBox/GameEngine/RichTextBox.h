//
//  RichTextBox.h
//  GameBox
//
//  Created by Caspar on 2013-7-11.
//
//

#ifndef __GameBox__RichTextBox__
#define __GameBox__RichTextBox__

#include <iostream>
#include "RichTextView.h"
#include "UserControl.h"

namespace ptola
{
namespace gui
{

    class CRichTextBox : public CUserControl
    {
    public:
        MEMORY_MANAGE_OBJECT(CRichTextBox);
        CRichTextBox(const CCSize &_size, ccColor4B &_backgroundColor);
        ~CRichTextBox();

        void setBackgroundColor(ccColor4B &rColor);

        static CRichTextBox *create(const CCSize &_size, ccColor4B &_backgroundColor);
    public:
        virtual bool containsPoint( CCPoint *rPoint );

        virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
        virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
        virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);

        void scrollTo(const CCPoint &_scrollPoint);
        void scrollToBottom();
        void scrollToBottomNextFrame();
        CCSize &getScrollSize();
        CCPoint &getScrollPoint();
        void clearAll();

        void setAutoScrollDown(bool bAutoScrollDown);
        bool getAutoScrollDown();

        void setCurrentStyle(const char *lpcszFontFamily, float fFontSize, ccColor4B &color);

        void appendRichText(const char *lpcszData, const char *lpcszActionName = NULL, const char *Arg0 = NULL, const char *Arg1 = NULL, const char *Arg2 = NULL, const char *Arg3 = NULL , const char *Arg4 = NULL);

        void appendRichNode(const CCNode *lpcData, const char *lpcszActionName = NULL, const char *Arg0 = NULL, const char *Arg1 = NULL, const char *Arg2 = NULL, const char *Arg3 = NULL , const char *Arg4 = NULL);
        
    private:
        void onRichTextBoxCallBack(const CReactContent *pContent);
        CRichTextView *m_pRichTextView;
    };

}
}

#endif /* defined(__GameBox__RichTextBox__) */
