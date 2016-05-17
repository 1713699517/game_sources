//
//  SpriteRGBA.cpp
//  GameBox
//
//  Created by Caspar on 2013-7-20.
//
//

#include "SpriteRGBA.h"
#include "shaders/CCShaderCache.h"



#define SPRITERGBA_SHADER_DOT_COLOR_FSH "\
#ifdef GL_ES \n \
precision mediump float; \n \
#endif \n \
uniform vec4 v_dotcolor; \n \
uniform sampler2D u_texture; \n \
varying vec2 v_texCoord; \n \
varying vec4 v_fragmentColor; \n \
void main(void){ \n \
vec4 col = texture2D(u_texture, v_texCoord); \n \
float dotr = dot(col.rgb, v_dotcolor.rgb ); \n \
gl_FragColor = vec4(dotr, dotr, dotr, col.a); }"



#define SPRITERGBA_SHADER_MUL_COLOR_FSH "\
#ifdef GL_ES \n \
precision mediump float; \n \
#endif \n \
uniform vec4 v_dotcolor; \n \
uniform sampler2D u_texture; \n \
varying vec2 v_texCoord; \n \
varying vec4 v_fragmentColor; \n \
void main(void){ \n \
vec4 col = texture2D(u_texture, v_texCoord); \n \
gl_FragColor = col.rgba * v_dotcolor.rgba; }"


USING_NS_CC;

using namespace ptola::gui;

CSpriteRGBA::~CSpriteRGBA()
{
}

CSpriteRGBA *CSpriteRGBA::create()
{
    CSpriteRGBA *pRet = new CSpriteRGBA;
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

CSpriteRGBA *CSpriteRGBA::create(const char *file)
{
    CSpriteRGBA *pRet = new CSpriteRGBA;
    if( pRet != NULL && pRet->initWithFile(file) )
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

CSpriteRGBA *CSpriteRGBA::create(CCRect capInsets, const char *file)
{
    CSpriteRGBA *pRet = new CSpriteRGBA;
    if( pRet != NULL && pRet->initWithFile(capInsets, file) )
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

CSpriteRGBA *CSpriteRGBA::create(const char *file, cocos2d::CCRect rect)
{
    CSpriteRGBA *pRet = new CSpriteRGBA;
    if( pRet != NULL && pRet->initWithFile(file, rect) )
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

CSpriteRGBA *CSpriteRGBA::create(const char *file, cocos2d::CCRect rect, cocos2d::CCRect capInsets)
{
    CSpriteRGBA *pRet = new CSpriteRGBA;
    if( pRet != NULL && pRet->initWithFile(file, rect, capInsets) )
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


CSpriteRGBA *CSpriteRGBA::createWithSpriteFrameName(const char *frame)
{
    CSpriteRGBA *pRet = new CSpriteRGBA;
    if( pRet != NULL && pRet->initWithSpriteFrameName(frame))
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

CSpriteRGBA *CSpriteRGBA::createWithSpriteFrameName(const char *frame, cocos2d::CCRect rect)
{
    CSpriteRGBA *pRet = new CSpriteRGBA;
    if( pRet != NULL && pRet->initWithSpriteFrameName(frame, rect))
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


void CSpriteRGBA::shaderDotColor(float r, float g, float b, float a)
{
    CCGLProgram *pShaders = new CCGLProgram;
    pShaders->initWithVertexShaderByteArray(ccPositionTextureColor_vert, SPRITERGBA_SHADER_DOT_COLOR_FSH);
    CHECK_GL_ERROR_DEBUG();
    
    pShaders->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
    pShaders->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
    pShaders->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
    CHECK_GL_ERROR_DEBUG();

    pShaders->link();
    CHECK_GL_ERROR_DEBUG();

    pShaders->updateUniforms();
    CHECK_GL_ERROR_DEBUG();
    
    GLint nDotColorLocation = pShaders->getUniformLocationForName("v_dotcolor");
    pShaders->setUniformLocationWith4f(nDotColorLocation, r, g, b, a);

    scale9Image->setShaderProgram(pShaders);
    CHECK_GL_ERROR_DEBUG();

    pShaders->release();
}

void CSpriteRGBA::shaderDotColor(int r, int g, int b, int a)
{
    shaderDotColor((float)r / 255.0f, (float)g / 255.0f , (float)b / 255.0f, (float)a / 255.0f);
}

void CSpriteRGBA::shaderDotColor(const ccColor4F &_color)
{
    shaderDotColor(_color.r, _color.g, _color.b, _color.a);
}

void CSpriteRGBA::shaderDotColor(const ccColor4B &_color)
{
    shaderDotColor(_color.r, _color.g, _color.b, _color.a);
}


void CSpriteRGBA::shaderMulColor(float r, float g, float b, float a)
{
    CCGLProgram *pShaders = new CCGLProgram;
    pShaders->initWithVertexShaderByteArray(ccPositionTextureColor_vert, SPRITERGBA_SHADER_MUL_COLOR_FSH);
    CHECK_GL_ERROR_DEBUG();

    pShaders->addAttribute(kCCAttributeNamePosition, kCCVertexAttrib_Position);
    pShaders->addAttribute(kCCAttributeNameColor, kCCVertexAttrib_Color);
    pShaders->addAttribute(kCCAttributeNameTexCoord, kCCVertexAttrib_TexCoords);
    CHECK_GL_ERROR_DEBUG();

    pShaders->link();
    CHECK_GL_ERROR_DEBUG();

    pShaders->updateUniforms();
    CHECK_GL_ERROR_DEBUG();

    GLint nDotColorLocation = pShaders->getUniformLocationForName("v_dotcolor");
    pShaders->setUniformLocationWith4f(nDotColorLocation, r, g, b, a);

    scale9Image->setShaderProgram(pShaders);
    CHECK_GL_ERROR_DEBUG();

    pShaders->release();
}

void CSpriteRGBA::shaderMulColor(int r, int g, int b, int a)
{
    shaderMulColor((float)r / 255.0f, (float)g / 255.0f , (float)b / 255.0f, (float)a / 255.0f);
}

void CSpriteRGBA::shaderMulColor(const ccColor4F &_color)
{
    shaderMulColor(_color.r, _color.g, _color.b, _color.a);
}

void CSpriteRGBA::shaderMulColor(const ccColor4B &_color)
{
    shaderMulColor(_color.r, _color.g, _color.b, _color.a);
}

void CSpriteRGBA::shaderResetNull()
{
    scale9Image->setShaderProgram(CCShaderCache::sharedShaderCache()->programForKey(kCCShader_PositionTextureColor));
    //scale9Image->setShaderProgram(NULL);
}