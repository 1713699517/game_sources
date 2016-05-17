//
//  ScreenTurn.h
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#ifndef __GameBox__ScreenTurn__
#define __GameBox__ScreenTurn__

#include "Button.h"
#include "Container.h"
#include "Collection.h"

namespace ptola
{
namespace gui
{

    class CScreenTurn : public CUserControl
    {
    public:

        MEMORY_MANAGE_OBJECT(CScreenTurn);
        
        CScreenTurn();
        ~CScreenTurn();

//        CREATE_FUNC(CScreenTurn);
//        bool init();

        static CScreenTurn *create(CContainer *pContainer);
        bool init(CContainer *pContainer);
        
        unsigned int getCurrentPage();
        void setCurrentPage(unsigned int uPage);

        void goPreviousPage();
        void goNextPage();
        
        
    protected:
        virtual void onPageTurn(unsigned int nCurrentPage, unsigned int uOldPage);
    private:
        unsigned int m_uCurrentPage;

        CButton *m_pButtonPrevious;
        CButton *m_pButtonNext;

        CCollection<CContainer *> m_Containers;
    };
    
    
    inline unsigned int CScreenTurn::getCurrentPage()
    {
        return m_uCurrentPage;
    }
    
    inline void CScreenTurn::setCurrentPage(unsigned int uPage)
    {
        m_uCurrentPage = uPage;
    }
    

}
}

#endif /* defined(__GameBox__ScreenTurn__) */
