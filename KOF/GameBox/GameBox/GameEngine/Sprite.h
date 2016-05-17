//
//  Sprite.h
//  GameBox
//
//  Created by Caspar on 2013-5-6.
//
//

#ifndef __GameBox__Sprite__
#define __GameBox__Sprite__

#include "cocos-ext.h"
#include "UserControl.h"
#include "ptola.h"
#include "SpriteRGBA.h"

USING_NS_CC_EXT;

namespace ptola
{
namespace gui
{

    class CSprite : public CUserControl
    {
    public:

        MEMORY_MANAGE_OBJECT(CSprite);
        
        CSprite();
        ~CSprite();

        static CSprite *create(const char *lpcszResourceName);
        bool init(const char *lpcszResourceName);

        static CSprite *create(const char *lpcszResourceName, const CCRect &rect);
        bool init(const char *lpcszResourceName, const CCRect &rect);


        static CSprite *createWithSpriteFrameName(const char *lpcszResourceName);
        bool initWithSpriteFrameName(const char *lpcszResourceName);

        static CSprite *createWithSpriteFrameName(const char *lpcszResourceName, const CCRect &rect);
        bool initWithSpriteFrameName(const char *lpcszResourceName, const CCRect &rect);
        
        CCSize getPreferredSize();
        void setPreferredSize(const CCSize &size);

        void setImage(const char *lpcszResourceName, const CCRect &rect);
        void setImage(const char *lpcszResourceName);
        void setImageWithSpriteFrameName(const char *lpcszResourceName, const CCRect &rect);
        void setImageWithSpriteFrameName(const char *lpcszResourceName);

        void setOpacity(GLubyte opacity);
        GLubyte getOpacity();
    public:
        virtual bool containsPoint(CCPoint *pPoint);

        virtual void flipHorizontal();
        virtual void flipVertical();

        void setGray(bool bGray);
        bool getGray();

        void shaderDotColor(float r, float g, float b, float a);
        void shaderDotColor(int r, int g, int b, int a);
        void shaderDotColor(const ccColor4F &_color);
        void shaderDotColor(const ccColor4B &_color);


        void shaderMulColor(float r, float g, float b, float a);
        void shaderMulColor(int r, int g, int b, int a);
        void shaderMulColor(const ccColor4F &_color);
        void shaderMulColor(const ccColor4B &_color);

        void shaderResetNull();
    private:
        bool m_bGray;
        CSpriteRGBA *m_pSprite;
    };

}
}

#endif /* defined(__GameBox__Sprite__) */
