//
//  EditBox.cpp
//  GameBox
//
//  Created by Mac on 13-5-20.
//
//

#include "EditBox.h"

#include "MemoryAllocator.h"
#include "LuaScriptFunctionInvoker.h"

using namespace ptola::memory;
using namespace ptola::gui;
using namespace ptola::script;


MEMORY_MANAGE_OBJECT_IMPL(CEditBox);


CEditBox::CEditBox()
: m_pEditBox(NULL)
, m_eMode(kEditBoxInputModeAny)
{

}

CEditBox::~CEditBox()
{
    m_pEditBox->setDelegate(NULL);
    CC_SAFE_RELEASE_NULL(m_pEditBox);
}

CEditBox *CEditBox::create(const CCSize &size,CCScale9Sprite* pNormal9SpriteBg,int nMaxLength,const char *lpcszPlaceHolder,EditBoxInputFlag kEditBoxFlag)
{
    CEditBox *pRet = new CEditBox();
    
    if (pRet && pRet->init(size, pNormal9SpriteBg, nMaxLength, lpcszPlaceHolder, kEditBoxFlag))
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

bool CEditBox::init(const CCSize &size,CCScale9Sprite* pNormal9SpriteBg,int nMaxLength,const char *lpcszPlaceHolder,EditBoxInputFlag kEditBoxFlag)
{
    
    if (!CUserControl::init())
    {
        return onInitialized(false);
    }
    
    setAnchorPoint(ccp(0.5f,0.5f));
    setTouchesEnabled(true);
    
    m_pEditBox = CCEditBox::create(size, pNormal9SpriteBg);
    addChild(m_pEditBox);
    
    //m_pEditBox->setText("");
    m_pEditBox->setPlaceHolder(lpcszPlaceHolder);
    
    m_pEditBox->setMaxLength(nMaxLength);
    m_pEditBox->setInputFlag(kEditBoxFlag);
    
    m_pEditBox->setReturnType(kKeyboardReturnTypeDone);
    
    CC_SAFE_RETAIN(m_pEditBox);
    m_pEditBox->setDelegate(this);

    return onInitialized(true);
}

void CEditBox::setTouchesPriority(int nPriority)
{
    m_pEditBox->setTouchPriority(nPriority);
    CUserControl::setTouchesPriority(nPriority);
}


CEditBox *CEditBox::create(const CCSize &size,const char* lpcszNormal9SpriteBg,int nMaxLength,const char *lpcszPlaceHolder,EditBoxInputFlag kEditBoxFlag)
{
    CEditBox *pRet = new CEditBox();
    
    if (pRet && pRet->init(size, lpcszNormal9SpriteBg, nMaxLength, lpcszPlaceHolder, kEditBoxFlag))
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

bool CEditBox::init(const CCSize &size,const char* lpcszNormal9SpriteBg,int nMaxLength,const char *lpcszPlaceHolder,EditBoxInputFlag kEditBoxFlag)
{
    
    
    CCScale9Sprite *pEidtBg = CCScale9Sprite::create(lpcszNormal9SpriteBg);
    
    return init(size, pEidtBg, nMaxLength, lpcszPlaceHolder, kEditBoxFlag);
    
}

void CEditBox::setEditBoxMaxLength(int nMaxLength)
{
    m_pEditBox->setMaxLength(nMaxLength);
}

int CEditBox::getEditBoxMaxLength()
{
    return m_pEditBox->getMaxLength();
}

void CEditBox::setTextString(const char* lpcszLabel)
{
    m_pEditBox->setText(lpcszLabel);
}

const char *CEditBox::getTextString()
{
    return m_pEditBox->getText();
}

void CEditBox::setFont(const char *lpcszFontFamily, float fFontSize)
{
    m_pEditBox->setFont(lpcszFontFamily, fFontSize);
}

void CEditBox::setFontColor(const ccColor3B &_color)
{
    m_pEditBox->setFontColor(_color);
}

void CEditBox::setPosition(const cocos2d::CCPoint &pos)
{
    m_pEditBox->setPosition(pos);
}

void CEditBox::editBoxReturn(cocos2d::extension::CCEditBox *editBox)
{
    //清空一切自带的符号
    char *lpcszText = (char *)editBox->getText();
    char szBuffer[4096] = {0};
    int i = 0;
    while (true)
    {
        int uchChar = ((int)*lpcszText);
        if (uchChar == 0)  //结束
        {
            szBuffer[i] = 0;
            break;
        }
        switch ( uchChar)
        {
            case 0xC2:
            case  -62:  //+2
                lpcszText += 2;
                break;
            case 0xE2:
            case  -30:  
            case 0xE3:
            case  -29:  //+3
                lpcszText += 3;
                break;
            case 0xF0:
            case  -16:  //+4
                lpcszText += 4;
                break;
            default: //有效字符
                szBuffer[i] = (char)*lpcszText;
                lpcszText++;
                i++;
                break;
        }
    }
    editBox->setText(szBuffer);
    //回调
    CLuaScriptFunctionInvoker::executeEditBoxReturnScript( m_pControlScriptHandler, this, "CEditBox", szBuffer);
}


void CEditBox::setEditBoxInputMode(EditBoxInputMode kMode)
{
    m_eMode = kMode;
    m_pEditBox->setInputMode(kMode);
}

EditBoxInputMode CEditBox::getEditBoxInputMode()
{
    return m_eMode;
}










