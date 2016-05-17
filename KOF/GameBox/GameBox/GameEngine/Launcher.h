//
//  Launcher.h
//  GameBox
//
//  Created by Caspar on 2013-5-22.
//
//

#ifndef GameBox_Launcher_h
#define GameBox_Launcher_h

#include "cocos2d.h"
#include "EventDispatcher.h"

#include "misc/pthreadcc.h"

USING_NS_CC;

using namespace ptola::event;

namespace ptola
{
namespace update
{

    class CLauncher : public CCObject, private ThreadBase
    {
    public:
        CLauncher();
        ~CLauncher();

        static CLauncher *sharedLauncher();
        
        static bool hasVersionFile();

    public:
        bool copyAssetToResource();

        void purgeLauncher();

    protected:
        virtual void *          Execute();
        virtual void            CleanUp();

    public: //eventListener
        virtual void addEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector);
        virtual void removeEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector);
        virtual void removeAllEventListener();
        virtual void dispatchEvent(CCObject *pSender, CEvent *pEvent);
        virtual bool hasEventListener(const char *lpcszEventName);
        virtual void removeEventListeners(const char *lpcszEventName);
    private:
        CEventDispatcher m_eventDispatcher;
    };

}
}

#endif
