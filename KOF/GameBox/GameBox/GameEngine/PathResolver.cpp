//
//  PathResolver.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#include "PathResolver.h"

USING_NS_CC;
using namespace std;
using namespace ptola::io;

CPathResolveResult *CPathResolver::resolve(const char *lpcszFilePath)
{
    static CPathResolveResult m_Result;
    char *lpszFilePathStartPos = NULL;
    if( strncasecmp(lpcszFilePath, "http://", 7) == 0 )
    {
        m_Result.eFileProtocol = eFP_HTTP;
        lpszFilePathStartPos = (char *)(lpcszFilePath + 7);
    }
    else
    {
        m_Result.eFileProtocol = eFP_FILE;
        if( strncasecmp(lpcszFilePath, "file://", 7) == 0 )
        {
            lpszFilePathStartPos = (char *)(lpcszFilePath + 7);
        }
        else
        {
            lpszFilePathStartPos = (char *)lpcszFilePath;
        }
    }

    //ext
    char *lpPointPos = strstr( lpszFilePathStartPos, "." );
    char *lpExtPointPos = lpszFilePathStartPos;
    while( lpPointPos != NULL )
    {
        lpPointPos = strstr( (char *)(lpPointPos + 1) , "." );
        if( lpPointPos != NULL )
            lpExtPointPos = lpPointPos;
    }
    if( lpExtPointPos != NULL )
    {
        m_Result.strExtension = lpExtPointPos;
    }


    //strfileName
    char *lpSlashPos = strstr( lpszFilePathStartPos, "/" );
    char *lpSlashTmp = lpszFilePathStartPos;
    while( lpSlashPos != NULL )
    {
        lpSlashPos = strstr( (char *)(lpSlashPos + 1) , "/" );
        if( lpSlashPos != NULL )
            lpSlashTmp = lpSlashPos;
    }
    if( lpSlashTmp != NULL )
    {
        m_Result.strFileName = lpSlashTmp;
    }
    
    //asset file
    const char *lpcszEndPos = getAssetPathEndPos(lpszFilePathStartPos);
    m_Result.bCompressed = lpcszEndPos != NULL;
    if( m_Result.bCompressed )
    {
        const char *lpcszResourcePath = strstr( lpcszEndPos, "/" );
        m_Result.strAssetPath.assign( lpszFilePathStartPos, (size_t)lpcszResourcePath - (size_t)lpszFilePathStartPos );
        m_Result.strResourcePath = lpcszResourcePath;
    }
    else
    {
        m_Result.strAssetPath.clear();
        m_Result.strResourcePath = lpszFilePathStartPos;
    }
    
    return &m_Result;
}

const char *CPathResolver::getAssetPathEndPos(const char *lpcszFilePath)
{
    char szExts[7][10] = {".jar",".apk",".z",".zip",".7z",".gz",".tar"};
    const char *lpRet = NULL;
    for( size_t i = 0 ; i < 7 ; i++ )
    {
        lpRet = strstr(lpcszFilePath, szExts[i]);
        if( lpRet != NULL )
            return lpRet;
    }
    return NULL;
}

const char *CPathResolver::getAssetRelativePath(const char *lpcszFilePath)
{
    return CCFileUtils::sharedFileUtils()->fullPathForFilename( lpcszFilePath ).c_str();
}