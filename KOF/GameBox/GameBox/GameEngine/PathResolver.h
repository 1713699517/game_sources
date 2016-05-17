//
//  PathResolver.h
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#ifndef __GameBox__PathResolver__
#define __GameBox__PathResolver__

#include "cocos2d.h"

USING_NS_CC;
using namespace std;

namespace ptola
{
namespace io
{

    enum enumFileProtocol
    {
         eFP_FILE
        ,eFP_HTTP
    };

    class CPathResolveResult
    {
    public:
        enumFileProtocol eFileProtocol;
        std::string strAssetPath;
        std::string strResourcePath;
        std::string strExtension;
        std::string strFileName;
        bool bCompressed;
    };

    class CPathResolver
    {
    public:
        static CPathResolveResult *resolve( const char *lpcszFilePath );
        static const char *getAssetRelativePath( const char *lpcszFilePath );
    private:
        static const char *getAssetPathEndPos( const char *lpcszFilePath );
    };

}
}

#endif /* defined(__GameBox__PathResolver__) */
