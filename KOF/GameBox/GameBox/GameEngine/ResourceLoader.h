//
//  ResourceLoader.h
//  GameBox
//
//  Created by Caspar on 2013-5-16.
//
//

#ifndef __GameBox__ResourceLoader__
#define __GameBox__ResourceLoader__

#include "EventHandler.h"
#include "EventDispatcher.h"
#include "LuaEventDispatcher.h"

#include "misc/pthreadcc.h"

using namespace ptola::event;


#define EVENT_NAME_RESOURCE_LOADER_PROGRESS "LoadProgress"
#define EVENT_NAME_RESOURCE_LOADER_LOADCOMPLETE "LoadComplete"

namespace ptola
{
namespace resources
{

    class CResourceLoader : public CCObject
    {
    public:
        static CResourceLoader *sharedResourceLoader();

    public:
        CResourceLoader();
        ~CResourceLoader();

        void appendFile(const char *lpcszFile);
        void startLoad();
        bool isLoading();


        void clearUnusedResources();
    protected:
        void onLoaded();

    public: //eventListener
        virtual void addEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector);
        virtual void removeEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector);
        virtual void removeAllEventListener();
        virtual void dispatchEvent(CCObject *pSender, CEvent *pEvent);
        virtual bool hasEventListener(const char *lpcszEventName);
        virtual void removeEventListeners(const char *lpcszEventName);
    public: //lua eventListener
        virtual void addLuaEventListener(const char *lpcszEventName, int selector);
        virtual void removeLuaEventListener(const char *lpcszEventName, int selector);
        virtual void removeLuaAllEventListener();
        virtual void dispatchLuaEvent(const char *lpcszEventName, ...);
        virtual void dispatchLuaEvent(const char *lpcszEventName, std::vector<SLuaEventArg *> *args);
        virtual void dispatchLuaEvent(const char *lpcszEventName, int nLuaTable);
        virtual bool hasLuaEventListener(const char *lpcszEventName);
        virtual void removeLuaEventListeners(const char *lpcszEventName);
    private:
        void mainThreadProcess(float dt);
        
        bool m_bLoading;
        std::set<std::string> m_setLoadFiles;
        std::set<std::string> m_setLoadedFiles;
        size_t m_needToBeLoadCount;
        
        CEventDispatcher m_eventDispatcher;
        CLuaEventDispatcher m_luaEventDispatcher;
    };

}
}

#endif /* defined(__GameBox__ResourceLoader__) */
