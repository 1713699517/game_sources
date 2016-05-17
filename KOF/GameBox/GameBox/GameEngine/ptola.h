//
//  ptola.h
//  GameBox
//
//  Created by Caspar on 2013-4-23.
//
//

#ifndef GameBox_ptola_h
#define GameBox_ptola_h

#include "SharedPtr.h"

//#define MEMORY_MANAGE_OBJ       //

#ifdef MEMORY_MANAGE_OBJ

    #define MEMORY_MANAGE_OBJECT(_Ty) \
        public: \
            void operator delete(void *ptr);
//            void *operator new(size_t _size);\

    #define MEMORY_MANAGE_OBJECT_IMPL(_Ty) \
        void _Ty::operator delete(void *ptr){ \
            CCObject *pObject = (CCObject *)ptr; \
            if( pObject != NULL ){pObject->release();} \
        }

//ptola::memory::CMemoryAllocator::sharedMemoryAllocator()->deallocate##_Ty((_Ty *)ptr); };
        //void *_Ty::operator new(size_t _size){ return ptola::memory::CMemoryAllocator::sharedMemoryAllocator()->allocate##_Ty(); };

#else
    #define MEMORY_MANAGE_OBJECT(_Ty) ;
    #define MEMORY_MANAGE_OBJECT_IMPL(_Ty) ;
#endif

#define JOYSTICK_PLIST_FILE "Joystick/joystick.plist"


//#define MEMORY_MANAGE_OBJECT(_Ty) ;
/**
 * 本地版本,不更新指定位置的任何文件.
 * 发布时去掉
 */
#define LOCAL_VERSION

/**
 * 单机版本,调用hello.lua测试
 * 发布时去掉
 */
//#define SINGLE_VERSION
//=============================












//-----------------SDK相关

// /* 普通版本



// /* 553 Android版

// */


#endif
