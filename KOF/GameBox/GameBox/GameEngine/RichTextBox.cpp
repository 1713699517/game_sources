//
//  RichTextBox.cpp
//  GameBox
//
//  Created by Caspar on 2013-7-11.
//
//

#include "RichTextBox.h"
#include "LuaScriptFunctionInvoker.h"

using namespace ptola::gui;
using namespace ptola::script;

MEMORY_MANAGE_OBJECT_IMPL(CRichTextBox);

CRichTextBox::CRichTextBox(const CCSize &_size, ccColor4B &_backgroundColor)
: m_pRichTextView( CRichTextView::create(_size.width, _size.height, true, _size.width) )
{
    m_pRichTextView->setBackgroundColor(_backgroundColor);
    addChild(m_pRichTextView);

    m_pRichTextView->setEventListener(this, richtextview_selector(CRichTextBox::onRichTextBoxCallBack) );
    setTouchesEnabled(true);
}

CRichTextBox::~CRichTextBox()
{
    
}

CRichTextBox *CRichTextBox::create(const cocos2d::CCSize &_size, ccColor4B &_backgroundColor)
{
    CRichTextBox *pRet = new CRichTextBox( _size, _backgroundColor );
    if( pRet != NULL )
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

void CRichTextBox::setBackgroundColor(ccColor4B &rColor)
{
    m_pRichTextView->setBackgroundColor(rColor);
}

bool CRichTextBox::containsPoint(CCPoint *rPoint)
{
    return m_pRichTextView->containsPoint(*rPoint);
}

bool CRichTextBox::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    if( !CUserControl::ccTouchBegan(pTouch, pEvent) )
        return false;
    return m_pRichTextView->ccTouchBegan(pTouch, pEvent);
}

void CRichTextBox::ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    CUserControl::ccTouchMoved(pTouch, pEvent);
    m_pRichTextView->ccTouchMoved(pTouch, pEvent);
}

void CRichTextBox::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    CUserControl::ccTouchEnded(pTouch, pEvent);
    m_pRichTextView->ccTouchEnded(pTouch, pEvent);
}

void CRichTextBox::scrollTo(const cocos2d::CCPoint &_scrollPoint)
{
    return m_pRichTextView->scrollTo(_scrollPoint);
}

CCPoint &CRichTextBox::getScrollPoint()
{
    return m_pRichTextView->getScrollPoint();
}

CCSize &CRichTextBox::getScrollSize()
{
    return m_pRichTextView->getScrollSize();
}

void CRichTextBox::scrollToBottom()
{
    m_pRichTextView->scrollToBottom();
}

void CRichTextBox::clearAll()
{
    m_pRichTextView->clearAll();
}

void CRichTextBox::setAutoScrollDown(bool bAutoScrollDown)
{
    m_pRichTextView->setAutoScrollDown(bAutoScrollDown);
}

bool CRichTextBox::getAutoScrollDown()
{
    return m_pRichTextView->getAutoScrollDown();
}

void CRichTextBox::scrollToBottomNextFrame()
{
    m_pRichTextView->scrollToBottomNextFrame();
}

void CRichTextBox::setCurrentStyle(const char *lpcszFontFamily, float fFontSize, ccColor4B &color)
{
    CRichTextStyle style;
    style.szFontFamily = lpcszFontFamily;
    style.fFontSize = fFontSize;
    style.cFontColor = color;
    m_pRichTextView->setCurrentStyle(style);
}

void CRichTextBox::appendRichText(const char *lpcszData, const char *lpcszActionName, const char *Arg0, const char *Arg1, const char *Arg2, const char *Arg3 , const char *Arg4)
{
    if( lpcszActionName != NULL )
    {
        std::vector<std::string> args;
        if( Arg0 != NULL )
            args.push_back(Arg0);
        if( Arg1 != NULL )
            args.push_back(Arg1);
        if( Arg2 != NULL )
            args.push_back(Arg2);
        if( Arg3 != NULL )
            args.push_back(Arg3);
        if( Arg4 != NULL )
            args.push_back(Arg4);
        m_pRichTextView->appendRichText(lpcszData, lpcszActionName, &args);
    }
    else
    {
        m_pRichTextView->appendRichText(lpcszData);
    }
}

void CRichTextBox::appendRichNode(const CCNode *lpcData, const char *lpcszActionName, const char *Arg0, const char *Arg1, const char *Arg2, const char *Arg3 , const char *Arg4)
{
    if( lpcszActionName != NULL )
    {
        std::vector<std::string> args;
        if( Arg0 != NULL )
            args.push_back(Arg0);
        if( Arg1 != NULL )
            args.push_back(Arg1);
        if( Arg2 != NULL )
            args.push_back(Arg2);
        if( Arg3 != NULL )
            args.push_back(Arg3);
        if( Arg4 != NULL )
            args.push_back(Arg4);
        m_pRichTextView->appendRichNode(lpcData, lpcszActionName, &args);
    }
    else
    {
        m_pRichTextView->appendRichNode(lpcData);
    }
}

void CRichTextBox::onRichTextBoxCallBack(const ptola::gui::CReactContent *pContent)
{
    CLuaScriptFunctionInvoker::executeRichTextScript(m_pControlScriptHandler, pContent->m_actionName.c_str(), &pContent->m_actionArgs);
}