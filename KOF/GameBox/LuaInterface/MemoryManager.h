    class CMemoryManager : public CCObject
    {
    public:

        static CMemoryManager *sharedMemoryManager();

        unsigned long long getFreeMemory();       //获取可用内存
        unsigned long long getTotalMemory();      //获取全部内存
        unsigned long long getUsedMemory();       //获取当前进程使用内存

        
        void startMemoryDetection();
        void stopMemoryDetection();
    };