//
//  FileStream.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#include "FileStream.h"
#include "Application.h"
#include "MemoryAllocator.h"
#include "cocos2d.h"
#include <unistd.h>
#include <stdio.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>


USING_NS_CC;
using namespace ptola;
using namespace ptola::io;
using namespace ptola::memory;

MEMORY_MANAGE_OBJECT_IMPL(CFileStream);

bool CFileStream::exists(const char *lpcszFileName)
{
    return access(lpcszFileName, R_OK) == 0;
}

bool CFileStream::existsFromResourcePath(const char *lpcszFileName)
{
    CCFileUtils *pFileUtils = CCFileUtils::sharedFileUtils();
    std::vector<std::string> searchPath = pFileUtils->getSearchPaths();
    std::vector<std::string> orderPath = pFileUtils->getSearchResolutionsOrder();
    
    char szPath[1024] = {0};
    for( std::vector<std::string>::iterator it = searchPath.begin();
        it != searchPath.end(); it++ )
    {
        const char *lpcszSearchPath = (*it).c_str();
        if( lpcszSearchPath[0] == '/' )
        {
            strcpy( szPath, lpcszSearchPath);
        }
        else
        {
            strcpy( szPath, CApplication::sharedApplication()->getResourcePath() );
            strcat( szPath, lpcszSearchPath );
        }

        for( std::vector<std::string>::iterator orderit = orderPath.begin();
            orderit != orderPath.end(); orderit++)
        {
            strcat( szPath, (*orderit).c_str() );
            
            strcat( szPath, lpcszFileName );

            CCLOG("check=%s", szPath);
            if( exists(szPath) )
                return true;
        }
    }
    std::string oldFullPath = pFileUtils->fullPathForFilename(lpcszFileName);
    return exists(oldFullPath.c_str());
//    if( strcmp(oldFullPath.c_str(), lpcszFileName) == 0)
//        return false;
//    return false;
}

bool CFileStream::existsDirectory(const char *lpcszDirectoryName)
{
    struct stat stat_d;
    int nResult = stat(lpcszDirectoryName, &stat_d);
    if (nResult == 0)
    {
        return S_ISDIR( stat_d.st_mode );
    }
    else
    {
        return false;
    }
}

bool CFileStream::existsDirectoryFromResourcePath(const char *lpcszDirectoryName)
{
    CCFileUtils *pFileUtils = CCFileUtils::sharedFileUtils();
    std::vector<std::string> searchPath = pFileUtils->getSearchPaths();
    std::vector<std::string> orderPath = pFileUtils->getSearchResolutionsOrder();
    
    char szPath[1024] = {0};
    for( std::vector<std::string>::iterator it = searchPath.begin();
        it != searchPath.end(); it++ )
    {
        strcpy( szPath, CApplication::sharedApplication()->getResourcePath() );
        strcat( szPath, (*it).c_str() );
        for( std::vector<std::string>::iterator orderit = orderPath.begin();
            orderit != orderPath.end(); orderit++)
        {
            strcat( szPath, (*orderit).c_str() );
            
            if( existsDirectory(szPath) )
                return true;
        }
    }
    return false;
}

bool CFileStream::createDirectoryRecursive(const char *lpcszDirectoryName)
{
    char *lpFirstSlash = strstr(lpcszDirectoryName + 1, "/");
    std::string strPath;
    strPath.assign(lpcszDirectoryName, (size_t)(lpFirstSlash - lpcszDirectoryName));
    while( lpFirstSlash != NULL )
    {
        lpFirstSlash = strstr( lpFirstSlash + 1, "/");
        if( lpFirstSlash != NULL )
        {
            strPath.assign(lpcszDirectoryName, (size_t)(lpFirstSlash - lpcszDirectoryName));
            if( !createDirectory(strPath.c_str()) )
                return false;
        }
    }
    return true;
}

bool CFileStream::createDirectory(const char *lcpszDirectoryName)
{
    mode_t processMask = umask(0);
    int ret = mkdir(lcpszDirectoryName, S_IRWXU | S_IRWXG | S_IRWXO);
    umask(processMask);
    return !(ret != 0 && (errno != EEXIST));
}

bool CFileStream::removeDirectory(const char *lpcszDirectoryName)
{
    return rmdir(lpcszDirectoryName) == 0;
}

bool CFileStream::deleteFile(const char *lpcszFileName)
{
    return remove(lpcszFileName) == 0;
}

CFileStream::CFileStream(const char *lpcszFileName, const char *lpcszFileMode)
: m_pFile(fopen(lpcszFileName, lpcszFileMode))
{
    
}

CFileStream::~CFileStream()
{
    close();
}

void CFileStream::flush()
{
    if( m_pFile == NULL )
    {
        assert("FILE is closed!");
    }
    fflush(m_pFile);
}

void CFileStream::close()
{
    if( m_pFile != NULL )
    {
        fclose(m_pFile);
        m_pFile = NULL;
    }
}

size_t CFileStream::getLength()
{
    if( m_pFile == NULL )
    {
        assert("FILE is closed!");
    }
    long uCurrentPos = ftell(m_pFile);
    fseek(m_pFile, 0, SEEK_END);
    long ret = ftell(m_pFile);
    fseek(m_pFile, uCurrentPos, SEEK_SET);
    return (size_t)ret;
}

size_t CFileStream::seek(int offset, enumSeekOrigin origin)
{
    if( m_pFile == NULL )
    {
        assert("FILE is closed!");
    }
    fseek(m_pFile, offset, (int)origin);
    return (size_t)ftell(m_pFile);
}

size_t CFileStream::getPosition()
{
    if( m_pFile == NULL )
    {
        assert("FILE is closed!");
    }
    return (size_t)ftell(m_pFile);
}

size_t CFileStream::read(void *lpDst, size_t uOffset, size_t uLength)
{
    if( m_pFile == NULL )
    {
        assert("FILE is closed!");
    }
    if(fread((void *)((char *)lpDst + uOffset), uLength, 1U, m_pFile) == 1)
    {
        return uLength;
    }
    else
    {
        return 0U;
    }
}

size_t CFileStream::write(const void *lpSrc, size_t uOffset, size_t uLength)
{
    if( m_pFile == NULL )
    {
        assert("FILE is closed!");
    }
    if(fwrite((void *)((char *)lpSrc + uOffset), uLength, 1U, m_pFile) == 1)
    {
        return uLength;
    }
    else
    {
        return 0U;
    }
}

void *CFileStream::getData()
{
    return m_pFile;
}

