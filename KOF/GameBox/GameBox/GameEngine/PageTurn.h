//
//  PageTurn.h
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#ifndef __GameBox__PageTurn__
#define __GameBox__PageTurn__

#include "Button.h"
#include "Container.h"
#include "Collection.h"
#include "ptola.h"
#include <map>
#define EVENT_BEGAN   "TouchBegan"

using namespace std;

namespace ptola
{
namespace gui
{

    class CPageTurn : public CUserControl, public ILabel
    {
    public:

        MEMORY_MANAGE_OBJECT(CPageTurn);
        
        CPageTurn();
        ~CPageTurn();

        static CPageTurn *create(CContainer *pContainer,unsigned int uCurrentPage,unsigned int uMaxPages);
        bool init(CContainer *pContainer,unsigned int uCurrentPage,unsigned int uMaxPages);
        
        
        void setCurrentPage(unsigned int uPage);
        unsigned int getCurrentPage();

        void setMaxPages(unsigned int uPages);
        unsigned int getMaxPages();
        
    public:
        virtual void setText(const char *lpcszText);
        virtual const char *getText();

        virtual ccColor4B getColor();
        virtual void setColor(ccColor4B &color);

        virtual float getFontSize();
        virtual void setFontSize(float fFontSize);

        virtual const char *getFontFamily();
        virtual void setFontFamily(const char *lpcszFontFamily);

        CCLabelTTF *getLabel();
        
    public:
        void goPreviousPage(CCObject *pSender);
        void goNextPage(CCObject *pSender);
        
    public:
        virtual bool containsPoint(CCPoint *pGLPoint);
        virtual void onTouchInside();
        
    protected:
        virtual void onPageTurn(unsigned int nCurrentPage, unsigned int uOldPage);
    private:
        unsigned int m_uCurrentPage;
        unsigned int m_uMaxPages;

        CButton *m_pButtonPrevious;
        CButton *m_pButtonNext;

        CCLabelTTF *m_pLabelPage;
        CCollection<CContainer *> m_Containers;
        
        map<CPageTurn *,CContainer *> m_mapPages;
    };

}
}

#endif /* defined(__GameBox__PageTurn__) */
