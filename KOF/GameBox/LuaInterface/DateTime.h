
    class CDateTime : public cocos2d::CCObject
    {
    public:

        void reset();
        static CDateTime *create();
//        int getYears();
//        int getMonths();
//        int getDate();
//        int getHours();
//        int getMinutes();
//        int getSeconds();
//        int getMilliseconds();
//
//        int getTotalYears();
//        int getTotalMonths();
//        int getTotalDays();
//        int getTotalHours();
//        int getTotalMinutes();
        int getTotalSeconds();
//        int getTotalMilliseconds();
        long getMicroseconds();
        
        long getTotalMilliseconds();
    };