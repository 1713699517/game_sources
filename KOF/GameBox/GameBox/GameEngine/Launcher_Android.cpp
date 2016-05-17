//
//  Launcher_Android.cpp
//  GameBox
//
//  Created by Capsar on 2013-5-22.
//
//

#include "Launcher.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

#include "FileStream.h"
#include "Application.h"
#include "unzip.h"
extern "C"
{
#include "lualib.h"
#include "lauxlib.h"
}
using namespace ptola::io;
using namespace ptola::update;

#define MAX_FILEBUFFER  1024  //每次写1K
#define MAX_FILENAME    512

static CLauncher *theLauncher = NULL;

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

bool CLauncher::hasVersionFile()
{
    if( CFileStream::existsFromResourcePath("version.lua") )
    {
        CCLOG("found on version");
        char szFileContent1[4096];
        char *pszFileContent = szFileContent1;
        int nPos = 0;
        memset( szFileContent1, 0, sizeof(char) * 4096);
        const char *lpcszStartupPath = CApplication::sharedApplication()->getStartupPath();
        CCLOG("apk=%s", lpcszStartupPath);
        unzFile apkFile = unzOpen(lpcszStartupPath);
        if( apkFile == NULL )
        {
            CCLOG("apk not found");
            return false;
        }
        CCLOG("locate file");
        if( UNZ_OK == unzLocateFile(apkFile, "assets/version.lua", 2) )
        {
            if(unzOpenCurrentFile(apkFile))
            {
                CCLOG("can not open file version.lua");
                unzCloseCurrentFile(apkFile);
                unzClose(apkFile);
                return false;
            }
            int error = UNZ_OK;
            char szBuffer[256];
            do
            {
                error = unzReadCurrentFile(apkFile, szBuffer, sizeof(char) * 256);
                if( error < 0 )
                {
                    CCLOG("can not read apk file version.lua, error code is %d", error);
                    unzCloseCurrentFile(apkFile);
                    unzClose(apkFile);
                    return NULL;
                }
                if( error > 0 )
                {
                    memcpy(pszFileContent + nPos, szBuffer, error);
                    nPos += error;
                }
            }
            while(error > 0);
            unzCloseCurrentFile(apkFile);
            unzClose(apkFile);
            //
        }
        else
        {
            CCLOG("locate false");
            return false;
        }

        //resource path
        char szResourcePath[1024] = {0};
        sprintf( szResourcePath, "%s/version.lua", CApplication::sharedApplication()->getResourcePath() );
        FILE *pFile = fopen(szResourcePath, "r");
        if( pFile == NULL )
        {
            CCLOG("couldn't open file %s", szResourcePath);
            return false;
        }
        char szFileContent2[4096];
        memset( szFileContent2, 0, sizeof(char) * 4096);
        fseek(pFile, 0, 2);
        size_t fileLength = ftell(pFile);
        fseek(pFile, 0, 0);
        fread(szFileContent2, fileLength, 1U, pFile);
        fclose(pFile);


        
        lua_State *L1 = lua_open();
        lua_State *L2 = lua_open();
        luaopen_base(L1);
        luaL_openlibs(L1);
        luaopen_base(L2);
        luaL_openlibs(L2);

        luaL_dostring(L1, szFileContent1);
        luaL_dostring(L2, szFileContent2);

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
    return CFileStream::existsFromResourcePath("update.xml");
}

bool CLauncher::copyAssetToResource()
{
    //
    LaunchThread();
    //
    return true;
}

void CLauncher::purgeLauncher()
{
    if(theLauncher != NULL)
    {
        delete theLauncher;
    }
}

void *CLauncher::Execute()
{
    //asset目录
//    const char *lpcszAssetPath
    const char *lpcszStartupPath = CApplication::sharedApplication()->getStartupPath();
    const char *lpcszResourcePath = CApplication::sharedApplication()->getResourcePath();
    //unzip
    unzFile apkFile = unzOpen(lpcszStartupPath);
    if( apkFile == NULL )
    {   //apk not found
        CCLOG("apk not found");
        return NULL;
    }

    unz_global_info globalInfo;
    if( unzGetGlobalInfo(apkFile, &globalInfo) != UNZ_OK )
    {
        CCLOG("apk get global info error!");
        unzClose(apkFile);
        return NULL;
    }

    CCLOG("start uncompress the apk file");

    if( hasEventListener("InitAsset") )
    {
        CCInteger entry(globalInfo.number_entry);   //the entrys need to copy
        CEvent evt("InitAsset", this, &entry);
        dispatchEvent(this, &evt);
    }
    //char szBuffer[MAX_FILEBUFFER];
    //char *lpBuffer = NULL;
    for( uLong i = 0 ; i < globalInfo.number_entry ; i++ )
    {
        unz_file_info fileInfo;
        char fileName[MAX_FILENAME];
        if( unzGetCurrentFileInfo(apkFile, &fileInfo, fileName, MAX_FILENAME, NULL, 0, NULL, 0) != UNZ_OK)
        {
            CCLOG("can not read file info");
            unzClose(apkFile);
            return NULL;
        }


        char szBuffer[MAX_FILEBUFFER];
        const size_t fileNameLength = strlen(fileName);
        if( fileName[fileNameLength - 1] != '/' )
        {
            //uncompress file
            char *tmpSlash = strstr(fileName, "/");
            char *lastSlash = tmpSlash;
            while( tmpSlash != NULL )
            {
                tmpSlash = strstr( tmpSlash + 1 , "/" );
                if( tmpSlash != NULL )
                    lastSlash = tmpSlash;
            }
            if( strncasecmp("assets/", fileName, 7) == 0 )
            {   //update asset
                char szDirectory[MAX_FILENAME];
                strcpy(szDirectory, lpcszResourcePath);
                int nLen = strlen(szDirectory);
                szDirectory[ nLen - 7 ] = '\0';
                if( lastSlash != NULL )
                    strncat(szDirectory, fileName, (size_t)(lastSlash - fileName) + 1 );    //+1 = include the last "/"

                if( !CFileStream::existsDirectory(szDirectory))
                {
                    if(!CFileStream::createDirectoryRecursive(szDirectory))
                    {
                        CCLOG("create directory error [%s]", szDirectory);
                        goto __lab_uncompress_continue;
                    }
                }

                if( unzOpenCurrentFile(apkFile) != UNZ_OK )
                {
                    CCLOG("can not open file %s", fileName);
                    unzCloseCurrentFile(apkFile);
                    unzClose(apkFile);
                    return NULL;
                }

                char szFile[MAX_FILENAME];
                strcpy(szFile, lpcszResourcePath);
                szFile[ nLen - 7 ] = '\0';
                strcat(szFile, fileName);

                FILE *out = fopen(szFile, "wb");
                if( out == NULL )
                {
                    CCLOG("can not open destination file %s", szFile);
                    unzCloseCurrentFile(apkFile);
                    unzClose(apkFile);
                    return NULL;
                }

                int error = UNZ_OK;
                do
                {
                    error = unzReadCurrentFile(apkFile, szBuffer, MAX_FILEBUFFER);
                    
                    if( error < 0 )
                    {
                        CCLOG("can not read apk file %s, error code is %d", fileName, error);
                        unzCloseCurrentFile(apkFile);
                        unzClose(apkFile);
                        return NULL;
                    }
                    if( error > 0 )
                    {
                        fwrite(szBuffer, error, 1, out);
                    }
                }
                while (error > 0);


                fclose(out);
            }//asset's files
        }//must be the file

        if( hasEventListener("ProgressAsset"))
        {
            CCFloat entry( (float)i / (float)globalInfo.number_entry );
            CEvent evt("ProgressAsset", this, &entry);
            dispatchEvent(this, &evt);
        }
    __lab_uncompress_continue:
        if( (i + 1) < globalInfo.number_entry )
        {
            if( unzGoToNextFile(apkFile) != UNZ_OK )
            {
                CCLOG("can not read next file");
                unzClose(apkFile);
                return NULL;
            }
        }
    }
    
    CCLOG("end uncompressing apk file %s", lpcszStartupPath);
    unzClose(apkFile);
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