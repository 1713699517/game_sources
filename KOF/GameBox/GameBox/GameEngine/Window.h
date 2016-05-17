//
//  Window.h
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#ifndef __GameBox__Window__
#define __GameBox__Window__

#include "FloatLayer.h"
#include "Container.h"
#include "NCBar.h"
#include "ptola.h"

namespace ptola
{
namespace gui
{

    class CWindow : public CFloatLayer
    {
    public:

        MEMORY_MANAGE_OBJECT(CWindow);
        
        CWindow();
        ~CWindow();
        
        //06.06 hlc add begin--
        
        /*
         @ 对应参数： 窗口名字， 窗口背景图， 窗口title背景， 关闭按钮， 传入容器, 是否显示bar(false为不显示)
         */
        static CWindow *create(CCLabelTTF *pLabel, CSprite *pBackground, CSprite *pBarBackground, CButton *pCloseBtn, CContainer *pContainer, bool bDefaultBar = true);
        virtual bool initWithFile(CCLabelTTF *pLabel, CSprite *pBackground, CSprite *pBarBackground, CButton *pCloseBtn, CContainer *pContainer, bool bDefaultBar = true);
        
        static CWindow *create(const char *lpcszTitle, const char *lpcszBackground, const char *lpcszBarBackground, const char *lpcszClose, CContainer *pContainer, bool bDefaultBar = true);
        virtual bool initWithFile(const char *lpcszTitle, const char *lpcszBackground, const char *lpcszBarBackground,const char *lpcszClose, CContainer *pContainer, bool bDefaultBar = true);
        
        static CWindow *createWithSpriteFrameName(const char *lpcszTitle, const char *lpcszBackground, const char *lpcszBarBackground,const char *lpcszClose, CContainer *pContainer, bool bDefaultBar = true);
        virtual bool initWithFrameName(const char *lpcszTitle, const char *lpcszBackground, const char *lpcszBarBackground,const char *lpcszClose, CContainer *pContainer, bool bDefaultBar = true);
        
        //06.13 add 增加新的不显示bar窗口创建函数
        static CWindow *create(CSprite *pBackground, CButton *pCloseBtn, CContainer *pContainer);
        virtual bool initWithFile(CSprite *pBackground, CButton *pCloseBtn, CContainer *pContainer);
        
        static CWindow *create(const char *lpcszBackground, const char *lpcszClose, CContainer *pContainer);
        virtual bool initWithFile(const char *lpcszBackground, const char *lpcszClose, CContainer *pContainer);
        
        static CWindow *createWithSpriteFrameName(const char *lpcszBackground, const char *lpcszClose, CContainer *pContainer);
        virtual bool initWithFrameName(const char *lpcszBackground, const char *lpcszClose, CContainer *pContainer);
        //06.13 end
        
        
        void setWindowTitle(const char *lpcszInputTitle);
        const char *getWindowTitle();
        
        void closeCallback(CCObject *pSender);
        //end--
        
        CCScene *getFullScreenScene();
        
        
    public:
        //
        virtual unsigned int getChildrenCount();
        virtual CCArray *getChildren();

        virtual void addChild(CCNode *child);
        virtual void addChild(CCNode* child, int zOrder);
        virtual void addChild(CCNode* child, int zOrder, int tag);
    private:
        CNCBar *m_pNCBar;
        CContainer *m_pContainer;
        CCScene *m_pScene;
        
    };

}
}

#endif /* defined(__GameBox__Window__) */
