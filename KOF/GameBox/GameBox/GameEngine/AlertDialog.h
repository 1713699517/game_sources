//
//  AlertDialog.h
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#ifndef __GameBox__AlertDialog__
#define __GameBox__AlertDialog__

#include "FloatLayer.h"
#include "VerticalLayout.h"
#include "Button.h"

namespace ptola
{
namespace gui
{

    class CAlertDialog : public CFloatLayer
    {
    public:
        CAlertDialog();
        ~CAlertDialog();
        bool init(CCNode *pParent);

        static CAlertDialog *sharedAlertDialog();

        
        
        void appendMessage( const char *lpcszMessage );

        
        static CAlertDialog *create(CCSize &cellSize,enumLayoutDirection eDirection = eLD_Relative);
        bool init(CCSize &cellSize, enumLayoutDirection eDirection = eLD_Relative);
        
        void setVerticalLayout(CVerticalLayout *vLayout);
        CVerticalLayout *getVerticalLayout();
        
        float getDisplayTime();
        void setDisplayTime(float fTime);

        virtual unsigned int getChildrenCount();
        virtual CCArray *getChildren();
        
        //关闭按钮
        void closeCallBack(CCObject *pSender);
        void removeAlertDialog();
        
        virtual void addChild(CCNode *child);
        virtual void addChild(CCNode* child, int zOrder);
        virtual void addChild(CCNode* child, int zOrder, int tag);
        
        //2013.06.06  hlc 新增提示框大小
        void setAlertDialogSize(CCSize &size);
        const CCSize &getAlertDialogSize();
        
    private:
        CCNode *m_pParent;
        
        float m_fTime;
        CButton *m_pButtonClose;
        CVerticalLayout *m_pMessageLayout;
        //2013.06.06  hlc 新增提示框大小
        CCSize m_size;
    };
    
    
    
    inline void CAlertDialog::setVerticalLayout(CVerticalLayout *vLayout)
    {
        if(vLayout == m_pMessageLayout)
            return;
        m_pMessageLayout = vLayout;
    }
    
    inline CVerticalLayout *CAlertDialog::getVerticalLayout()
    {
        return m_pMessageLayout;
    }
    

}
}

#endif /* defined(__GameBox__AlertDialog__) */
