//
//  MemroyAllocator.h
//  GameBox
//
//  Created by Caspar on 13-7-3.
//
//

#ifndef __GameBox__MemroyAllocator__
#define __GameBox__MemroyAllocator__

#include "Button.h"
#include "AWebView.h"
#include "PageScrollView.h"
#include "CheckBox.h"
#include "Container.h"

#include "DynamicIcon.h"
#include "FloatLayer.h"
#include "HorizontalLayout.h"
#include "Icon.h"
#include "Layout.h"
#include "Menu.h"
#include "MovieClip.h"
#include "NCBar.h"
#include "PageTurn.h"
#include "RadioBox.h"
#include "ScreenTurn.h"
#include "Sprite.h"
#include "Tab.h"
#include "TabPage.h"
#include "Tips.h"
#include "UserControl.h"
#include "VerticalLayout.h"
#include "VolumeControl.h"
#include "Window.h"
#include "Slider.h"
#include "EditBox.h"

#include "DateTime.h"

#include "DataReader.h"
#include "DataWriter.h"
#include "FileStream.h"
#include "MemoryStream.h"


#include "Event.h"
#include "EventDispatcher.h"
#include "EventHandler.h"
#include "LuaEventDispatcher.h"

#include <iostream>
#include <set>

#define MEMORY_ALLOCATE(_Ty) \
private: \
    CObjectAllocator<_Ty> m_##_Ty##Allocator;\
public: \
    _Ty *allocate##_Ty(){ return m_##_Ty##Allocator.allocate(); };\
    void deallocate##_Ty( _Ty *ptr ){ m_##_Ty##Allocator.deallocate(ptr); };




using namespace ptola;
using namespace ptola::gui;
using namespace ptola::event;
USING_NS_CC;

namespace ptola
{
namespace memory
{

    template< typename _Ty >
    class CObjectAllocator
    {
    public:
        CObjectAllocator()
        {
            
        };
        ~CObjectAllocator()
        {
            clear();
        };

        _Ty *allocate()
        {
            _Ty *pRet = (_Ty *)malloc(sizeof(_Ty));
            //m_Pool.insert(pRet);
            return pRet;
        };

        void deallocate(_Ty *ptr)
        {
            //if( m_Pool.find(ptr) != m_Pool.end() )
            //{
            //    m_Pool.erase(ptr);
                free( ptr );
            //}
        };

        void clear()
        {
//            while( !m_Pool.empty() )
//            {
//                ::free( *m_Pool.begin() );
//                m_Pool.erase( m_Pool.begin() );
//            }
        };
    private:
        std::set<_Ty *> m_Pool;
    };

    class CMemoryAllocator
    {
        MEMORY_ALLOCATE(CButton);
        MEMORY_ALLOCATE(CWebView);
        MEMORY_ALLOCATE(CPageScrollView);
        MEMORY_ALLOCATE(CCheckBox);
        MEMORY_ALLOCATE(CContainer);
        //MEMORY_ALLOCATE(CDynamicIcon);
        MEMORY_ALLOCATE(CFloatLayer);
        MEMORY_ALLOCATE(CHorizontalLayout);
        MEMORY_ALLOCATE(CIcon);
        MEMORY_ALLOCATE(CLayout);
        MEMORY_ALLOCATE(CMenu);
        MEMORY_ALLOCATE(CMovieClip);
        MEMORY_ALLOCATE(CNCBar);
        MEMORY_ALLOCATE(CPageTurn);
        MEMORY_ALLOCATE(CRadioBox);
        MEMORY_ALLOCATE(CScreenTurn);
        MEMORY_ALLOCATE(CSprite);
        MEMORY_ALLOCATE(CTab);
        MEMORY_ALLOCATE(CTabPage);
        MEMORY_ALLOCATE(CTips);
        MEMORY_ALLOCATE(CUserControl);
        MEMORY_ALLOCATE(CVerticalLayout);
        MEMORY_ALLOCATE(CVolumeControl);
        MEMORY_ALLOCATE(CWindow);
        MEMORY_ALLOCATE(CSliderControl);
        MEMORY_ALLOCATE(CEditBox);


        MEMORY_ALLOCATE(CDateTime);

        MEMORY_ALLOCATE(CDataReader);
        MEMORY_ALLOCATE(CDataWriter);
        MEMORY_ALLOCATE(CFileStream);
        MEMORY_ALLOCATE(CMemoryStream);

        MEMORY_ALLOCATE(CEvent);
        MEMORY_ALLOCATE(CProgressEvent);
        MEMORY_ALLOCATE(CEventHandler);
        MEMORY_ALLOCATE(CEventDispatcher);
        MEMORY_ALLOCATE(CLuaEventDispatcher);
    public:
        static CMemoryAllocator *sharedMemoryAllocator();
        
    };

    
}
}

#endif /* defined(__GameBox__MemroyAllocator__) */
