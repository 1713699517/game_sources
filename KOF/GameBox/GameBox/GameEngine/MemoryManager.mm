//
//  MemoryManager.mm
//  GameBox
//
//  Created by Caspar on 2013-6-22.
//
//


#include "MemoryManager.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#import <sys/sysctl.h>
#import <mach/mach.h>
#import <Foundation/NSProcessInfo.h>

using namespace ptola::memory;

BOOL memoryInfo(vm_statistics_data_t *vmStats)
{
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)vmStats, &infoCount);
    
    return kernReturn == KERN_SUCCESS;
}



CMemoryManager::CMemoryManager()
: m_nCurrentLevel(0)
{
//    CCLOG("ios ~ MemoryManager");
//    
//    vm_statistics_data_t t;
//    
//    if (memoryInfo(&t))
//    {
//        m_uFreeMemory = t.free_count * vm_page_size;
//        
//        m_uTotalMemory = m_uFreeMemory + (t.active_count  + t.inactive_count +t.wire_count) * vm_page_size ;
//        
//    }
//    
//    //获取当前任务所占用得内存(单位字节)
//    task_basic_info_data_t taskInfo;
//    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
//    
//    kern_return_t kernReturn = task_info(mach_task_self(),
//                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
//    if(kernReturn != KERN_SUCCESS)
//    {
//        m_uUsedMemory = NSNotFound;
//    }
//    m_uUsedMemory = taskInfo.resident_size;

    
}

CMemoryManager::~CMemoryManager()
{
//    m_uFreeMemory = 0;
//    m_uUsedMemory = 0;
//    m_uTotalMemory = 0;
}

CMemoryManager *CMemoryManager::sharedMemoryManager()
{
    static CMemoryManager theMemoryManager;
    return &theMemoryManager;
}

unsigned long long CMemoryManager::getTotalMemory()
{
    return [[NSProcessInfo processInfo] physicalMemory];
}

unsigned long long CMemoryManager::getFreeMemory()       //获取可用内存
{
    mach_port_t host_port;
    mach_msg_type_number_t infoCount;
    vm_size_t pageSize;

    host_port = mach_host_self();
    infoCount = HOST_VM_INFO_COUNT;
    host_page_size(host_port, &pageSize);
    
    vm_statistics_data_t vm_stat;
    if( host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &infoCount) != KERN_SUCCESS )
    {
        return 0U;
    }
    else
    {
        return pageSize * vm_stat.free_count;
    }
       
    //return m_uFreeMemory;
}

unsigned long long CMemoryManager::getUsedMemory()       //获取当前进程使用内存
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    if( task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount) != KERN_SUCCESS)
    {
        return 0U;
    }
    else
    {
        return taskInfo.resident_size;
    }
    
    //return m_uUsedMemory;
}

void CMemoryManager::setMaxMemoryThreshold(size_t uMaxMemoryThreshold)
{
    //m_uTotalMemory = 80 * 1024 * 1024 * 1024;
}


#endif