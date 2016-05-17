//
//  RichTextView.cpp
//  RichTextView
//
//  Created by Mac on 13-4-10.
//
//



#include "RichTextView.h"
#include "FontMetric.h"
#include <map>
#include <algorithm>

USING_NS_CC;
using namespace std;
using namespace ptola::gui;

static const CCPoint CRichContentAnchor = CCPointMake(0.0f, 0.0f);
CCPoint CRichTextView::NowTouchPoint;

CRichTextStyle::CRichTextStyle()
: szFontFamily("Arial")
, fFontSize(22.0f)
, cFontColor(ccc4(0,0,0,255))
, eStyle(eTS_Normal)
{
    
}

CRichTextStyle::CRichTextStyle(const CRichTextStyle &rhs)
: szFontFamily(rhs.szFontFamily)
, fFontSize(rhs.fFontSize)
, cFontColor(rhs.cFontColor)
, eStyle(rhs.eStyle)
{
    
}

CRichTextStyle &CRichTextStyle::operator=(const CRichTextStyle &rhs)
{
    szFontFamily.assign(rhs.szFontFamily);
    fFontSize = rhs.fFontSize;
    cFontColor = rhs.cFontColor;
    eStyle = rhs.eStyle;
    return *this;
}

bool CRichTextStyle::operator==(const CRichTextStyle &rhs) const
{
    do
    {
        CC_BREAK_IF(fFontSize != rhs.fFontSize);
        CC_BREAK_IF(cFontColor.r != rhs.cFontColor.r);
        CC_BREAK_IF(cFontColor.g != rhs.cFontColor.g);
        CC_BREAK_IF(cFontColor.b != rhs.cFontColor.b);
        CC_BREAK_IF(cFontColor.a != rhs.cFontColor.a);
        CC_BREAK_IF(eStyle != rhs.eStyle);
        CC_BREAK_IF(szFontFamily.compare(rhs.szFontFamily) != 0);
        return true;
    }
    while (0);
    return false;
}

bool CRichTextStyle::operator!=(const CRichTextStyle &rhs) const
{
    return !(operator==(rhs));
}

bool CRichTextStyle::operator<(const CRichTextStyle &rhs) const
{
    do
    {
        CC_BREAK_IF(this->operator==(rhs));
        CC_BREAK_IF(fFontSize < rhs.fFontSize);
        CC_BREAK_IF(cFontColor.r < rhs.cFontColor.r);
        CC_BREAK_IF(cFontColor.g < rhs.cFontColor.g);
        CC_BREAK_IF(cFontColor.b < rhs.cFontColor.b);
        CC_BREAK_IF(cFontColor.a < rhs.cFontColor.a);
        CC_BREAK_IF(eStyle < rhs.eStyle);
        CC_BREAK_IF(szFontFamily.compare(rhs.szFontFamily) < 0);
        return true;
    }
    while (0);
    return false;
}

float CRichTextMetric::getCharWidth(char ch)
{
    map<char, float>::iterator it = mapCharsWidth.find(ch);
    return it == mapCharsWidth.end() ? 0.0f : it->second;
}

CRichTextMetric *CRichTextStyleDataCache::getData(CRichTextStyle &style)
{
    static map< CRichTextStyle, CRichTextMetric > mapTextMetrics;
__refind:
    map<CRichTextStyle, CRichTextMetric>::iterator it = mapTextMetrics.find(style);
    if( it != mapTextMetrics.end() )
        return &it->second;
    else
    {
        CRichTextMetric textMetric;
#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        CFontMetric fontMetric;
        CCSize wideCharSize = fontMetric.measureTextSize("我", style.szFontFamily.c_str(), style.fFontSize, 1000.0f);
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
        CRichContentText txt("人", style);
        CCSize wideCharSize = txt.getContentSize();
#endif
        textMetric.setWideCharWidth( wideCharSize.width );
        textMetric.setCharHeight( wideCharSize.height );
        for( int i = 0x21 ; i < 0x7f ; i++ )
        {
            char szStr[2] = { 0, 0 };
            szStr[0] = i;
#if(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
            CCSize charSize = fontMetric.measureTextSize(szStr, style.szFontFamily.c_str(), style.fFontSize, 1000.0f);
            textMetric.mapCharsWidth[ (char)i ] = charSize.width;
#elif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
            txt.setString(szStr);
            textMetric.mapCharsWidth[ (char)i ] = txt.getContentSize().width;
#endif
        }
        mapTextMetrics[ style ] = textMetric;
        goto __refind;
    }
}



const char *CReactContent::getActionName()
{
    return m_actionName.c_str();
}

void CReactContent::setActionName(const char *var)
{
    if( var == NULL )
        m_actionName = "";
    else
        m_actionName = var;
}

const char *CReactContent::getActionArgString(int nArgIndex)
{
    return m_actionArgs[ nArgIndex ].c_str();
}

int CReactContent::getActionArgInt(int nArgIndex)
{
    return atoi( getActionArgString(nArgIndex) );
}

void CReactContent::setActionArgString(int nArgIndex, const char *var)
{
    if( nArgIndex > m_actionArgs.size() )
    {
        CCLOG("CReactContent setActionArgXXX Index out of Range!");
        return;
    }
    string strVar = var;
    if( m_actionArgs.size() == nArgIndex )
    {
        m_actionArgs.push_back(strVar);
    }
    else
    {
        m_actionArgs[nArgIndex] = strVar;
    }
}

void CReactContent::setActionArgInt(int nArgIndex, int var)
{
    char szVarStr[16] = {0};
    sprintf(szVarStr, "%d", var);
    setActionArgString(nArgIndex, szVarStr);
}

size_t CReactContent::getActionArgCount()
{
    return m_actionArgs.size();
}

void CReactContent::copyFrom(const CReactContent *pContent)
{
    if( pContent == NULL )
        return;
    m_actionName = pContent->m_actionName;
    m_actionArgs.clear();
    for( std::vector<string>::const_iterator it = pContent->m_actionArgs.begin();
        it != pContent->m_actionArgs.end(); it++ )
    {
        m_actionArgs.push_back( *it );
    }
}

CRichContentData::CRichContentData(CCObject *pObject)
: m_Data(NULL)
{
    setData(pObject);
}

CRichContentData::~CRichContentData()
{
    CC_SAFE_RELEASE(m_Data);
}

CRichContentData *CRichContentData::create(CCObject *pObject)
{
    CRichContentData *pRet = new CRichContentData(pObject);
    if( pRet != NULL )
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CCLOG("CRichContentData Create Error!");
        return NULL;
    }
}










CRichContentText::CRichContentText(const char *lpcszString, const CRichTextStyle &var)
: m_cStyle(var)
{
    CReactContent::setLineNumber(0);
    if(initWithString(lpcszString, m_cStyle.szFontFamily.c_str(), m_cStyle.fFontSize, CCSizeZero, kCCTextAlignmentLeft, kCCVerticalTextAlignmentCenter))
    {
        setColor(ccc3(m_cStyle.cFontColor.r, m_cStyle.cFontColor.g, m_cStyle.cFontColor.b));
        setOpacity(m_cStyle.cFontColor.a);
        setAnchorPoint(CRichContentAnchor);
        setPosition(CCPointZero);
    }
}

CRichContentText *CRichContentText::create(const char *lpcszString, const CRichTextStyle &var)
{
    CRichContentText *pRet = new CRichContentText(lpcszString, var);
    if( pRet != NULL )
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CCLOG("CRichContentText Create Error!");
        return NULL;
    }
}

const CRichTextStyle &CRichContentText::getStyle()
{
    return m_cStyle;
}

void CRichContentText::setStyle(CRichTextStyle &var)
{
    m_cStyle = var;
    setFontName(m_cStyle.szFontFamily.c_str());
    setFontSize(m_cStyle.fFontSize);
    setColor(ccc3(m_cStyle.cFontColor.r, m_cStyle.cFontColor.g, m_cStyle.cFontColor.b));
    setOpacity(m_cStyle.cFontColor.a);
    setAnchorPoint(CRichContentAnchor);
    setPosition(CCPointZero);
}


//void CRichContentText::draw()
//{
//    CCNode::draw();
//}
//
//void CRichContentText::visit()
//{
//        CCNode::visit();
//}


CRichContentNode::CRichContentNode(const CCNode *pData)
: m_pData((CCNode *)pData)
{
    CReactContent::setLineNumber(0);
    m_pData->ignoreAnchorPointForPosition(true);
    addChild(m_pData);
    setContentSize(m_pData->getContentSize());
    setAnchorPoint(CCPointZero);
}

CRichContentNode *CRichContentNode::create(const CCNode *pData)
{
    CRichContentNode *pRet = new CRichContentNode(pData);
    if( pRet != NULL )
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CCLOG("CRichContentNode Create Error!");
        return NULL;
    }
}











CRichTextView::CRichTextView(int nWidth, int nHeight, bool bAutoRedraw, float fContentWidthSize)
: m_scrollPoint(CCPointZero)
, m_scrollSize(CCSizeMake(nWidth, nHeight))
, m_bStateDirty(true)
, m_bLayoutDirty(false)
, m_bTouchEnabled(false)
, m_backgroundColor(ccc4(55,55,55,100))
, m_bAutoRedraw(bAutoRedraw)
, m_fContentWidthSize(fContentWidthSize)
, m_pListenerTarget(NULL)
, m_CommandHandler(NULL)
, m_bAutoScrollDown(false)
, m_pCanvas(CCNode::create())
, m_pRichContentData(CCArray::create())
, m_touchPriority(kCCMenuHandlerPriority)
, m_bScrollToBottomOnce(false)
{
    CC_SAFE_RETAIN(m_pCanvas);
    m_pCanvas->setPosition(ccp(0.0f, nHeight));
    CC_SAFE_RETAIN(m_pRichContentData);
    if(initWithWidthAndHeight(nWidth, nHeight, kCCTexture2DPixelFormat_Default, 0))
    {
        if(getSprite()!=NULL)
            getSprite()->setAnchorPoint(CCPointZero);
        setContentSize(CCSizeMake(nWidth, nHeight));
        setTouchEnabled(true);
    }
}

CRichTextView::~CRichTextView()
{
    setTouchEnabled(false);
    removeEventListener();
    CC_SAFE_RELEASE(m_pRichContentData);
    m_pCanvas->removeAllChildrenWithCleanup(true);
    CC_SAFE_RELEASE(m_pCanvas);
}

CRichTextView *CRichTextView::create(int nWidth, int nHeight, bool bAutoRedraw, float fContentWidthSize)
{
    CRichTextView *pRet = new CRichTextView(nWidth, nHeight, bAutoRedraw, fContentWidthSize);
    if( pRet != NULL )
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CCLOG("CRichTextView Create Error!");
        return NULL;
    }
}

void CRichTextView::onEnter()
{
    CCRenderTexture::onEnter();
    if( m_bTouchEnabled )
    {
        registerWithTouchDispatcher();
    }
    if( m_bAutoRedraw )
        scheduleUpdate();
}

void CRichTextView::onExit()
{
    if( m_bAutoRedraw )
        unscheduleUpdate();
    unregisterWithTouchDispatcher();
    CCRenderTexture::onExit();
}

void CRichTextView::update(float dt)
{
    CCRenderTexture::update(dt);
    m_pCanvas->update(dt);
    //m_bLayoutDirty = true;
    //m_bStateDirty = true;
    if( m_bAutoScrollDown )
    {
        scrollToBottom();
    }
    else
    {
        if( m_bScrollToBottomOnce )
        {
            scrollToBottom();
            m_bScrollToBottomOnce = false;
        }
    }
}

void CRichTextView::scrollToBottom()
{
    CCSize displaySize = getContentSize();
    CCSize scrollSize = getScrollSize();
    if( displaySize.height > scrollSize.height )
        return;
    CCPoint scrollToPoint = ccp(0,displaySize.height - scrollSize.height);
    scrollTo(scrollToPoint);
}

void CRichTextView::visit()
{
    CCRenderTexture::visit();
    if( m_bLayoutDirty )
    {
        layoutChildren();
    }
    if( m_bStateDirty )
    {
        drawCanvas();
    }
    m_bLayoutDirty = false;
    m_bStateDirty = false;
}

CRichTextStyle &CRichTextView::getCurrentStyle()
{
    return m_currentStyle;
}

void CRichTextView::setCurrentStyle(CRichTextStyle &rStyle)
{
    m_currentStyle = rStyle;
}

ccColor4B CRichTextView::getBackgroundColor()
{
    return m_backgroundColor;
}

void CRichTextView::setBackgroundColor(ccColor4B &rColor)
{
    m_backgroundColor = rColor;
    m_bStateDirty = true;
}

void CRichTextView::drawCanvas()
{
    m_pCanvas->setPositionY( getContentSize().height - m_scrollPoint.y );
    //begin();
    //rbga
    beginWithClear((float)m_backgroundColor.r / 255.0f, (float)m_backgroundColor.g / 255.0f, (float)m_backgroundColor.b / 255.0f, (float)m_backgroundColor.a / 255.0f);
    
    m_pCanvas->visit();
    end();
}

bool CRichTextView::isChildVisible(CCNode *pNode)
{
    return true;
}

void CRichTextView::scrollToBottomNextFrame()
{
    m_bScrollToBottomOnce = true;
}

void CRichTextView::layoutChildren()
{
    m_pCanvas->removeAllChildrenWithCleanup(true);
    if( m_pRichContentData->count() == 0 )
        return;
    //CCNode *pCurrentNode = NULL;
    
    int nLineNum = 0;
    float fCurrentLineLeft = 0.0f;
    int fCurrentLineHeight = 0.0f;
    
    map<int, float> mapLineHeights;
    for( unsigned int i = 0 ; i < m_pRichContentData->count() ; i++ )
    {
        map<int, float>::iterator lineHeightIterator = mapLineHeights.find( nLineNum );
        if( lineHeightIterator != mapLineHeights.end() )
        {
            fCurrentLineHeight = lineHeightIterator->second;
        }
        
        CRichContentData *pCurrentData = dynamic_cast<CRichContentData *>( m_pRichContentData->objectAtIndex(i) );
        // check the type
        CCString *pStringData = dynamic_cast<CCString *>(pCurrentData->getData());
        if( pStringData != NULL )
        {
            CRichTextMetric *pTextMetric = CRichTextStyleDataCache::getData(pCurrentData->m_Style);
            if( pTextMetric == NULL )
                break;
            
            string formattedSentence = "";
            float fIncreateLeft = 0.0f;
            for( unsigned j = 0 ; j < pStringData->length() ; j++ )
            {
                string::const_reference charCode = pStringData->m_sString.at( j );
                int nCharWide = (charCode < 0 || charCode > 128) ? 2 : 1;
                char szChar[4] = {0,0,0,0};
                float fCharWidth = 0.0f;
                if( nCharWide == 2 )
                {
                    szChar[0] = pStringData->m_sString.at( j );
                    szChar[1] = pStringData->m_sString.at( j + 1 );
                    szChar[2] = pStringData->m_sString.at( j + 2 );
                    j += 2;
                    fCharWidth = pTextMetric->getWideCharWidth();
                }
                else
                {
                    szChar[0] = pStringData->m_sString.at( j );
                    fCharWidth = pTextMetric->getCharWidth(szChar[0]);
                }
                if( szChar[0] == '\n' )
                {
                    fIncreateLeft = m_fContentWidthSize + 1;
                    j++;
                }
                if( fCurrentLineHeight < pTextMetric->getCharHeight() )
                {
                    fCurrentLineHeight = pTextMetric->getCharHeight();
                    mapLineHeights[ nLineNum ] = fCurrentLineHeight;
                }
                fIncreateLeft += fCharWidth;
                if( fCurrentLineLeft + fIncreateLeft > m_fContentWidthSize )
                {//no need to do word warp
                    //back j
                    if( nCharWide == 2 )
                        j -= 3;
                    else
                        j -= 1;
                    
                    //
                    drawString(formattedSentence.c_str(), pCurrentData->m_Style, fCurrentLineLeft, -0.0f, nLineNum, pCurrentData);
                    //
                    formattedSentence.clear();
                    nLineNum++;
                    fCurrentLineLeft = 0.0f;
                    fIncreateLeft = 0.0f;
                    fCurrentLineHeight = 0.0f;
                }
                else
                {
                    formattedSentence.append( szChar );
                    if( j == pStringData->length() - 1 )
                    {//end
                        drawString(formattedSentence.c_str(), pCurrentData->m_Style, fCurrentLineLeft, -0.0f, nLineNum, pCurrentData);
                        fCurrentLineLeft += fIncreateLeft;
                        fIncreateLeft = 0.0f;
                    }
                }
            }
            continue;
        }// if is string
        
        
        CCNode *pObjectNode = dynamic_cast<CCNode *>(pCurrentData->getData());
        if( pObjectNode != NULL )
        {
            CCSize nodeSize = pObjectNode->getContentSize();
            if( fCurrentLineLeft + nodeSize.width < m_fContentWidthSize )
            {
                if( fCurrentLineHeight < nodeSize.height )
                {
                    fCurrentLineHeight = nodeSize.height;
                    mapLineHeights[ nLineNum ] = fCurrentLineHeight;
                }
                drawNode(pObjectNode, fCurrentLineLeft, 0.0f, nLineNum, pCurrentData);
                fCurrentLineLeft += nodeSize.width;
            }
            else
            {   //another line
                nLineNum++;
                fCurrentLineLeft = 0.0f;
                mapLineHeights[ nLineNum ] = nodeSize.height;
                drawNode(pObjectNode, fCurrentLineLeft, 0.0f, nLineNum, pCurrentData);
                fCurrentLineLeft += nodeSize.width;
            }
            continue;
        }// if is node
        
        
    }//end for all rich content data
    
    //layout by line num
    CCArray *pChildren = m_pCanvas->getChildren();
    float fLineOffset = 0.0f;
    m_scrollSize.height = 0.0f;
    for( int nLine = 0 ; nLine <= nLineNum ; nLine++ )
    {
        float fLineHeight = 0.0f;
        map<int, float>::iterator lineIter = mapLineHeights.find(nLine);
        if( lineIter == mapLineHeights.end() )
            break;
        fLineHeight = lineIter->second;
        m_scrollSize.height += fLineHeight;
        fLineOffset -= fLineHeight;
        for( int i = 0 ; i < pChildren->count() ; i++ )
        {
            CRichContentText *pText = dynamic_cast<CRichContentText *>( pChildren->objectAtIndex(i));
            if( pText != NULL && pText->getLineNumber() == nLine )
            {
                pText->setPositionY(fLineOffset);
                continue;
            }
            CRichContentNode *pNode = dynamic_cast<CRichContentNode *>( pChildren->objectAtIndex(i));
            if( pNode != NULL && pNode->getLineNumber() == nLine )
            {
                pNode->setPositionY(fLineOffset);
                continue;
            }
        }
    }
    //CCLOG("%d scroll Height = %.2f", getZOrder(), m_scrollSize.height);
}


void CRichTextView::drawString(const char *lpcszString, CRichTextStyle &style, float fPosX, float fPosY, int nLineNum, CRichContentData *pData)
{
    CRichContentText *pLabelText = CRichContentText::create(lpcszString, style);
    if( pLabelText != NULL )
    {
        pLabelText->setPosition(ccp(fPosX, fPosY));
        pLabelText->setLineNumber(nLineNum);
        pLabelText->copyFrom(pData);
        m_pCanvas->addChild(pLabelText);
    }
}

void CRichTextView::drawNode(CCNode *pNode, float fPosX, float fPosY, int nLineNum, CRichContentData *pData)
{
    CRichContentNode *pObjectNode = CRichContentNode::create(pNode);
    if( pObjectNode != NULL )
    {
        pObjectNode->setPosition(ccp(fPosX, fPosY));
        pObjectNode->setLineNumber(nLineNum);
        pObjectNode->copyFrom(pData);
        m_pCanvas->addChild(pObjectNode);
    }
}



void CRichTextView::appendRichText(const char *lpcszData, const char *lpcszActionName, std::vector<string> *lpVecActionArgs)
{
    CRichContentData *pData = CRichContentData::create(CCStringMake(lpcszData));
    if( pData != NULL )
    {
        pData->m_Style = m_currentStyle;
        pData->setActionName(lpcszActionName);
        if( lpVecActionArgs != NULL )
        {
            int i = 0;
            for( std::vector<string>::iterator it = lpVecActionArgs->begin();
                it != lpVecActionArgs->end(); it++ )
            {
                pData->setActionArgString( i++, it->c_str() );
            }
        }
    }
    m_pRichContentData->addObject(pData);
    m_bStateDirty = true;
    m_bLayoutDirty = true;
}

void CRichTextView::appendRichNode(const cocos2d::CCNode *lpcData, const char *lpcszActionName, std::vector<string> *lpVecActionArgs)
{
    CRichContentData *pData = CRichContentData::create((CCObject *)lpcData);
    if( pData != NULL )
    {
        pData->m_Style = m_currentStyle;
        pData->setActionName(lpcszActionName);
        if( lpVecActionArgs != NULL )
        {
            int i = 0;
            for( std::vector<string>::iterator it = lpVecActionArgs->begin();
                it != lpVecActionArgs->end(); it++ )
            {
                pData->setActionArgString( i++, it->c_str() );
            }
        }
    }
    m_pRichContentData->addObject(pData);
    m_bStateDirty = true;
    m_bLayoutDirty = true;
}





//
bool CRichTextView::getTouchEnabled()
{
    return m_bTouchEnabled;
}

void CRichTextView::setTouchEnabled(bool bTouchEnabled)
{
    if( m_bTouchEnabled != bTouchEnabled )
    {
        if( isRunning() )
        {
            if( bTouchEnabled )
            {
                registerWithTouchDispatcher();
            }
            else
            {
                unregisterWithTouchDispatcher();
            }
        }
        m_bTouchEnabled = bTouchEnabled;
    }
}

void CRichTextView::registerWithTouchDispatcher()
{
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, m_touchPriority, false);
}

void CRichTextView::unregisterWithTouchDispatcher()
{
    CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
}

bool CRichTextView::containsPoint(CCTouch *pTouch)
{
    return containsPoint(convertTouchToNodeSpaceAR(pTouch));
}

bool CRichTextView::containsPoint(const CCPoint &rPoint)
{
    CCSize size = getContentSize();
    return (rPoint.x >= 0.0f && rPoint.x <= size.width) && (rPoint.y <= 0 && rPoint.y >= -size.height);
}

bool CRichTextView::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
    if( !isVisible() )
        return false;
    if( !m_bAutoScrollDown )
    {
        CCSize displaySize = getContentSize();
        CCSize scrollSize = getScrollSize();
        if( displaySize.height > scrollSize.height )
        {
            return false;
        }
    }
    if(containsPoint(pTouch))
    {
        m_PointTouchInit = CCDirector::sharedDirector()->convertToGL( pTouch->getLocationInView() );
        return true;
    }
    else
    {
        return false;
    }
}

void CRichTextView::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent)
{
    return;
    CCSize size = getContentSize();
    float fOffsetY = pTouch->getPreviousLocationInView().y - pTouch->getLocationInView().y;
    if( (m_scrollPoint.y == 0.0f && fOffsetY < 0.0f) || (m_scrollPoint.y == -(m_scrollSize.height - size.height) && fOffsetY > 0.0f) )
    {
        
    }
    else if( m_scrollPoint.y - fOffsetY > 0.0f )
    {
        m_scrollPoint.y = 0.0f;
        m_bStateDirty = true;
    }
    else if( m_scrollPoint.y - fOffsetY <  -(m_scrollSize.height - size.height) )
    {
        m_scrollPoint.y =  -(m_scrollSize.height - size.height);
        m_bStateDirty = true;
    }
    else
    {
        m_scrollPoint.y -= fOffsetY;
        m_bStateDirty = true;
    }
}

void CRichTextView::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent)
{
    if( ccpDistance(CCDirector::sharedDirector()->convertToGL( pTouch->getLocationInView() ), m_PointTouchInit) < 5.0f )
    {
        CCPoint uiPoint = convertToNodeSpaceAR(m_PointTouchInit);
        
        uiPoint.y -= /*(getContentSize().height)*/ - m_scrollPoint.y;

        CCArray *pChildren = m_pCanvas->getChildren();
        if( pChildren == NULL || pChildren->count() == 0 )
            return;
        CCObject *pElement = NULL;
        CCARRAY_FOREACH(pChildren, pElement)
        {
            CRichContentText *pText = dynamic_cast<CRichContentText *>(pElement);
            if( pText != NULL )
            {
                const char *lpcszActionName = pText->getActionName();
                if( lpcszActionName == NULL || strlen(lpcszActionName) == 0 )
                    continue;
                if( pText->boundingBox().containsPoint(uiPoint) )
                {
                    if( m_pListenerTarget != NULL && m_CommandHandler != NULL )
                    {
                        NowTouchPoint = pTouch->getLocation();

                        (m_pListenerTarget->*m_CommandHandler)( pText );
                    }
                }
                
                continue;
            }
            CRichContentNode *pNode = dynamic_cast<CRichContentNode *>(pElement);
            if( pNode != NULL )
            {
                const char *lpcszActionName = pNode->getActionName();
                if( lpcszActionName == NULL || strlen(lpcszActionName) == 0 )
                    continue;
                

                if( pNode->boundingBox().containsPoint(uiPoint) )
                {
                    if( m_pListenerTarget != NULL && m_CommandHandler != NULL )
                    {
                        NowTouchPoint = pTouch->getLocation();
                        (m_pListenerTarget->*m_CommandHandler)( pNode );
                    }
                }
                
                continue;
            }
        }
    }
}

void CRichTextView::clearAll()
{
    m_pRichContentData->removeAllObjects();
    m_bLayoutDirty      = true;
    m_bStateDirty       = true;
    m_scrollPoint       = CCPointZero;
    m_scrollSize.height = 0.0;
}

void CRichTextView::ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent)
{
}

void CRichTextView::scrollTo(const CCPoint &_scrollPoint)
{
    m_scrollPoint = _scrollPoint;
    m_bStateDirty = true;
}

CCSize &CRichTextView::getScrollSize()
{
    return m_scrollSize;
}

CCPoint &CRichTextView::getScrollPoint()
{
    return m_scrollPoint;
}

void CRichTextView::setEventListener(CCObject *pTarget, RichTextViewCommandHandler handler)
{
    m_pListenerTarget = pTarget;
    m_CommandHandler = handler;
}

void CRichTextView::removeEventListener()
{
    m_pListenerTarget = NULL;
    m_CommandHandler = NULL;
}

void CRichTextView::setTouchPriority(int nPriority)
{
    if( m_touchPriority != nPriority )
    {
        m_touchPriority = nPriority;
        bool btouchEnabled = getTouchEnabled();
        if( btouchEnabled )
        {
            setTouchEnabled(false);
            setTouchEnabled(true);
        }
    }
}

int CRichTextView::getTouchPriority()
{
    return m_touchPriority;
}
