//
//  EventDispatcher.h
//  GameBox
//
//  Created by Caspar on 2013-5-10.
//
//

#ifndef __GameBox__EventDispatcher__
#define __GameBox__EventDispatcher__

#include "EventHandler.h"
#include "ptola.h"

USING_NS_CC;

namespace ptola
{
namespace event
{

    class CEventDispatcher : public CCObject
    {
    public:
        MEMORY_MANAGE_OBJECT(CEventDispatcher);
        
        CEventDispatcher();
        ~CEventDispatcher();

        void addEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector);
        void removeEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector);
        void removeEventListeners(const char *lpcszEventName);
        void removeAllEventListener();
        void dispatchEvent(CCObject *pSender, CEvent *pEvent);
        bool hasEventListener(const char *lpcszEventName);
    private:
        CCDictionary *m_pDict;
    };

}
}
#endif /* defined(__GameBox__EventDispatcher__) */
