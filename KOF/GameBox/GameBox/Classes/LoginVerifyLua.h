//
//  LoginVerifyLua.h
//  GameBox
//
//  Created by Caspar on 13-10-15.
//
//

#ifndef GameBox_LoginVerifyLua_h
#define GameBox_LoginVerifyLua_h


const char *LUA_KEY();

const char *LUA_CID();

int LUA_AGENT();

void LUA_EXECUTE_COMMAND(int nCommand);

const char *LUA_GET_VERSION();

int LUA_NETWORK();     //网络选择  1:内网   2:外网


#endif
