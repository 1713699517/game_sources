//
//  RichTextView.h
//  RichTextView
//
//  Created by Mac on 13-4-10.
//
//


#ifndef __RichTextView__RichTextView__
#define __RichTextView__RichTextView__

#include "cocos2d.h"
#include <vector>
#include <map>

USING_NS_CC;
using namespace std;

namespace ptola
{
namespace gui
{
    /*
     not implement yet
     */
    enum enumTextStyle
    {
         eTS_Normal     = 0x0
        ,eTS_Bold       = 0x1
        ,eTS_Underline  = 0x2
        ,eTS_Deleteline = 0x4
    };

    class CRichTextStyle
    {
    public:
        CRichTextStyle();
        CRichTextStyle(const CRichTextStyle &rhs);
        CRichTextStyle &operator =(const CRichTextStyle &rhs);
        bool operator ==(const CRichTextStyle &rhs) const;
        bool operator !=(const CRichTextStyle &rhs) const;
        bool operator <(const CRichTextStyle &rhs) const;
        string szFontFamily;            //font name, font family
        float fFontSize;                //font size
        ccColor4B cFontColor;           //font color , use ccc4 to create color example:  ccc4(r,b,g,a)
        enumTextStyle eStyle;           //not implement yet
    };
    
    class CRichTextMetric
    {
    public:
        CC_SYNTHESIZE(float, m_fWideCharWidth, WideCharWidth);
        CC_SYNTHESIZE(float, m_fCharHeight, CharHeight);
        float getCharWidth(char ch);
    public:
        map<char, float> mapCharsWidth;
    };
    
    class CRichTextStyleDataCache
    {
    public:
        static CRichTextMetric *getData( CRichTextStyle &style );
    };
    
    class CReactContent
    {
    public:
        CC_SYNTHESIZE(int, m_nLineNum, LineNumber);
    public:
        const char *getActionName();
        void setActionName(const char *var);
        
        int getActionArgInt(int nArgIndex);
        const char *getActionArgString(int nArgIndex);
        
        void setActionArgString(int nArgIndex, const char *var);
        void setActionArgInt(int nArgIndex, int var);
        
        size_t getActionArgCount();
        string m_actionName;
        virtual void copyFrom(const CReactContent *pContent);
    public:
       
        std::vector<std::string> m_actionArgs;
    };
    
    class CRichContentData : public CCObject, public CReactContent
    {
    public:
        CRichContentData(CCObject *pObject);
        static CRichContentData *create(CCObject *pObject);
        ~CRichContentData();
        
        CC_SYNTHESIZE_RETAIN(CCObject *, m_Data, Data);
    
        CRichTextStyle m_Style;
    };
    
    class CRichContentText : public CCLabelTTF, public CReactContent
    {
    public:
        CRichContentText(const char *lpcszString, const CRichTextStyle &var);
        static CRichContentText *create(const char *lpcszString, const CRichTextStyle &var);
        
        virtual const CRichTextStyle &getStyle();
        virtual void setStyle(CRichTextStyle &var);
//        virtual void draw();
//        virtual void visit();
    private:
        CRichTextStyle m_cStyle;
    };
    
    class CRichContentNode : public CCNode, public CReactContent
    {
    public:
        CRichContentNode(const CCNode *pData);
        static CRichContentNode *create(const CCNode *pData);
        
        CC_SYNTHESIZE_READONLY(CCNode *, m_pData, Data);
    };
    
    
    /*
     view command handler
     call back when content's has action
     
     @example:
        void SomeClass::onRichTextViewCommand(const CReactContent *pReaction)
        {
            const char *lpcszCommandName = pReaction->getActionName();  //actionName
            size_t uArgumentCount = pReaction->getActionArgCount();     //arguments length
            
            int arg0 = pReaction->getActionArgInt(0);                   //index of the arguments, get the first argument, it starts at zero.
            int arg1 = pReaction->getActionArgInt(1);                   //get the second argument
            
            const char *arg2 = pReaction->getActionArgString(2);        //get the third argument as a const char *
            
            //and you can get the first argument as a const char * either.
            const char *szArg0 = pReaction->getActionArgString(0);      //the data of value is saved as a string.
     
            //do something....
        }
     
     */
    typedef void (cocos2d::CCObject::*RichTextViewCommandHandler)(const CReactContent *);
#define richtextview_selector(_SELECTOR) ((RichTextViewCommandHandler)(&_SELECTOR))
    
    
    
    /*
     the rich text view
     
     @example:
        CRichTextView *pTextView = CRichTextView::create( 200, 300, true, 200 );
        pTextView->setEventListener( this, richtextview_selector(SomeClass::onRichTextViewCommand) );
        
        //change render style
        CRichTextStyle style = pTextView->getCurrentStyle();
        style.szFontFamily = "Verdana"; //change the font family
        style.fFontSize = 30.0f;        //change the font size to 30.0f
        style.cColor = ccc4(0,255,0,128);   //change the font color to half opacity and green
        style.eStyle = ...              //not implement yet
        pTextView->setCurrentStyle(style);
     
        //add text content
        pTextView->appendRichText("some text test");    //add normal text
     
        pTextView->appendRichText("some react text", "actionName");     //add reacted text, when touch it, it will fire the RichTextViewCommandHandler.
     
        std::vector<string> args;
        args.push_back("1001");
        args.push_back("stringArgu");
        pTextView->appendRichText("some react text with args", "actionName", &args);   //add reacted text, when touch it, it will fire the RichTextViewCommandHandler.
     
        //add node content
        CCSprite *pico = CCSprite::create("CloseNormal.png");
        pTextView->appendRichNode(pico);                //add a image
        
        pTextView->appendRichNode(pico, "actionName");  //add reacted image, when touch it, it will fire the RichTextViewCommandHandler.
        
        std::vector<string> args;
        args.push_back("strimage");
        args.push_back("103");
        pTextView->appendRichNode(pico, "actionName", &args);  //add reacted image, when touch it, it will fire the RichTextViewCommandHandler.
     
     */
    class CRichTextView : public CCRenderTexture, public CCTargetedTouchDelegate
    {
    public:
        /*
         @param nWidth the width of the control
         @param nHeight the height of the control
         @param bAutoRedraw open the update schedule if it's true
         @param fContentWidthSize the size of scroll width, usually equals to width.
         
         !important
            do not change the size in runtime!!! error occurs
         
         */
        CRichTextView(int nWidth, int nHeight, bool bAutoRedraw, float fContentWidthSize);
        ~CRichTextView();
        static CRichTextView *create(int nWidth, int nHeight, bool bAutoRedraw, float fContentWidthSize);
        ccColor4B getBackgroundColor();
        void setBackgroundColor(ccColor4B &rColor);
        
    public:
        //event listener
        static CCPoint NowTouchPoint;
        void setEventListener(CCObject *pTarget, RichTextViewCommandHandler handler);
        void removeEventListener();
    private:
        CCObject *m_pListenerTarget;
        RichTextViewCommandHandler m_CommandHandler;
        
        //touch relatives
    public:
        bool containsPoint(CCTouch *pTouch);
        bool containsPoint(const CCPoint &rPoint);
    public:
        virtual void setTouchEnabled(bool bTouchEnabled);
        bool getTouchEnabled();
        virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
        // optional
        virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
        virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
        virtual void ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent);
    protected:
        virtual void registerWithTouchDispatcher();
        virtual void unregisterWithTouchDispatcher();
        
        
        
        
    public:
        void clearAll();
        void appendRichText(const char *lpcszData, const char *lpcszActionName = NULL, std::vector<string> *lpVecActionArgs = NULL);
        void appendRichNode(const CCNode *lpcData, const char *lpcszActionName = NULL, std::vector<string> *lpVecActionArgs = NULL);
        
        CRichTextStyle &getCurrentStyle();
        void setCurrentStyle(CRichTextStyle &rStyle);
        
        virtual void onEnter();
        virtual void onExit();
        virtual void update(float dt);
        virtual void visit();
        
        void scrollTo(const CCPoint &_scrollPoint);
        void scrollToBottom();
        void scrollToBottomNextFrame();
        CCSize &getScrollSize();
        CCPoint &getScrollPoint();
    private:
        void drawCanvas();
        
        bool isChildVisible(CCNode *pNode);
        
        void layoutChildren();
        
        void drawString(const char *lpcszString, CRichTextStyle &style, float fPosX, float fPosY, int nLineNum, CRichContentData *pData);
        void drawNode( CCNode *pNode, float fPosX, float fPosY, int nLineNum, CRichContentData *pData);
        
        
        ccColor4B m_backgroundColor;
        
        CCPoint m_scrollPoint;
        CCSize  m_scrollSize;
        CRichTextStyle m_currentStyle;
        CCArray *m_pRichContentData;
        CCNode *m_pCanvas;
        float m_fContentWidthSize;
        
        bool m_bStateDirty;
        bool m_bLayoutDirty;
        
        bool m_bAutoRedraw;
        bool m_bTouchEnabled;
        
        CCPoint m_PointTouchInit;
    private:
        int m_touchPriority;
        bool m_bScrollToBottomOnce;
    public:
        int getTouchPriority();
        void setTouchPriority(int nPriority);
        
        CC_SYNTHESIZE(bool, m_bAutoScrollDown, AutoScrollDown);
    };
}
}

#endif /* defined(__RichTextView__RichTextView__) */

