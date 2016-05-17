//
//  Sprite.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-6.
//
//

#include "Sprite.h"
#include "MemoryAllocator.h"


using namespace ptola::event;
using namespace ptola::memory;

using namespace ptola::gui;


MEMORY_MANAGE_OBJECT_IMPL(CSprite);

CSprite::CSprite()
: m_pSprite(NULL)
, m_bGray(false)
{

}

CSprite::~CSprite()
{

}

CSprite *CSprite::create(const char *lpcszResourceName)
{
    return create(lpcszResourceName, CCRectZero);
}

bool CSprite::init(const char *lpcszResourceName)
{
    return init( lpcszResourceName, CCRectZero );
}

CSprite *CSprite::create(const char *lpcszResourceName, const cocos2d::CCRect &rect)
{
    CSprite *pRet = new CSprite;
    if( pRet != NULL && pRet->init(lpcszResourceName, rect) )
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

bool CSprite::init(const char *lpcszResourceName, const cocos2d::CCRect &rect)
{
    if( !CUserControl::init() )
        return onInitialized(false);
    
    setAnchorPoint(ccp(0.5f, 0.5f));

    m_pSprite = CSpriteRGBA::create(lpcszResourceName, rect);
    //m_pSprite = CCScale9Sprite::create(lpcszResourceName, rect);
    addChild(m_pSprite);
    return onInitialized(true);
}

bool CSprite::initWithSpriteFrameName(const char *lpcszResourceName)
{
    return initWithSpriteFrameName( lpcszResourceName, CCRectZero );
}

CSprite *CSprite::createWithSpriteFrameName(const char *lpcszResourceName)
{
    CSprite *pRet = new CSprite;
    if( pRet != NULL && pRet->initWithSpriteFrameName(lpcszResourceName) )
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

bool CSprite::initWithSpriteFrameName(const char *lpcszResourceName, const cocos2d::CCRect &rect)
{
    if( !CUserControl::init() )
        return onInitialized(false);
    m_pSprite = CSpriteRGBA::createWithSpriteFrameName(lpcszResourceName, rect);
    //m_pSprite = CCScale9Sprite::createWithSpriteFrameName(lpcszResourceName, rect);
    m_pSprite->setColor(ccc3(255,0,0));
    setAnchorPoint(ccp(0.5f, 0.5f));
    addChild(m_pSprite);
    return onInitialized(true);
}

CSprite *CSprite::createWithSpriteFrameName(const char *lpcszResourceName, const cocos2d::CCRect &rect)
{
    CSprite *pRet = new CSprite;
    if( pRet != NULL && pRet->initWithSpriteFrameName(lpcszResourceName, rect) )
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

void CSprite::setOpacity(GLubyte opacity)
{
    m_pSprite->setOpacity(opacity);
}

GLubyte CSprite::getOpacity()
{
    return m_pSprite->getOpacity();
}


bool CSprite::containsPoint(CCPoint *pPoint)
{
    if( m_pSprite == NULL )
        return false;
    return m_pSprite->boundingBox().containsPoint(*pPoint);
}

CCSize CSprite::getPreferredSize()
{
    if( m_pSprite == NULL )
        return CCSizeZero;
    return m_pSprite->getPreferredSize();
}

void CSprite::setPreferredSize(const CCSize &size)
{
    if( m_pSprite != NULL )
        m_pSprite->setPreferredSize(size);
}

void CSprite::flipHorizontal()
{
    if( m_pSprite != NULL )
        m_pSprite->setScaleX(0.0f - m_pSprite->getScaleX());
}

void CSprite::flipVertical()
{
    if( m_pSprite != NULL )
        m_pSprite->setScaleY(0.0f - m_pSprite->getScaleY());
}

void CSprite::setImage(const char *lpcszResourceName)
{
    setImage(lpcszResourceName, CCRectZero);
}

void CSprite::setImage(const char *lpcszResourceName, const cocos2d::CCRect &rect)
{
    if( m_pSprite != NULL )
    {
        m_pSprite->removeFromParentAndCleanup(true);
    }
    init( lpcszResourceName, rect );
}

void CSprite::setImageWithSpriteFrameName(const char *lpcszResourceName)
{
    setImageWithSpriteFrameName(lpcszResourceName, CCRectZero);
}

void CSprite::setImageWithSpriteFrameName(const char *lpcszResourceName, const cocos2d::CCRect &rect)
{
    if( m_pSprite != NULL )
    {
        m_pSprite->removeFromParentAndCleanup(true);
    }
    initWithSpriteFrameName(lpcszResourceName, rect);
}

void CSprite::setGray(bool bGray)
{
    if( m_bGray != bGray )
    {
        if(m_pSprite != NULL)
        {
            if( bGray )
                m_pSprite->shaderDotColor(0.299f, 0.587f, 0.114f, 1.0f);
            else
                m_pSprite->shaderResetNull();
        }
        m_bGray = bGray;
    }
}

bool CSprite::getGray()
{
    return m_bGray;
}

void CSprite::shaderDotColor(float r, float g, float b, float a)
{
    if(m_pSprite != NULL)
        m_pSprite->shaderDotColor(r, g, b, a);
}

void CSprite::shaderDotColor(int r, int g, int b, int a)
{
    if(m_pSprite != NULL)
        m_pSprite->shaderDotColor((float)r / 255.0f, (float)g / 255.0f , (float)b / 255.0f, (float)a / 255.0f);
}

void CSprite::shaderDotColor(const ccColor4F &_color)
{
    if(m_pSprite != NULL)
        m_pSprite->shaderDotColor(_color.r, _color.g, _color.b, _color.a);
}

void CSprite::shaderDotColor(const ccColor4B &_color)
{
    if(m_pSprite != NULL)
        m_pSprite->shaderDotColor(_color.r, _color.g, _color.b, _color.a);
}


void CSprite::shaderMulColor(float r, float g, float b, float a)
{
    if(m_pSprite != NULL)
        m_pSprite->shaderMulColor(r, g, b, a);
}

void CSprite::shaderMulColor(int r, int g, int b, int a)
{
    if(m_pSprite != NULL)
        m_pSprite->shaderMulColor(r, g, b, a);
}

void CSprite::shaderMulColor(const ccColor4F &_color)
{
    if(m_pSprite != NULL)
        m_pSprite->shaderMulColor(_color.r, _color.g, _color.b, _color.a);
}

void CSprite::shaderMulColor(const ccColor4B &_color)
{
    if(m_pSprite != NULL)
        m_pSprite->shaderMulColor(_color.r, _color.g, _color.b, _color.a);
}

void CSprite::shaderResetNull()
{
    if(m_pSprite != NULL)
        m_pSprite->shaderResetNull();
}