//
//  LoginVerifyLua.cpp
//  GameBox
//
//  Created by Caspar on 13-10-15.
//
//


#include <string.h>
#include "Constant.h"
#include "LoginVerifyLua.h"
#include "LuaScriptFunctionInvoker.h"
#include "FileStream.h"

extern "C"
{
#include "lualib.h"
#include "lauxlib.h"
}

char s_szLUAKEY[64]     = {0};
char s_szLUACID[16]     = {0};

int s_nVersionCallBack  = 0;
char s_szVersion[16]    = {0};

const char *LUA_KEY()
{
    if( strlen(s_szLUAKEY) == 0 )
    {
        strcpy(s_szLUAKEY, PRIVATEKEY_W_217);
    }
    return s_szLUAKEY;
}

const char *LUA_CID()
{
    if( strlen(s_szLUACID) == 0 )
    {
        strcpy(s_szLUACID, CID_w_217);
    }
    return s_szLUACID;
}

int LUA_AGENT()
{
    return AGENT_SDK_CODE;
}

int LUA_NETWORK()
{
    return __NETWORK_TYPE__;
}

const char *LUA_GET_VERSION()
{
    if( strlen(s_szVersion) == 0 )
    {
        lua_State *L = lua_open();
        luaopen_base(L);
        luaL_openlibs(L);

        std::string filePath = CCFileUtils::sharedFileUtils()->fullPathForFilename("version.lua");
        CCLOG("F = %s\nfound file %d", filePath.c_str(), ptola::io::CFileStream::exists(filePath.c_str()));
        if( !ptola::io::CFileStream::exists(filePath.c_str()) )
        {
            unsigned long uSize = 0UL;
            unsigned char *pBuff = CCFileUtils::sharedFileUtils()->getFileData(filePath.c_str(), "r", &uSize);

            if( uSize > 0UL && uSize < 2048UL )
            {
                char szBuffer[2048];
                memset(szBuffer, 0, sizeof(char) * 2048);
                strcpy( szBuffer, (char *)pBuff );
                for( int i = 0 ; i < 10 ; i++ )
                {
                    szBuffer[uSize + i] = '\0';
                }
                CCLOG("SIZE=%d\n%s", uSize, szBuffer);
                luaL_dostring(L, szBuffer);
            }
            if( uSize > 0UL )
            {
                delete[] pBuff;
            }
        }
        else
        {
            luaL_dofile(L, filePath.c_str());
        }
        CCLOG("do version file");
        lua_pcall(L, 0, LUA_MULTRET, 0);
        //--version

        lua_getglobal(L, "g_getLuaVersion");
        lua_call(L, 0, 1);
        const char *lpcszVersion = lua_tostring(L, -1);
        CCLOG("LUA Version = %s", lpcszVersion);
        lua_pop(L, 1);

        //
        lua_close(L);
        
        if( lpcszVersion != NULL )
        {
            strcpy(s_szVersion, lpcszVersion);
        }
    }
    return s_szVersion;
}