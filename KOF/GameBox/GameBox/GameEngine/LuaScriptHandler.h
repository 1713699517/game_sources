//
//  LuaScriptHandler.h
//  GameBox
//
//  Created by Caspar on 2013-4-28.
//
//

#ifndef __GameBox__LuaScriptHandler__
#define __GameBox__LuaScriptHandler__

#include "cocos2d.h"
#include "CCLuaEngine.h"

USING_NS_CC;

namespace ptola
{
namespace script
{
    class CNetworkMessageScriptHandler : public CCScriptHandlerEntry
    {
    public:
        CNetworkMessageScriptHandler(int nHandler);
        static CNetworkMessageScriptHandler *create(int nHandler);
    };

    class CControlScriptHandler : public CCScriptHandlerEntry
    {
    public:
        CControlScriptHandler(int nHandler);
        static CControlScriptHandler *create(int nHandler);
    };
}
}


#endif /* defined(__GameBox__LuaScriptHandler__) */
