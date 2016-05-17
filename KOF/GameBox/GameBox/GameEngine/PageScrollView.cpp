
#include "PageScrollView.h"
#include "MemoryAllocator.h"
#include "LuaScriptFunctionInvoker.h"
#include "PMath.h"

using namespace ptola::gui;
using namespace ptola::memory;
using namespace ptola::math;

MEMORY_MANAGE_OBJECT_IMPL(CPageScrollView);

CPageScrollView::CPageScrollView()
: m_pScrollView(NULL)
, m_bScrolling(false)
, m_Containers(NULL)
, m_nScrollingId(-1)
, m_fDstX(-1.0f)
, m_fDstY(-1.0f)
{
    setTouchesMode(kCCTouchesAllAtOnce);
}

CPageScrollView::~CPageScrollView()
{
    CC_SAFE_DELETE(m_Containers);
}


CPageScrollView *CPageScrollView::create(enumLayoutDirection dir, CCSize &_size)
{
    CPageScrollView *pRet = new CPageScrollView;
    if( pRet != NULL && pRet->init(dir, _size))
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CC_SAFE_DELETE(pRet);
        return NULL;
    }
}


bool CPageScrollView::init()
{
    if( !CUserControl::init() )
        return onInitialized(false);
    return onInitialized(true);
}

bool CPageScrollView::init(enumLayoutDirection dir, CCSize &_size)
{
    if( !CUserControl::init() )
        return onInitialized(false);

    m_pScrollView = CCScrollView::create(_size);
    addChild(m_pScrollView);

    switch( dir )
    {
        case eLD_Horizontal:
            m_pLayout = CHorizontalLayout::create();
            m_pLayout->setLineNodeSum(1000);
            m_pLayout->setColumnNodeSum(1000);

            m_pScrollView->setContentOffset(ccp(0, _size.height/2));
            m_pScrollView->setDirection(kCCScrollViewDirectionHorizontal);
            break;
        case eLD_Relative:
            m_pLayout = CLayout::create();
            m_pScrollView->setDirection(kCCScrollViewDirectionBoth);
            break;
        case eLD_Vertical:
            m_pLayout = CVerticalLayout::create();
            m_pLayout->setLineNodeSum(1000);
            m_pLayout->setColumnNodeSum(1000);

            m_pScrollView->setContentOffset(ccp(_size.width, 0));
            m_pScrollView->setDirection(kCCScrollViewDirectionVertical);
            break;
    }
    m_pLayout->setCellSize(_size);
    
    m_pScrollView->addChild(m_pLayout);

    setTouchesEnabled(true);
    return onInitialized(true);
}

void CPageScrollView::addPage(CContainer *pContainer)
{
    if (m_Containers == NULL)
    {
        m_Containers = CCArray::create();
        m_Containers->retain();
    }
    if( m_Containers->containsObject(pContainer))
        return;
    m_Containers->addObject(pContainer);
    m_pLayout->addChild(pContainer);
}

void CPageScrollView::setContainer(CContainer *pContainer)
{
    if( m_Containers != NULL )
    {
        unsigned int _page = m_Containers->indexOfObject(pContainer);
        if( _page != CC_INVALID_INDEX )
        {
            setPage((int)_page);
        }
    }
}

void CPageScrollView::setPage(int nPage, bool bAnimated /*= false */)
{
    //
    if( !(m_fDstX < 0 && m_fDstY < 0) )
    {
        m_pScrollView->setContentOffset(ccp(m_fDstX, m_fDstY));
        m_fDstX = m_fDstY = -1.0f;
    }
    //
    int _nPage = 0 - abs(nPage);
    if( m_Containers->count() == 0 )
        return;
    //    _nPage
    if( abs(_nPage) >= (int)m_Containers->count() )
        _nPage = 0 - m_Containers->count() + 1;

    float dstX, dstY;
    float fDist;
    CCPoint cPoint = m_pScrollView->getContentOffset();
    CCSize viewSize = m_pScrollView->getViewSize();
    dstX = cPoint.x;
    dstY = cPoint.y;
    switch (m_pLayout->getDirection()) {
        case eLD_Horizontal:
            dstY = viewSize.height / 2;
            dstX = _nPage * viewSize.width;
            fDist = viewSize.width;
            break;
        case eLD_Vertical:
            dstX = viewSize.width;
            dstY = _nPage * viewSize.height;
            fDist = viewSize.height;
            break;
        case eLD_Relative:
            fDist = 1;
            bAnimated = false;
            break;
    }
    m_nPageIndex = nPage;

    CCObject *pObject = NULL;
    CCARRAY_FOREACH(m_Containers, pObject)
    {
        CContainer *pContainer = dynamic_cast<CContainer *>(pObject);
        if( pContainer == NULL )
            continue;
        pContainer->setVisible(true);
    }
    
    if (bAnimated)
    {
        m_fDstX = dstX;
        m_fDstY = dstY;
        float dist = ccpDistance(cPoint, ccp(dstX, dstY));
        float _time = dist / fDist / 2.0f;
        CCNode *pContainer = m_pScrollView->getContainer();
        if( pContainer != NULL )
        {
            m_bScrolling = true;
            pContainer->runAction(
                  CCSequence::create(CCMoveTo::create(_time, ccp(dstX, dstY)),
                  CCCallFuncN::create(this, callfuncN_selector(CPageScrollView::stopAnimated)), NULL
                      ));
        }
    }
    else
    {
        m_pScrollView->setContentOffset(ccp(dstX, dstY));
        m_fDstX = m_fDstY = -1.0f;
        int i = 0;
        CCARRAY_FOREACH(m_Containers, pObject)
        {
            CContainer *pContainer = dynamic_cast<CContainer *>(pObject);
            if( pContainer != NULL )
            {
                pContainer->setVisible( i == nPage );
            }
            i++;
        }
    }
}

int CPageScrollView::getPage()
{
    return m_nPageIndex;
}

int CPageScrollView::getPageCount()
{
    return m_Containers != NULL ? m_Containers->count() : 0;
}

//bool CPageScrollView::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
//{
//    if( m_bScrolling )
//        return false;
//    if( !m_pScrollView->ccTouchBegan(pTouch, pEvent))
//        return false;
//
//    CCObject *pObject = NULL;
//    CCARRAY_FOREACH(m_Containers, pObject)
//    {
//        CContainer *pContainer = dynamic_cast<CContainer *>(pObject);
//        if( pContainer == NULL )
//            continue;
//        pContainer->setVisible(true);
//    }
//    return true;
//}
//
//void CPageScrollView::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent)
//{
//    if( m_bScrolling )
//        return;
//    m_pScrollView->ccTouchMoved(pTouch, pEvent);
//}
//
//void CPageScrollView::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent)
//{
//    if( m_bScrolling )
//        return;
//    //calculate the mc animation to scroll to the right position.
//    m_pScrollView->ccTouchEnded(pTouch, pEvent);
//    m_pScrollView->unscheduleAllSelectors();
//    adjustPosition();
//}

void CPageScrollView::ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent)
{
    if( m_nScrollingId != -1 )
        return;
    for( CCSetIterator it = pTouches->begin(); it != pTouches->end() ; it++ )
    {
        CCTouch *pTouch = dynamic_cast<CCTouch *>(*it);
        if( pTouch != NULL )
        {
            if( m_pScrollView->ccTouchBegan(pTouch, pEvent))
            {
                m_nScrollingId = pTouch->getID();
                break;
            }
        }
    }
    if( m_nScrollingId != -1 )
    {
        CCNode *pContainer = m_pScrollView->getContainer();
        if( pContainer != NULL )
        {
            pContainer->stopAllActions();
        }
        if( !(m_fDstX < 0 && m_fDstY < 0) )
        {
            m_pScrollView->setContentOffset(ccp(m_fDstX, m_fDstY));
            m_fDstX = m_fDstY = -1.0f;
        }
        CCObject *pObject = NULL;
        CCARRAY_FOREACH(m_Containers, pObject)
        {
            CContainer *pContainer = dynamic_cast<CContainer *>(pObject);
            if( pContainer == NULL )
                continue;
            pContainer->setVisible(true);
        }
    }
}

void CPageScrollView::ccTouchesMoved(cocos2d::CCSet *pTouches, cocos2d::CCEvent *pEvent)
{
    if( m_nScrollingId == -1 )
        return;
    for( CCSetIterator it = pTouches->begin(); it != pTouches->end(); it++ )
    {
        CCTouch *pTouch = dynamic_cast<CCTouch *>(*it);
        if( pTouch != NULL && pTouch->getID() == m_nScrollingId )
        {
            m_pScrollView->ccTouchMoved(pTouch, pEvent);
        }
    }
}

void CPageScrollView::ccTouchesEnded(cocos2d::CCSet *pTouches, cocos2d::CCEvent *pEvent)
{
    if( m_nScrollingId == -1 )
        return;
    bool bProcess = false;
    float fDistance = 0.0f;
    float fRadian = 0.0f;
    for( CCSetIterator it = pTouches->begin(); it != pTouches->end(); it++ )
    {
        CCTouch *pTouch = dynamic_cast<CCTouch *>(*it);
        if( pTouch != NULL && pTouch->getID() == m_nScrollingId )
        {
            m_pScrollView->ccTouchEnded(pTouch, pEvent);
            m_nScrollingId = -1;
            bProcess = true;
            //计算距离和角度
            fDistance = ccpDistance(pTouch->getLocation(), pTouch->getStartLocation() );
            fRadian = CMath::angleToRadian( CMath::pointsToAngle(pTouch->getStartLocation(),pTouch->getLocation()) );
        }
    }
    

    if( bProcess )
    {
        m_pScrollView->unscheduleAllSelectors();
        adjustPosition(fDistance, fRadian);
//        adjustPosition();
    }
    m_nScrollingId = -1;

}


void CPageScrollView::removePage(CContainer *pContainer)
{
    if( pContainer == NULL )
        return;
    m_pLayout->removeChild( pContainer );
    m_Containers->removeObject( pContainer );
}

void CPageScrollView::removePageByIndex(int nPageIndex)
{
    CCObject *pObject = m_Containers->objectAtIndex(nPageIndex);
    CContainer *pContainer = dynamic_cast<CContainer *>(pObject);
    removePage(pContainer);
}

void CPageScrollView::adjustPosition(float fDistance, float fRadian)
{
    if( m_Containers == NULL )
        return;
    CCSize viewSize = m_pScrollView->getViewSize();
    CCPoint cPoint = m_pScrollView->getContentOffset();
    float dstX, dstY;
    int nPage = m_nPageIndex;
    float fDist = 100.0f;
    switch( m_pLayout->getDirection() )
    {
        case eLD_Horizontal:
        {
            //
            if( fDistance > viewSize.width / 2.0f )
                fDistance = viewSize.width / 2.0f;
            
            int nState1 = 0;
            //check the radian
            if( fabs(fRadian) < (3.14f / 4.0f) )
            {
                nState1 = 1;
            }
            else if( fabs(fRadian) > (3.14f / 4.0f * 3.0f) )
            {
                nState1 = -1;
            }
            else
            {
                nState1 = 0;
            }
            //结算出当前页

            int nCurrentPage1 = abs((int)(cPoint.x / viewSize.width));
//            if( abs((int)cPoint.x % (int)viewSize.width) > (int)(viewSize.width / 2) )
//            {
//                nCurrentPage1 += 1;
//            }

            if( fDistance > viewSize.width / 3.0f )
            {
                if( nState1 == -1 )
                {
                    nCurrentPage1++;
                }
                else if(nState1 == 1)
                {
                    if( abs(m_nPageIndex - nCurrentPage1) == 0 )
                    {
                        nCurrentPage1--;
                    }
                }
            }
            if( nCurrentPage1 < 0 )
                nCurrentPage1 = 0;
            if( nCurrentPage1 > m_Containers->count() - 1 )
                nCurrentPage1 = m_Containers->count() - 1;
            nPage = nCurrentPage1;
            dstX = viewSize.width * -nCurrentPage1;
            dstY = viewSize.height / 2.0f;
            fDist = ccpDistance(ccp(dstX, dstY), ccp(cPoint.x, dstY));
            //
        }
        break;
        case eLD_Vertical:
        {
            if( fDistance > viewSize.height / 2.0f )
                fDistance = viewSize.height / 2.0f;
            int nState2 = 0;
            if( fRadian > (3.14f / 4.0f) && fRadian < (3.14f / 4.0f * 3.0f) )
            {
                nState2 = -1;
            }
            else if( fRadian < (-3.14f / 4.0f) && fRadian > (-3.14f / 4.0f * 3.0f) )
            {
                nState2 = 1;
            }
            else
            {
                nState2 = 0;
            }

            int nCurrentPage2 = abs((int)(cPoint.y / viewSize.height));
//            if( abs((int)cPoint.y % (int)viewSize.height) > (int)(viewSize.height / 2) )
//            {
//                nCurrentPage2 += 1;
//            }

            if( fDistance > viewSize.height / 3.0f )
            {
                if( nState2 == -1 )
                {
                    nCurrentPage2--;
                }
                else if(nState2 == 1)
                {
                    if( abs(m_nPageIndex - nCurrentPage2) == 0 )
                    {
                        nCurrentPage2++;
                    }
                }
            }

            if( nCurrentPage2 < 0 )
                nCurrentPage2 = 0;
            if( nCurrentPage2 > m_Containers->count() - 1 )
                nCurrentPage2 = m_Containers->count() - 1;
            
            nPage = nCurrentPage2;
            dstX = viewSize.width;
            dstY = viewSize.height * -nCurrentPage2;
            fDist = ccpDistance(ccp(dstX, dstY), ccp(dstX, cPoint.y));
        }
        break;
        case eLD_Relative:
        {
            return;
        }
        break;
    }


    if( dstX != cPoint.x || dstY != cPoint.y )
    {   //dir
        m_fDstX = dstX;
        m_fDstY = dstY;
        float dist = ccpDistance(cPoint, ccp(dstX, dstY));
        float _time = dist / fDist / 2.0f;
        CCNode *pContainer = m_pScrollView->getContainer();
        if( pContainer != NULL )
        {
            m_bScrolling = true;
            m_nPageIndex = nPage;
            pContainer->runAction(
                                  CCSequence::create(CCMoveTo::create(_time, ccp(dstX, dstY)),
                                                     CCCallFuncN::create(this, callfuncN_selector(CPageScrollView::stopAnimated)), NULL
                                                     ));
        }
        else
        {
            m_pScrollView->setContentOffset(ccp(dstX, dstY));
            m_fDstX = m_fDstY = -1.0f;
        }
        //CCMoveTo::create(_time, ccp(dstX, dstY));
    }
}

void CPageScrollView::adjustPosition()
{
    CCSize viewSize = m_pScrollView->getViewSize();
    CCPoint cPoint = m_pScrollView->getContentOffset();
    float dstX , dstY ;
    float fDist;
    switch( m_pLayout->getDirection() )
    {
        case eLD_Horizontal:
        {   //horizontal
            if( cPoint.x > 0 )
            {
                dstX = 0.0f;
            }
            else
            {
                float fPage = cPoint.x / viewSize.width;
                int nPage = (int)fPage;
                float fOffset = fPage - (float)nPage;
                if( fOffset > -0.5f )
                {
                    dstX = cPoint.x - viewSize.width * fOffset;
                }
                else
                {
                    dstX = cPoint.x - viewSize.width * (1.0 + fOffset);
                    if( dstX <= -viewSize.width * (m_Containers->count() - 1) )
                    {
                        dstX = -viewSize.width * (m_Containers->count() - 1);
                    }
                }
            }
            dstY = viewSize.height / 2.0f;
            fDist = viewSize.height;
        }
        break;
        case eLD_Vertical:
        {   //vertical
            if( cPoint.y > 0 )
            {
                dstY = 0.0f;
            }
            else
            {
                float fPage = cPoint.y / viewSize.height;
                int nPage = (int)fPage;
                float fOffset = fPage - (float)nPage;
                if( fOffset > -0.5f )
                {
                    dstY = cPoint.y - viewSize.height * fOffset;
                }
                else
                {
                    dstY = cPoint.y - viewSize.height * (1.0 + fOffset);
                    if( dstY <= -viewSize.height * (m_Containers->count() - 1) )
                    {
                        dstY = -viewSize.height * (m_Containers->count() - 1);
                    }
                }
            }
            dstX = viewSize.width;
            fDist = viewSize.width;
        }
        break;
        case eLD_Relative:
        {   //relative
            m_pScrollView->setContentOffset(cPoint);
            return;
        }
        break;
    }

    if( dstX != cPoint.x || dstY != cPoint.y )
    {   //dir
        float dist = ccpDistance(cPoint, ccp(dstX, dstY));
        float _time = dist / fDist / 2.0f;
        CCNode *pContainer = m_pScrollView->getContainer();
        if( pContainer != NULL )
        {
            m_bScrolling = true;
            pContainer->runAction(
                 CCSequence::create(CCMoveTo::create(_time, ccp(dstX, dstY)),
                 CCCallFuncN::create(this, callfuncN_selector(CPageScrollView::stopAnimated)), NULL
            ));
        }
        else
        {
            m_pScrollView->setContentOffset(ccp(dstX, dstY));
        }
        //CCMoveTo::create(_time, ccp(dstX, dstY));
    }
}

void CPageScrollView::stopAnimated(CCNode *pNode)
{
    CCPoint endPos = m_pScrollView->getContentOffset();
    CCSize viewSize = m_pScrollView->getViewSize();
    int nPage = -1;
    switch( m_pScrollView->getDirection() )
    {
        case cocos2d::extension::kCCScrollViewDirectionHorizontal:
        {
            nPage = (int)fabs(endPos.x / viewSize.width);
        }
        break;
        case cocos2d::extension::kCCScrollViewDirectionVertical:
        {
            nPage = (int)fabs(endPos.y / viewSize.height);
        }
        break;
        case cocos2d::extension::kCCScrollViewDirectionBoth:
        case cocos2d::extension::kCCScrollViewDirectionNone:
            nPage = 0;
        break;
    }
    CCObject *pObject;
    int i = 0;
    CCARRAY_FOREACH(m_Containers, pObject)
    {
        CContainer *pContainer = dynamic_cast<CContainer *>(pObject);
        if( pContainer != NULL )
        {
            pContainer->setVisible( i == nPage );
        }
        i++;
    }
    m_bScrolling = false;
    onScroll(nPage);
}

void CPageScrollView::onScroll(int nPage)
{
    CLuaScriptFunctionInvoker::executePageScrolledScript(m_pControlScriptHandler, this, "CPageScrollView", nPage);
}


/*
using namespace ptola::gui;
using namespace ptola::memory;

MEMORY_MANAGE_OBJECT_IMPL(CPageScrollView);

CPageScrollView::CPageScrollView()
:m_page(0)
,m_pdelegate(NULL)
,m_pageCount(0)
,m_pLayout(NULL)
,m_uLayoutType(eLD_Horizontal)
,m_bIsMoveOver(true)
{
    setTouchEnabled(true);
    m_pagesize.width=1;
    m_pagesize.height=1;
    
}
CPageScrollView::~CPageScrollView()
{
    
}

void CPageScrollView::SetPageSize(CCSize s)
{
    m_pagesize = s;
}
CCSize CPageScrollView::GetPageSize()
{
    return m_pagesize;
}

void CPageScrollView::SetPage(int page)
{
    if(page >m_pageCount||page<0)
    {
        CCLog("不能大于总页数数量");
        return ;
    }
    
    m_bIsMoveOver = false;
    m_lastpage = page;
    m_page = page;
    if(m_eDirection == kCCScrollViewDirectionVertical)
    {
        setContentOffset(ccp(m_pContainer->getPositionX(),-page*m_pagesize.height),true);
    }
    else
    {
        setContentOffset(ccp(-page*m_pagesize.width,m_pContainer->getPositionY()),true);
    }
//    for(int i = 0;i<m_VecContainer.size();i++)
//    {
//        if(i!= m_page)
//            m_VecContainer[i]->setVisible(false);
//    }
}

int CPageScrollView::GetPage()
{
    if(m_eDirection == kCCScrollViewDirectionVertical)
    {
        m_page = -m_pContainer->getPositionY()/m_pagesize.height;
    }
    else
    {
       m_page = -m_pContainer->getPositionX()/m_pagesize.width;
    }
    return m_page;
}

int CPageScrollView::GetPageCount()
{
    return m_pageCount;
}

void CPageScrollView::SetContainerPageAndSize(int page,CCSize size)
{
    m_pageCount=page;
    SetPageSize(size);
    CCSize cs;
    if(m_eDirection == kCCScrollViewDirectionVertical)
    {
        cs = CCSizeMake(size.width, size.height*page);
    }
    else
    {
        cs = CCSizeMake(size.width*page, size.height);
    }
    setContentSize(cs);
}

bool CPageScrollView::init()
{
    setAnchorPoint(ccp(0,0));
    return CCScrollView::init();
}


bool CPageScrollView::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
//    if(m_bIsMoveOver ==false)
//        return false;
    
    if(!CCScrollView::ccTouchBegan(pTouch, pEvent))
        return false;
    for(int i = 0;i<m_VecContainer.size();i++)
    {
        m_VecContainer[i]->setVisible(true);
    }
    return true;
}
void CPageScrollView::ccTouchMoved(CCTouch* touch, CCEvent* event)
{
    CCScrollView::ccTouchMoved(touch, event);
}
void CPageScrollView::ccTouchEnded(CCTouch* touch, CCEvent* event)
{
    CCScrollView::ccTouchEnded(touch, event);
    if(m_bBounceable == true&&m_bIsMoveOver)
    adjustScrollView();
}

void CPageScrollView::adjustScrollView()
{    
    // 关闭CCScrollView中的自调整
    unscheduleAllSelectors();
    
    float x = getContentOffset().x;
    float y = getContentOffset().y;
    int page = (x/m_pagesize.width);
    int offset = (int)x % (int)m_pagesize.width;
    
    if(m_eDirection == kCCScrollViewDirectionVertical)
    {
        page = (int)y/(int)m_pagesize.height;
        offset = (int)y % (int)m_pagesize.height;
    }
    // 调整位置
    CCPoint adjustPos;
    // 调整动画时间
    float adjustAnimDelay;
    
    m_lastpage = m_page;
    if(m_eDirection == kCCScrollViewDirectionVertical)
    {
        if (offset < -m_pagesize.height/2) {
            // 计算下一页位置，时间
            adjustPos = ccp(x,(page-1)*m_pagesize.height);
            m_page = -(page-1);
            adjustAnimDelay = (float) (m_pagesize.height + offset) / (m_pagesize.height*2);
        }
        else {
            adjustPos = ccp(x,(page)*m_pagesize.height);
            m_page = -page;
            adjustAnimDelay = (float) abs(offset) / (m_pagesize.height*2);
        }
        
        if(adjustPos.y>0)
        {
            adjustPos.y=0;
        }
        else if (adjustPos.y<minContainerOffset().y)
        {
            adjustPos.y=minContainerOffset().y;
        }
    }
    else
    {
        if (offset < -m_pagesize.width/2) {
            // 计算下一页位置，时间
            adjustPos = ccp((page-1)*m_pagesize.width,y);
            m_page = -(page-1);
            adjustAnimDelay = (float) (m_pagesize.width + offset) / (m_pagesize.width*2);
        }
        else {
            adjustPos = ccp((page)*m_pagesize.width,y);
            m_page = -page;
            adjustAnimDelay = (float) abs(offset) / (m_pagesize.width*2);
        }
        if(adjustPos.x>0)
        {
            adjustPos.x=0;
        }
        else if (adjustPos.x<minContainerOffset().x)
        {
            adjustPos.x=minContainerOffset().x;
        }
    }
    
    // 调整位置
    setContentOffsetInDuration(adjustPos, adjustAnimDelay);
}

void CPageScrollView::setContentOffsetInDuration(CCPoint offset, float dt)
{
    CCFiniteTimeAction *scroll, *expire;
    
    scroll = CCMoveTo::create(dt, offset);
    expire = CCCallFuncN::create(this, callfuncN_selector(CPageScrollView::stoppedAnimatedScroll));
    m_pContainer->runAction(CCSequence::create(scroll, expire, NULL));
    this->schedule(schedule_selector(CPageScrollView::performedAnimatedScroll));
}

void CPageScrollView::stoppedAnimatedScroll(CCNode * node)
{
    m_bIsMoveOver = true;
    this->unschedule(schedule_selector(CPageScrollView::performedAnimatedScroll));
    if(m_pdelegate)
    m_pdelegate->afterAdjustScrollView(m_lastpage,m_page);
    for(int i = 0;i<m_VecContainer.size();i++)
    {
        if(i!= GetPage())
            m_VecContainer[i]->setVisible(false);
        else
            m_VecContainer[i]->setVisible(true);

    }
}

void CPageScrollView::performedAnimatedScroll(float dt)
{
    m_bIsMoveOver = false;
    if (m_bDragging)
    {
        this->unschedule(schedule_selector(CPageScrollView::performedAnimatedScroll));
        return;
    }
    
    if (m_pDelegate != NULL)
    {
        m_pDelegate->scrollViewDidScroll(this);
    }
}

void CPageScrollView::setPageScrollDelegate(CPageScrollDelegate *p)
{
    m_pdelegate = p;
}
void CPageScrollView::registerWithTouchDispatcher()
{
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, kCCMenuHandlerPriority, false);
    
}

void CPageScrollView::addPage(CContainer *_pConntainer)
{
    m_VecContainer.push_back(_pConntainer);
//    if(m_VecContainer.size()-1 != GetPage())
//        _pConntainer->setVisible(false);
    
    m_pLayout->addChild(_pConntainer);
}

bool CPageScrollView::init(enumLayoutDirection mType)
{
    setAnchorPoint(ccp(0,0));
    return CCScrollView::init();
}

CPageScrollView* CPageScrollView::create(enumLayoutDirection m_uTypeLayout,CCSize m_sizePageView)
{
    CPageScrollView *pRet = new CPageScrollView;
    if( pRet != NULL && pRet->init(m_uTypeLayout))
    {
        pRet->autorelease();
        pRet->setViewSize(m_sizePageView);
        
        pRet->m_pLayout = CLayout::create(m_uTypeLayout);
        pRet->m_pLayout->setCellSize(m_sizePageView);
        
        
        if (m_uTypeLayout == eLD_Vertical) {
           pRet->m_pLayout->setPosition(ccp(m_sizePageView.width/2,0));
            pRet->m_pLayout->setColumnNodeSum(100);
            pRet->setDirection(kCCScrollViewDirectionVertical);
        }
        if (m_uTypeLayout == eLD_Horizontal) {
            pRet->m_pLayout->setLineNodeSum(100);
            pRet->m_pLayout->setPosition(ccp(0,m_sizePageView.height/2));
            pRet->setDirection(kCCScrollViewDirectionHorizontal);
        }
        
        return pRet;
    }
    else
    {
        CC_SAFE_DELETE(pRet);
        return NULL;
    }
}
void CPageScrollView::setContainer(CCNode * pContainer)
{
    CCScrollView::setContainer(pContainer);
    if(m_pLayout!=NULL)
    m_pContainer->addChild(m_pLayout);
}
*/