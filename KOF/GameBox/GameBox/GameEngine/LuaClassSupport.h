//
//  LuaClassSupport.h
//  GameBox
//
//  Created by Caspar on 2013-5-3.
//
//

#ifndef __GameBox__LuaClassSupport__
#define __GameBox__LuaClassSupport__

#include "CCLuaEngine.h"

namespace ptola
{
namespace script
{

    class CLuaClassSupport
    {
    public:
        static void initialize(cocos2d::CCLuaEngine *pEngine);
    };

}
}

#endif /* defined(__GameBox__LuaClassSupport__) */
