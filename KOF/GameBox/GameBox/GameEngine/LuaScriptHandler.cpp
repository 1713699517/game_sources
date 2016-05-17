//
//  LuaScriptHandler.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-28.
//
//

#include "LuaScriptHandler.h"

using namespace ptola::script;

CNetworkMessageScriptHandler::CNetworkMessageScriptHandler(int nHandler)
: CCScriptHandlerEntry(nHandler)
{
}

CNetworkMessageScriptHandler *CNetworkMessageScriptHandler::create(int nHandler)
{
    CNetworkMessageScriptHandler *pRet = new CNetworkMessageScriptHandler(nHandler);
    if( pRet != NULL )
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        return NULL;
    }
}

CControlScriptHandler::CControlScriptHandler(int nHandler)
: CCScriptHandlerEntry(nHandler)
{

}

CControlScriptHandler *CControlScriptHandler::create(int nHandler)
{
    CControlScriptHandler *pRet = new CControlScriptHandler(nHandler);
    if( pRet != NULL )
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        return NULL;
    }
}