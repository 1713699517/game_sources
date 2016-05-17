//
//  LuaEventDispatcher.h
//  GameBox
//
//  Created by Caspar on 2013-5-10.
//
//

#ifndef __GameBox__LuaEventDispatcher__
#define __GameBox__LuaEventDispatcher__

#include "cocos2d.h"
#include "ptola.h"
USING_NS_CC;

namespace ptola
{
namespace event
{

    enum enumLuaEventArgType
    {
         eLEAT_Int
        ,eLEAT_Number
        ,eLEAT_String
    };

    struct SLuaEventArg
    {
        SLuaEventArg(){}

        SLuaEventArg(int nValue)
        : nIntValue(nValue)
        , argType(eLEAT_Int)
        {

        }

        SLuaEventArg(float fValue)
        : dNumberValue((double)fValue)
        , argType(eLEAT_Number)
        {

        }

        SLuaEventArg(double dValue)
        : dNumberValue(dValue)
        , argType(eLEAT_Number)
        {

        }

        SLuaEventArg(const char *lpcszValue)
        : lpcszStringValue(lpcszValue)
        , argType(eLEAT_String)
        {

        }

        SLuaEventArg(const SLuaEventArg &rhs)
        : argType(rhs.argType)
        {
            switch(rhs.argType)
            {
                case eLEAT_Int: nIntValue = rhs.nIntValue; break;
                case eLEAT_Number: dNumberValue = rhs.dNumberValue; break;
                case eLEAT_String: lpcszStringValue = rhs.lpcszStringValue; break;
            }
        }
        union
        {
            int nIntValue;
            double dNumberValue;
            const char *lpcszStringValue;
        };
        enumLuaEventArgType argType;
    };

    class CLuaEventDispatcher : public CCObject
    {
    public:
        MEMORY_MANAGE_OBJECT(CLuaEventDispatcher);
        
        CLuaEventDispatcher();
        ~CLuaEventDispatcher();
    public:
        void addEventListener(const char *lpcszEventName, int selector);
        void removeEventListener(const char *lpcszEventName, int selector);
        void removeAllEventListener();
        void removeEventListeners(const char *lpcszEventName);
        void dispatchEvent(const char *lpcszEventName, ...);
        void dispatchEvent(const char *lpcszEventName, std::vector<SLuaEventArg *> *vecArgs);
        void dispatchEvent(const char *lpcszEventName, int nLuaTable);
        bool hasEventListener(const char *lpcszEventName);

    private:
        CCDictionary *m_pDict;
    };

}
}

#endif /* defined(__GameBox__LuaEventDispatcher__) */
