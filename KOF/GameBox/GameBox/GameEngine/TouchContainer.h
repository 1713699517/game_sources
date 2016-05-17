//
//  TouchContainer.h
//  GameBox
//
//  Created by Caspar on 13-9-18.
//
//

#ifndef __GameBox__TouchContainer__
#define __GameBox__TouchContainer__


#include "Container.h"
#include "ptola.h"
USING_NS_CC;

namespace ptola
{
    namespace gui
    {

        class CTouchContainer : public CContainer
        {
        public:

            MEMORY_MANAGE_OBJECT(CTouchContainer);

            CTouchContainer();
            ~CTouchContainer();
            CREATE_FUNC(CTouchContainer);

            bool init();

        public:
            virtual bool containsPoint(CCPoint *pPoint);
        private:
            bool m_bIsForm;
        };
        
    }
}


#endif /* defined(__GameBox__TouchContainer__) */
