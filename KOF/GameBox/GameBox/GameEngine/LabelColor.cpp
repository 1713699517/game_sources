//
//  LabelColor.cpp
//  GameBox
//
//  Created by Caspar on 13-7-29.
//
//

#include "LabelColor.h"

using namespace ptola::gui;

CLabelColor *CLabelColor::create()
{
    CLabelColor *pRet = new CLabelColor;
    if( pRet != NULL && pRet->init() )
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

bool CLabelColor::init()
{
    m_fPosX = 0.0f;
    m_nCount = 0;
    setAnchorPoint(ccp(0.5f, 0.5f));
    return CUserControl::init();
}

void CLabelColor::appendText(const char *pText, const ccColor4B &pColor, const char *lpcszFamilyName, float fFontSize)
{
    if( pText == NULL || lpcszFamilyName == NULL )
        return;
    if( strlen(pText) == 0 )
        return;
    CCLabelTTF *pLabel = CCLabelTTF::create(pText, lpcszFamilyName, fFontSize);
    pLabel->setColor(ccc3(pColor.r, pColor.g, pColor.b));
    pLabel->setOpacity(pColor.a);
    pLabel->setAnchorPoint(ccp(0.0f,0.5f));
    pLabel->setPosition(ccp(m_fPosX, 0.0f));
    pLabel->setTag(m_nCount++);
    m_fPosX += pLabel->getTexture()->getContentSize().width;
    addChild(pLabel);
    performLayout();
}

void CLabelColor::performLayout()
{
    for( int i = 0 ; i < m_nCount ; i++ )
    {
        CCLabelTTF *pLabel = dynamic_cast<CCLabelTTF *>(getChildByTag(i));
        if( pLabel == NULL )
            continue;
        pLabel->setPosition(ccp(0-pLabel->getTexture()->getContentSize().width/2, 0.0f));
    }
}

void CLabelColor::appendText(const char *pText, const char *lpcszFamilyName, float fFontSize)
{
    if( pText == NULL || lpcszFamilyName == NULL )
        return;
    ccColor4B currentColor = ccc4(255,255,255,255);
    std::string strToDraw;
    const char *lpcszStart = pText;
    const char *lpcszIndex = strstr(lpcszStart, "<color:");
    if( lpcszIndex == NULL )
    {
        appendText(pText, currentColor, lpcszFamilyName, fFontSize);
        return;
    }
    //开头
    if( lpcszIndex > lpcszStart )
    {
        strToDraw.assign(pText, (size_t)(lpcszIndex - lpcszStart));
        appendText(strToDraw.c_str(), currentColor, lpcszFamilyName, fFontSize);
        lpcszIndex += 7;
        lpcszStart = lpcszIndex;
    }
    //
    while( lpcszIndex != NULL )
    {
        lpcszIndex = strstr( lpcszStart, ">" );
        if( lpcszIndex > lpcszStart )
        {   //color
            lpcszStart += 7;
            unsigned char c4c[4] = {255,255,255,255};
            for( int i = 0 ; i < 4 ; i++ )
            {
                const char *lpcszSpliter = strstr(lpcszStart, (i == 3 ? ">" : ","));
                if( lpcszSpliter == NULL )
                {
                    strToDraw.assign(lpcszStart, (size_t)(lpcszIndex - lpcszStart));
                }
                else
                {
                    strToDraw.assign(lpcszStart, (size_t)(lpcszSpliter - lpcszStart));
                }
                c4c[i] = atoi( strToDraw.c_str() );
                lpcszStart = lpcszSpliter + 1;
            }
            currentColor = ccc4(c4c[0], c4c[1], c4c[2], c4c[3]);
            lpcszStart = lpcszIndex + 1;
            lpcszIndex = strstr( lpcszStart, "<color:" );
        }
        if( lpcszIndex == NULL )
        {
            strToDraw.assign(lpcszStart);
            appendText(strToDraw.c_str(), currentColor, lpcszFamilyName, fFontSize);
        }
        else if( lpcszIndex > lpcszStart )
        {
            strToDraw.assign(lpcszStart, (size_t)(lpcszIndex - lpcszStart));
            appendText(strToDraw.c_str(), currentColor, lpcszFamilyName, fFontSize);
            lpcszStart = lpcszIndex;
        }
    }
}



