
    class CDateTime : public CCObject
    {
    public:

        void reset();
        static CDateTime *create();

        int getTotalSeconds();
        long getMicroseconds();
        
        long getTotalMilliseconds();
    };