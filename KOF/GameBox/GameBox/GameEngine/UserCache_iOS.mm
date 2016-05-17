//
//  UserCache_iOS.mm
//  GameBox
//
//  Created by Caspar on 13-9-25.
//
//

#include "cocos2d.h"

#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#include "UserCache.h"
#include <map>

using namespace ptola;


static std::map<std::string, std::string> s_mapUserCache;

CUserCache *CUserCache::sharedUserCache()
{
    static CUserCache cache;
    return &cache;
}

const char *CUserCache::getObject(const char *key)
{
    std::map<std::string, std::string>::iterator it = s_mapUserCache.find(key);
    if( it == s_mapUserCache.end() )
    {
        return NULL;
    }
    else
    {
        return it->second.c_str();
    }
}

void CUserCache::removeObject(const char *key)
{
    s_mapUserCache.erase(key);
}

void CUserCache::setObject(const char *key, const char *value)
{
    s_mapUserCache[ key ] = value;
}

#endif
