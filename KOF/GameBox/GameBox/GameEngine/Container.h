//
//  Container.h
//  GameBox
//
//  Created by Caspar on 2013-5-8.
//
//

#ifndef __GameBox__Container__
#define __GameBox__Container__

#include "UserControl.h"
#include "ptola.h"
USING_NS_CC;

namespace ptola
{
namespace gui
{

    class CContainer : public CUserControl
    {
    public:

        MEMORY_MANAGE_OBJECT(CContainer);
        
        CContainer();
        ~CContainer();
        CREATE_FUNC(CContainer);

        bool init();

        void setIsForm(bool bIsForm);
        bool getIsForm();
    private:
        bool m_bIsForm;
    };

}
}

#endif /* defined(__GameBox__Container__) */
