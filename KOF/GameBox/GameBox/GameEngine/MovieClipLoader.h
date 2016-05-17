//
//  MovieClipLoader.h
//  GameBox
//
//  Created by Caspar on 2013-5-9.
//
//

#ifndef GameBox_MovieLoader_h
#define GameBox_MovieLoader_h

#include "cocos2d.h"
#include "cocos-ext.h"
USING_NS_CC;
USING_NS_CC_EXT;

namespace ptola
{
namespace gui
{

    class CLoaderProperty : public CCNodeLoader
    {
    public:
        void setClassName(const char *lpcszClassName)
        {
            m_ClassName = lpcszClassName;
        };
        const char *getClassName()
        {
            return m_ClassName.c_str();
        };
    private:
        std::string m_ClassName;
    };

    template<typename _Ty>
    class CMovieClipLoader : public CLoaderProperty
    {
    public:
        CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(CMovieClipLoader, loader);

        static CMovieClipLoader *loader(const char *lpcszClassName)
        {
            CMovieClipLoader *pRet = CMovieClipLoader::loader();
            if( pRet == NULL )
                return NULL;
            pRet->setClassName(lpcszClassName);
            return pRet;
        };
    protected:
        CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(_Ty);
    };
}
}

#endif
