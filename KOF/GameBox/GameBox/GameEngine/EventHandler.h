//
//  EventHandler.h
//  GameBox
//
//  Created by Caspar on 2013-5-10.
//
//

#ifndef __GameBox__EventHandler__
#define __GameBox__EventHandler__

#include "Event.h"
#include "ptola.h"

USING_NS_CC;

namespace ptola
{
namespace event
{

    typedef void (CCObject::*SEL_PtolaEventHandler)(CCObject *, CEvent *);

#define eventhandler_selector(SEL) ((SEL_PtolaEventHandler)(&SEL))

    class CEventHandler : public CCObject
    {
    public:
        MEMORY_MANAGE_OBJECT(CEventHandler);
        
        CEventHandler(CCObject *pTarget, SEL_PtolaEventHandler eventHandler);
        ~CEventHandler();

        bool operator==(const CEventHandler rhs);
        bool isEqual(CCObject *pTarget, SEL_PtolaEventHandler pHandlerFunc);

        static CEventHandler *create(CCObject *pTarget, SEL_PtolaEventHandler eventHandler);

        void invoke(CCObject *pObject, CEvent *pEvent);
    private:
        CCObject *m_pTarget;
        SEL_PtolaEventHandler m_pHandlerFunc;
    };

}
}
#endif /* defined(__GameBox__EventHandler__) */
