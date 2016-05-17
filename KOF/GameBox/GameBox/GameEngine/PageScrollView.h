//
//  PageScrollView.h
//  wzxy
//
//  Created by 李健伟 on 12-10-5.
//
//

#ifndef __wzxy__PageScrollView__
#define __wzxy__PageScrollView__

#include "cocos2d.h"
#include "cocos-ext.h"
#include "Container.h"
#include "Layout.h"
#include "ptola.h"

using namespace std;
USING_NS_CC;
USING_NS_CC_EXT;

namespace ptola
{
    namespace gui
    {

        class CPageScrollView : public CUserControl
        {
        public:
            MEMORY_MANAGE_OBJECT(CPageScrollView);

            CREATE_FUNC(CPageScrollView);
            CPageScrollView();
            ~CPageScrollView();

            static CPageScrollView *create(enumLayoutDirection dir, CCSize &_size);
            bool init(enumLayoutDirection dir, CCSize &_size);

            bool init();
            
            void addPage(CContainer *pContainer);
            void removePage(CContainer *pContainer);
            void removePageByIndex(int nPageIndex);

            void setContainer(CContainer *pContainer);

            void setPage(int nPage, bool bAnimated=false);
            int getPage();

            int getPageCount();

//            virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
//            virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
//            virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
            virtual void ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent);
            virtual void ccTouchesMoved(CCSet *pTouches, CCEvent *pEvent);
            virtual void ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent);

        protected:
            void adjustPosition(float fDistance, float fRadian);
            void adjustPosition();
            void stopAnimated(CCNode *pNode);
            void onScroll(int nPage);
        private:



            int m_nPageIndex;
            CCScrollView *m_pScrollView;
            CLayout *m_pLayout;
            CCArray *m_Containers;
            bool m_bScrolling;
            int m_nScrollingId;

            float m_fDstX;
            float m_fDstY;
        };

        /*
        class CPageScrollDelegate
        {
        public:
            virtual void afterAdjustScrollView(int lastpage,int page) = 0;
        };

        class CPageScrollView : public CCScrollView
        {
        public:
            MEMORY_MANAGE_OBJECT(CPageScrollView);
            
            CREATE_FUNC(CPageScrollView);
            CPageScrollView();
            ~CPageScrollView();
            
            static CPageScrollView* create(enumLayoutDirection mType,CCSize m_sizePageView);
            bool init(enumLayoutDirection mType);
            
            void addPage(CContainer *_pConntainer);
            void setContainer(CCNode * pContainer);
            
            bool init();
            
            void SetPageSize(CCSize s);
            CCSize GetPageSize();
            
            void SetPage(int page);
            int GetPage();
            
            virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
            virtual void ccTouchMoved(CCTouch* touch, CCEvent* event);
            virtual void ccTouchEnded(CCTouch* touch, CCEvent* event);
            void registerWithTouchDispatcher();
            
            void SetContainerPageAndSize(int page,CCSize size);
            int m_pageCount;
            int GetPageCount();
            void setPageScrollDelegate(CPageScrollDelegate *p);
    //        CLayout * getLayout(){return m_pLayout;}
            
        private:
            void setContentOffsetInDuration(CCPoint offset, float dt);
            void stoppedAnimatedScroll(CCNode * node);
            void performedAnimatedScroll(float dt);
            
            void adjustScrollView();
            int m_lastpage;
            int m_page;
            bool m_bIsMoveOver;
            CLayout *m_pLayout;
            enumLayoutDirection m_uLayoutType ;
            CPageScrollDelegate *m_pdelegate;
            vector<CContainer *> m_VecContainer;
            CCSize m_pagesize;
        };*/
        
    }
}

#endif /* defined(__wzxy__PageScrollView__) */
