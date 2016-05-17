//
//  SpriteRGBA.h
//  GameBox
//
//  Created by wrc on 13-7-20.
//
//

#ifndef __GameBox__SpriteRGBA__
#define __GameBox__SpriteRGBA__

#include "UserControl.h"
#include "cocos-ext.h"

using namespace cocos2d;
using namespace cocos2d::extension;

namespace ptola
{
namespace gui
{

    class CSpriteRGBA : public CCScale9Sprite
    {
    public:
        ~CSpriteRGBA();

        static CSpriteRGBA *create();
        static CSpriteRGBA *create(const char *file);
        static CSpriteRGBA *create(CCRect capInsets, const char *file);
        static CSpriteRGBA *create(const char *file, cocos2d::CCRect rect);
        static CSpriteRGBA *create(const char *file, cocos2d::CCRect rect, cocos2d::CCRect capInsets);
        
        static CSpriteRGBA *createWithSpriteFrameName(const char *frame);
        static CSpriteRGBA *createWithSpriteFrameName(const char *frame, cocos2d::CCRect rect);
    public:
        void shaderDotColor(float r, float g, float b, float a);
        void shaderDotColor(int r, int g, int b, int a);
        void shaderDotColor(const ccColor4F &_color);
        void shaderDotColor(const ccColor4B &_color);


        void shaderMulColor(float r, float g, float b, float a);
        void shaderMulColor(int r, int g, int b, int a);
        void shaderMulColor(const ccColor4F &_color);
        void shaderMulColor(const ccColor4B &_color);

        void shaderResetNull();
    };

}
}

#endif /* defined(__GameBox__SpriteRGBA__) */
