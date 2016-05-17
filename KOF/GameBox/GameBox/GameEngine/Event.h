//
//  Event.h
//  GameBox
//
//  Created by Caspar on 2013-5-10.
//
//

#ifndef __GameBox__Event__
#define __GameBox__Event__

#include "cocos2d.h"
#include "ptola.h"

USING_NS_CC;

namespace ptola
{
namespace event
{

    class CEvent : public CCObject
    {
    public:
        MEMORY_MANAGE_OBJECT(CEvent);
        CEvent(const char *lpcszEventName, CCObject *lpTarget, CCObject *lpData);
        ~CEvent();
    public:
        static CEvent *create(const char *lpcszEventName, CCObject *lpTarget, CCObject *lpData );
        bool init(const char *lpcszEventName, CCObject *lpTarget, CCObject *lpData );

        const char *getEventName();
        bool getHandled();
        void stopPropagation();
        CCObject *getTarget();
        CCObject *getData();
    private:
        std::string m_strEventName;
        bool m_bHandled;
        CCObject *m_lpTarget;
        CCObject *m_lpData;
    };

    class CProgressEvent : public CEvent
    {
    public:
        MEMORY_MANAGE_OBJECT(CProgressEvent);
        
        CProgressEvent(CCObject *lpTarget, float fLoaded, float fTotal);
        ~CProgressEvent();
    public:
        static CProgressEvent *create(CCObject *lpTarget, float fLoaded, float fTotal);
        bool init(CCObject *lpTarget, float fLoaded, float fTotal);

        float getLoaded();
        float getTotal();
    private:
        float m_fLoaded;
        float m_fTotal;
    };
}
}

#endif /* defined(__GameBox__Event__) */
