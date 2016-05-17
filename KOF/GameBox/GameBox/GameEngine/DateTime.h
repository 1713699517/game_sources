//
//  DateTime.h
//  GameBox
//
//  Created by Caspar on 2013-5-7.
//
//

#ifndef __GameBox__DateTime__
#define __GameBox__DateTime__

#include "cocos2d.h"
#include "ptola.h"

namespace ptola
{
    class CDateTime : public cocos2d::CCObject
    {
    public:
        MEMORY_MANAGE_OBJECT(CDateTime);

        CDateTime();
        ~CDateTime();

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
    private:
        cocos2d::cc_timeval m_DateTime;
    };
}

#endif /* defined(__GameBox__DateTime__) */
