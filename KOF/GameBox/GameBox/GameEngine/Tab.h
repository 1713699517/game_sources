//
//  Tab.h
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#ifndef __GameBox__Tab__
#define __GameBox__Tab__

#include "Layout.h"
#include "TabPage.h"
#include "Collection.h"
#include "VerticalLayout.h"
#include "HorizontalLayout.h"
#include "ptola.h"
#include <map>

using namespace std;

namespace ptola
{
namespace gui
{
    
    class CTabPage;
    
    class CTab : public CUserControl
    {
    public:

        MEMORY_MANAGE_OBJECT(CTab);
        
        CTab();
        ~CTab();

        CREATE_FUNC(CTab);
        bool init();
        bool init(enumLayoutDirection m_value, const CCSize &_cellSize);

        static CTab* create(enumLayoutDirection _value, const CCSize &_cellSize);
        
        void addTab( CTabPage *pTabPage, CContainer *pTabContainer );
        void removeTab( CTabPage *pTabPage );
        void removeTabByIndex( unsigned int uIndex );
        void onTabChange( CTabPage *pTabPage );
        
        CLayout *getLayout(){return m_pTabPageLayout;};

        void setSelectedTabIndex(unsigned int uIndex);
    private:
        
        CLayout *m_pTabPageLayout;
        CCollection<CContainer *> m_pCollectionContainer;
        CCollection<CTabPage *> m_pCollectionTabPages;

        map<CTabPage *,CContainer *> m_mapTabPages;
        CContainer *m_pCurrentContainer;
        
        enumLayoutDirection m_LayoutDirection;
//        
        friend class CTabPage;
    };

}
}

#endif /* defined(__GameBox__Tab__) */
