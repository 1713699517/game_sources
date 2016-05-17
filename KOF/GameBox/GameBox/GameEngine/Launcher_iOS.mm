//
//  Launcher_iOS.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-22.
//
//

#include "Launcher.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

#include "FileStream.h"
#include "Application.h"
extern "C"
{
#include "lualib.h"
#include "lauxlib.h"
}

#import <Foundation/Foundation.h>
//#import <UIKit/UIDevice.h>

using namespace ptola::io;
using namespace ptola::update;

#define MAX_FILEBUFFER 1024

static CLauncher *theLauncher = NULL;

bool CLauncher::hasVersionFile()
{
    char szCachePath[1024]={0};
    //version.lua
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"version.lua" ] ofType:nil];

    NSArray *caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    const char *lpcszCache = [[caches objectAtIndex:0] UTF8String];

    sprintf(szCachePath, "%s/version.lua", lpcszCache);
    if( CFileStream::exists(szCachePath))
    {   //has cache, getversion
        lua_State *L1 = lua_open();
        lua_State *L2 = lua_open();
        luaopen_base(L1);
        luaL_openlibs(L1);
        luaopen_base(L2);
        luaL_openlibs(L2);

        luaL_dofile(L1, [fullPath UTF8String]);
        luaL_dofile(L2, szCachePath);

        lua_pcall(L1, 0, LUA_MULTRET, 0);
        lua_pcall(L2, 0, LUA_MULTRET, 0);
        //--version

        lua_getglobal(L1, "g_getLuaVersion");
        lua_getglobal(L2, "g_getLuaVersion");
        lua_call(L1, 0, 1);
        lua_call(L2, 0, 1);
        const char *lpcszVersion1 = lua_tostring(L1, -1);
        const char *lpcszVersion2 = lua_tostring(L2, -1);
        lua_pop(L1, 1);
        lua_pop(L2, 1);

        //
        lua_close(L1);
        lua_close(L2);
        if( lpcszVersion1 != NULL && strlen(lpcszVersion1) > 0
           && lpcszVersion2 != NULL && strlen(lpcszVersion2) > 0 )
        {
            int nVersion1 = atoi(lpcszVersion1);
            int nVersion2 = atoi(lpcszVersion2);
            if( nVersion1 > nVersion2 )
                return false;
        }
    }

    char updateXMLPath[1024];
    strcpy( updateXMLPath , lpcszCache );
    strcat( updateXMLPath , "/update.xml" );
    CCLOG("%s", updateXMLPath);
    return CFileStream::exists(updateXMLPath);;
}

bool CLauncher::copyAssetToResource()
{
    //ios is directory , no need to copy anything to anywhere.
    LaunchThread();
    return true;
}

CLauncher::CLauncher()
{
    
}

CLauncher::~CLauncher()
{
    theLauncher = NULL;
}


CLauncher *CLauncher::sharedLauncher()
{
    if( theLauncher == NULL )
    {
        theLauncher = new CLauncher;
    }
    return theLauncher;
}

void CLauncher::purgeLauncher()
{
    if(theLauncher != NULL)
    {
        delete theLauncher;
    }
}

int __getCopyEntryCount(const char *lpcszPath)
{
    int ret = 0;
    NSString *path = [[NSString alloc] initWithUTF8String:lpcszPath];
    NSArray *fileArrs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *filePath in fileArrs)
    {
        NSString *absFile = [path stringByAppendingPathComponent:filePath];
        if( CFileStream::existsDirectory([absFile UTF8String]) )
        {
            ret += __getCopyEntryCount([absFile UTF8String]);
        }
        else
        {
            const char *lpszFilePathStartPos = [absFile UTF8String];
            char *lpPointPos = strstr( [absFile UTF8String], "." );
            char *lpExtPointPos = (char *)lpszFilePathStartPos;
            while( lpPointPos != NULL )
            {
                lpPointPos = strstr( (char *)(lpPointPos + 1) , "." );
                if( lpPointPos != NULL )
                    lpExtPointPos = lpPointPos;
            }
            std::string ext = lpExtPointPos;
            if( !( strcasecmp(ext.c_str(), "") == 0 || strcasecmp(ext.c_str(), ".so") == 0 ) )
            {
                ret ++;
            }
        }
        [absFile release];
    }

    [path release];
    return ret;
}



void __reCopyEntry(CLauncher *thiz, const char *lpcszPath, const char *lpcszDst, int *pCurrent, int _max)
{
    NSString *path = [[NSString alloc] initWithUTF8String:lpcszPath];
    NSString *dst = [[NSString alloc] initWithUTF8String:lpcszDst];
    NSArray *fileArrs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *filePath in fileArrs)
    {
        NSString *absFile = [path stringByAppendingPathComponent:filePath];
        NSString *dstFile = [dst stringByAppendingPathComponent:filePath];
        if( CFileStream::existsDirectory([absFile UTF8String]) )
        {
            char szDir[1024];
            strcpy( szDir, [dstFile UTF8String]);
            strcat( szDir, "/" );
            if( !CFileStream::existsDirectory(szDir) )
            {
                CFileStream::createDirectoryRecursive(szDir);
            }
            __reCopyEntry(thiz, [absFile UTF8String], [dstFile UTF8String], pCurrent, _max);
        }
        else
        {
            //ext
            const char *lpszFilePathStartPos = [absFile UTF8String];
            char *lpPointPos = strstr( [absFile UTF8String], "." );
            char *lpExtPointPos = (char *)lpszFilePathStartPos;
            while( lpPointPos != NULL )
            {
                lpPointPos = strstr( (char *)(lpPointPos + 1) , "." );
                if( lpPointPos != NULL )
                    lpExtPointPos = lpPointPos;
            }
            std::string ext = lpExtPointPos;
            if( !( strcasecmp(ext.c_str(), "") == 0 || strcasecmp(ext.c_str(), ".so") == 0 ) )
            {
                const char *lpcszDstFile = [dstFile UTF8String];
                
                if( !CFileStream::exists(lpcszDstFile))
                {
                    FILE *_out = fopen(lpcszDstFile, "wb");
                    if( _out == NULL )
                    {
                        CCLOG("can not open destination file %s", lpcszDstFile);
                        return;
                    }
                    FILE *_in = fopen(lpszFilePathStartPos, "rb");
                    if( _in == NULL )
                    {
                        CCLOG("can not open source file %s", lpszFilePathStartPos);
                        return;
                    }
                    char szBuffer[MAX_FILEBUFFER];
                    size_t len = 0U;
                    do
                    {
                        len = fread(szBuffer, 1, MAX_FILEBUFFER, _in);
                        if( len <= 0U )
                            break;
                        fwrite(szBuffer, 1, len, _out);
                    } while (len > 0U);
                    fflush(_out);
                    fclose(_in);
                    fclose(_out);
                    *pCurrent = ((*pCurrent) + 1);
                }

                if( thiz->hasEventListener("ProgressAsset"))
                {
                    CCFloat entry( (((float)(*pCurrent)) / (float)_max) );
                    CEvent evt("ProgressAsset", thiz, &entry);
                    thiz->dispatchEvent(thiz, &evt);
                }
            }
        }
        
        //CCLOG("-->%s", [absFile UTF8String]);
        [dstFile release];
        [absFile release];
    }
    [dst release];
    [path release];
    [fileArrs release];
}

void __CopyFile(const char *lpcszResourcePath, const char *lpcszCachePath, const char *lpcszFilePath)
{
    char szSourceFile[1024] = {0};
    char szDestFile[1024] = {0};
    sprintf(szSourceFile, "%s%s", lpcszResourcePath, lpcszFilePath);
    sprintf(szDestFile, "%s/%s", lpcszCachePath, lpcszFilePath);


    FILE *_out = fopen(szDestFile, "wb");
    if( _out == NULL )
    {
        CCLOG("can not open destination file %s", szDestFile);
        return;
    }
    FILE *_in = fopen(szSourceFile, "rb");
    if( _in == NULL )
    {
        CCLOG("can not open source file %s", szSourceFile);
        return;
    }
    char szBuffer[MAX_FILEBUFFER];
    size_t len = 0U;
    do
    {
        len = fread(szBuffer, 1, MAX_FILEBUFFER, _in);
        if( len <= 0U )
            break;
        fwrite(szBuffer, 1, len, _out);
    } while (len > 0U);
    fflush(_out);
    fclose(_in);
    fclose(_out);
}

void *CLauncher::Execute()
{
    //resource目录
//    NSString *resources = [[NSBundle mainBundle] pathForResource:@"" ofType:nil];
//    NSString *resource = [resources stringByDeletingLastPathComponent];
    NSString *resource = [[NSBundle mainBundle] resourcePath];
    char szResources[1024];
    strcpy(szResources, [resource UTF8String]);
    strcat(szResources, "/");


    //copy至cache目录
    NSArray *caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    const char *lpcszCache = [[caches objectAtIndex:0] UTF8String];
    int nEntryCount = __getCopyEntryCount(szResources);
    if( hasEventListener("InitAsset") )
    {
        CCInteger entry( nEntryCount );   //the entrys need to copy
        CEvent evt("InitAsset", this, &entry);
        dispatchEvent(this, &evt);
    }
    //int nCurrent = 0;
    //解压version.lua和update.xml
    __CopyFile(szResources, lpcszCache, "version.lua");
    __CopyFile(szResources, lpcszCache, "update.xml");
    //__reCopyEntry(this, szResources, lpcszCache , &nCurrent, nEntryCount);
//    [resources release];
//    [resource release];
    return NULL;
}

void CLauncher::CleanUp()
{
    if( hasEventListener("CompleteAsset"))
    {
        CEvent evt("CompleteAsset", this, NULL);
        dispatchEvent(this, &evt);
    }
}

//eventListener
void CLauncher::addEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector)
{
    m_eventDispatcher.addEventListener(lpcszEventName, pTarget, selector);
}

void CLauncher::removeEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector)
{
    m_eventDispatcher.removeEventListener(lpcszEventName, pTarget, selector);
}

void CLauncher::removeEventListeners(const char *lpcszEventName)
{
    m_eventDispatcher.removeEventListeners(lpcszEventName);
}

void CLauncher::removeAllEventListener()
{
    m_eventDispatcher.removeAllEventListener();
}

void CLauncher::dispatchEvent(CCObject *pSender, CEvent *pEvent)
{
    m_eventDispatcher.dispatchEvent(pSender, pEvent);
}

bool CLauncher::hasEventListener(const char *lpcszEventName)
{
    return m_eventDispatcher.hasEventListener(lpcszEventName);
}


#endif