//
//  UserCache.h
//  GameBox
//
//  Created by Caspar on 13-9-25.
//
//

#ifndef __GameBox__UserCache__
#define __GameBox__UserCache__

#include "cocos2d.h"

USING_NS_CC;

namespace ptola
{
    class CUserCache : public CCObject
    {
    public:
        static CUserCache *sharedUserCache();
        void setObject(const char *key, const char *value);
        const char *getObject(const char *key);
        void removeObject(const char *key);
    };
}

#endif /* defined(__GameBox__UserCache__) */
