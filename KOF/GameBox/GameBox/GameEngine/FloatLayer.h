//
//  FloatLayer.h
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#ifndef __GameBox__FloatLayer__
#define __GameBox__FloatLayer__

#include "UserControl.h"
#include "ptola.h"
#include "Layout.h"
namespace ptola
{
namespace gui
{

    enum enumActionType
    {
        eAT_None = 0
        ,eAT_FadeIn         //淡入
        ,eAT_FadeOut        //淡出
        ,eAT_MoveBy_Left         //从右往左移动
        ,eAT_MoveBy_Right       //从左往右移动
        ,eAT_MoveBy_Up          //从下往上移动
        ,eAT_MoveBy_Down        //从上往下移动
    };

    class CFloatLayer : public CUserControl
    {
    public:

        MEMORY_MANAGE_OBJECT(CFloatLayer);
        
        CFloatLayer();
        ~CFloatLayer();

        CREATE_FUNC(CFloatLayer);
        bool init();
        virtual void show(CCNode *pParent, const CCPoint &pos, enumActionType eActionType = eAT_None);
        virtual void show(CCNode *pParent, float fx, float fy, enumActionType eActionType = eAT_None);
        
        void OpenBookCallBack();
        
        virtual void hide(enumActionType eActionType = eAT_None);
    protected:
        virtual CCAction *getActionByType(enumActionType eActionType);

    private:
        
        void actionCallback();
        //CCLabelTTF * m_b;
    };

}
}

#endif /* defined(__GameBox__FloatLayer__) */
