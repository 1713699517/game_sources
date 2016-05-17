    class CMemoryManager : public CCObject
    {
    public:

        static CMemoryManager *sharedMemoryManager();

        unsigned long long getFreeMemory();
        unsigned long long getTotalMemory();
        unsigned long long getUsedMemory(); 

        
        void startMemoryDetection();
        void stopMemoryDetection();
    };