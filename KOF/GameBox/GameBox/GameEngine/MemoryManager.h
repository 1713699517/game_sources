//
//  MemoryManager.h
//  GameBox
//
//  Created by wrc on 13-6-21.
//
//

#ifndef __GameBox__MemoryManager__
#define __GameBox__MemoryManager__

#include "cocos2d.h"
#include "NotificationConstant.h"
USING_NS_CC;

namespace ptola
{
namespace memory
{

    class CMemoryManager : public CCObject
    {
    public:
        CMemoryManager();
        ~CMemoryManager();

        static CMemoryManager *sharedMemoryManager();

        unsigned long long getFreeMemory();       //获取可用内存
        unsigned long long getTotalMemory();      //获取全部内存
        unsigned long long getUsedMemory();       //获取当前进程使用内存

        void setMaxMemoryThreshold(size_t uMaxMemoryThreshold);
        
        void startMemoryDetection()
        {
            CCDirector::sharedDirector()->getScheduler()->scheduleSelector( schedule_selector( CMemoryManager::mainThreadMemoryDetection), this, 2.0f, false);
        };
        void stopMemoryDetection()
        {
            CCDirector::sharedDirector()->getScheduler()->unscheduleSelector( schedule_selector(CMemoryManager::mainThreadMemoryDetection), this);
        };

    private:
        int m_nCurrentLevel;
        void mainThreadMemoryDetection(float dt)
        {
            unsigned long long _usedm = getUsedMemory();
            unsigned long long _freem = getFreeMemory();
            float fUsedPercent = (float)(_usedm / 1024) / (float)((_usedm + _freem) / 1024);
            //lCCLOG("current--used %.2f", fUsedPercent);

            CCFloat cf(fUsedPercent);
            CCNotificationCenter::sharedNotificationCenter()->postNotification(MEMORYWARN_MESSAGE, &cf);
            //
//            CCInteger myInt(2);
//            CCNotificationCenter::sharedNotificationCenter()->postNotification(MEMORYWARN_MESSAGE, &myInt);
        };
    };
}
}

#endif /* defined(__GameBox__MemoryManager__) */
