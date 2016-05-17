//
//  MemoryManager.cpp
//  GameBox
//
//  Created by wrc on 13-6-21.
//
//
#include "MemoryManager.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <iostream>
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

using namespace std;
using namespace ptola::memory;
using namespace ptola;



CMemoryManager::CMemoryManager()
: m_nCurrentLevel(0)
//: m_uTotalMemory(0)
//, m_uFreeMemory(0)
//, m_uUsedMemory(0)
{
//    CCLOG("Andorid~CMemoryManager");
}

CMemoryManager::~CMemoryManager()
{

}

CMemoryManager *CMemoryManager::sharedMemoryManager()
{
    static CMemoryManager theMemoryManager;
    return &theMemoryManager;
}

unsigned long long CMemoryManager::getTotalMemory()       //获取所有内存
{
    
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameMemoryManager", "getTotalMemory", "()J") )
    {
        jlong ret = methodInfo.env->CallStaticLongMethod(methodInfo.classID, methodInfo.methodID);
        return (unsigned long long)ret;
    }
    else
    {
        CCLOG("CMemoryManager::getTotalMemory method missed!");
        return 0UL;
    }
    //return m_uTotalMemory;
}



unsigned long long CMemoryManager::getFreeMemory()       //获取可用内存
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameMemoryManager", "getFreeMemory", "()J") )
    {
        jlong ret = methodInfo.env->CallStaticLongMethod(methodInfo.classID, methodInfo.methodID);
        
        return (unsigned long long)ret;
    }
    else
    {
        CCLOG("CMemoryManager::getFreeMemory method missed!");
        return 0UL;
    }
    
    //return m_uFreeMemory;
}

unsigned long long CMemoryManager::getUsedMemory()       //获取当前进程使用内存
{
    JniMethodInfo methodInfo;
    if( JniHelper::getStaticMethodInfo(methodInfo, "com/ptola/GameMemoryManager", "getUsedMemory", "()J") )
    {
        jlong ret = methodInfo.env->CallStaticLongMethod(methodInfo.classID, methodInfo.methodID);
        return (unsigned long long)ret;
    }
    else
    {
        CCLOG("CMemoryManager::getUsedMemory method missed!");
        return 0UL;
    }
    
    //return m_uUsedMemory;
}


void CMemoryManager::setMaxMemoryThreshold(size_t uMaxMemoryThreshold)
{
//    m_uTotalMemory = 80 * 1024 * 1024 * 1024;
}






#endif //CC_PLATFORM_ANDROID