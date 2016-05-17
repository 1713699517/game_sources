//
//  ConfigurationManager.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-2.
//
//

#include "ConfigurationManager.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CCLuaEngine.h"
#include "PathResolver.h"
#include "tolua++.h"

#include "misc/xxtea.h"
#include "misc/xxtea.c"

USING_NS_CC;
using namespace ptola::io;
using namespace ptola::configuration;

static void _internal_recursive_parseNode( lua_State *L , CTiXmlElement *pElement, int arrIndex);

static int _internal_select_node_func(lua_State *L);

CConfigurationManager::CConfigurationManager()
{

}

CConfigurationManager::~CConfigurationManager()
{
    while( !m_setLoadedConfigurations.empty() )
    {
        if(!unload( m_setLoadedConfigurations.begin()->c_str() ))
            break;
    }
}

CConfigurationManager *CConfigurationManager::sharedConfigurationManager()
{
    static CConfigurationManager mgr;
    return &mgr;
}

bool CConfigurationManager::load(const char *lpcszConfigurationFile)
{
    return false;
    if( m_setLoadedConfigurations.find(lpcszConfigurationFile) != m_setLoadedConfigurations.end() )
    {
        return true;
    }
    CCScriptEngineProtocol *pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
    CCLuaEngine * pLuaEngine = dynamic_cast<CCLuaEngine *>(pEngine);
    if( pLuaEngine == NULL )
    {
        return false;
    }
    //load xml
    CTiXmlDocument xmlDoc;
    //if( !xmlDoc.LoadFile( CPathResolver::getAssetRelativePath(lpcszConfigurationFile)))
    std::string strConfigUrl = CCFileUtils::sharedFileUtils()->fullPathForFilename( lpcszConfigurationFile );
    if( !xmlDoc.LoadFile( strConfigUrl.c_str() ))
    {
        CCMessageBox(strConfigUrl.c_str(), "Not Found!");
        return false;
    }
    CCLuaValueDict xmlDict;

    CTiXmlElement *pRootObject = xmlDoc.RootElement();
    if( pRootObject == NULL )
    {
        return false;
    }


    CCLuaStack *pLuaStack = pLuaEngine->getLuaStack();
    //get global stack, Config = {}
    if( pLuaStack == NULL )
    {
        return false;
    }
    //
    lua_State *L = pLuaStack->getLuaState();
    lua_getglobal(L, "Config"); //push get _G.Config
    if( lua_isnil(L, -1) ) //if Config == nil then
    {
        lua_newtable(L);
        lua_pushstring(L, "Config");    // _G.Config = {}
        lua_newtable(L);
        lua_settable(L, -3);
        lua_setglobal(L, "Config");
    }
    lua_pop(L, 1);  //pop get _G.Config
    lua_getglobal(L, "Config");     //push get _G.Config
    if( lua_isnil(L, -1) )  //if Config == nil then
    {
        lua_pushstring(L, "Config table create error!");
        lua_error(L);
        lua_pop(L, 1);
        return false;
    }

    lua_getfield(L, -1, pRootObject->Value());
    if( !lua_isnil(L, -1) )      //if _G.Config.XmlFileName != nil then
    {
        lua_pop(L, 1);      //_G.Config
        //set _G.Config.XmlFileName = nil
        lua_pushstring(L, pRootObject->Value());
        lua_pushnil(L);
        lua_settable(L, -3);
    }
    else
    {
        lua_pop(L, 1);
    }
    //stack _G.Config
    m_mapRootElementNames[ lpcszConfigurationFile ] = pRootObject->Value();
    //xmlroot
    _internal_recursive_parseNode(L, pRootObject, 0);

    lua_pop(L , 1); //stack _G
    m_setLoadedConfigurations.insert( lpcszConfigurationFile );
    return true;
}

int _internal_select_node_func(lua_State *L)
{
    //(table self, string nodeName, string attributeName, string attributeValue)
    luaL_checktype(L, 1, LUA_TTABLE);
    luaL_checktype(L, 2, LUA_TSTRING);
    luaL_checktype(L, 3, LUA_TSTRING);
    luaL_checktype(L, 4, LUA_TSTRING);
    
    const char *lpcszNodeName = lua_tostring(L, 2);
    const char *lpcszAttributeName = lua_tostring(L, 3);
    const char *lpcszAttributeValue = lua_tostring(L, 4);
    lua_pop(L, 3);
    //index of table 1

    lua_pushnil(L);
    while( lua_next(L, -2) )
    {
        //string only
        int keyType = lua_type(L, -2);
        if( keyType != LUA_TSTRING )
        {
            return 0;
        }
        const char *lpcszKeyName = lua_tostring(L, -2);
        if( strcmp(lpcszKeyName, lpcszNodeName) == 0 )  //find the node by name
        {
            int valueType = lua_type(L, -1);
            switch( valueType )
            {
                case LUA_TSTRING:
                    lua_pushstring(L, lua_tostring(L, -1));
                return 1;
                case LUA_TNUMBER:
                    lua_pushnumber(L, lua_tonumber(L, -1));
                return 1;
                case LUA_TBOOLEAN:
                    lua_pushboolean(L, lua_toboolean(L, -1));
                return 1;
                case LUA_TLIGHTUSERDATA:
                    lua_pushlightuserdata(L, lua_touserdata(L, -1));
                return 1;
                case LUA_TTABLE:
                    //table(index array) , find the property,
                    lua_pushnil(L);
                    while( lua_next(L, -2) )
                    {                        if(lua_type(L, -2) == LUA_TNUMBER && lua_istable(L, -1) )
                        {   //index, table{ key=value, key=value, key=value }
                            lua_pushnil(L);
                            while( lua_next(L, -2) )    //---------XZ
                            {   //table{ key=value, key=value, key=value }
                                if( lua_type(L, -2) == LUA_TSTRING && lua_type(L, -1) == LUA_TSTRING )
                                {
                                    const char *lpcszAttributeKeyName = lua_tostring(L, -2);
                                    const char *lpcszAttributeValueName = lua_tostring(L, -1);
                                    
                                    if( strcmp(lpcszAttributeKeyName, lpcszAttributeName) == 0 && strcmp(lpcszAttributeValueName,lpcszAttributeValue) == 0 )
                                    {   //found!
                                        lua_pop(L, 2);
                                        return 1;
                                    }
                                }
                                lua_pop(L, 1);
                            }
                        }
                        lua_pop(L, 1);
                    }
                    lua_pushnil(L);     //found nothing
                return 1;

            }
        }
        lua_pop(L, 1);
    }

    return 1;
}

void _internal_recursive_parseNode( lua_State *L , CTiXmlElement *pElement, int arrIndex)
{
    //stack _G.Config
    if( pElement == NULL )
        return;
//    char nameWithKey[64] = {0};
//    const char *lpIdColumnValue = pElement->Attribute("id");
//    if( lpIdColumnValue != NULL )
//    {
//        sprintf( nameWithKey, "%s_%s", pElement->Value(), lpIdColumnValue );
//    }
//    else
//    {
//        strcpy(nameWithKey, pElement->Value() );
//    }

    //_G.Config.XmlFileName = {...};begin
    int t = lua_gettop(L);
    if( arrIndex > 0 )
    {
        lua_pushinteger(L, arrIndex);
    }
    else
    {
        lua_pushstring(L, pElement->Value());   // ============================ <elemt id="1001">  elemt_1001
    }
    lua_newtable(L);
    //attribute
    for( CTiXmlAttribute *pAttribute = pElement->FirstAttribute()
        ; pAttribute != NULL ; pAttribute = pAttribute->Next() )
    {
        lua_pushstring(L, pAttribute->Name());
        lua_pushstring(L, pAttribute->Value());
        lua_settable(L, -3);
    }
    //add function
    lua_pushstring(L, "selectNode");
    lua_pushcclosure(L, _internal_select_node_func, 0);
    lua_settable(L, -3);
    //lua_pushcclosure(lua_State *L, lua_CFunction fn, int n)
    //child
    if( !pElement->NoChildren() )
    {
        std::map<std::string, int> mapIndices;
        for( CTiXmlElement *pChildElement = pElement->FirstChildElement()
            ; pChildElement != NULL ; pChildElement = pChildElement->NextSiblingElement())
        {
            std::map<std::string, int>::iterator it = mapIndices.find(pChildElement->Value());
            int arrIndex = 1;
            if( it != mapIndices.end() )
            {
                arrIndex = it->second + 1;
            }
            mapIndices[ pChildElement->Value() ] = arrIndex;

            t = lua_gettop(L);


            if( arrIndex == 1 )
            {//first time
                lua_pushstring(L, pChildElement->Value());
                lua_newtable(L);
            }
            else
            {//second time+
                lua_pushstring(L, pChildElement->Value());
                lua_gettable(L, -2);
            }
            t = lua_gettop(L);
            _internal_recursive_parseNode(L, pChildElement, arrIndex);
            t = lua_gettop(L);
            if( arrIndex == 1 )
            {
                lua_settable(L, -3);
            }
            else
            {
                lua_pop(L, 1);
            }
            t = lua_gettop(L);

        }
    }
    //_G.Config.XmlFileName = {...};end
    lua_settable(L, -3);                    // ============================
}

bool CConfigurationManager::unload(const char *lpcszConfigurationFile)
{
    if( m_setLoadedConfigurations.find(lpcszConfigurationFile) == m_setLoadedConfigurations.end() )
    {
        return true;
    }
    CCScriptEngineProtocol *pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
    CCLuaEngine * pLuaEngine = dynamic_cast<CCLuaEngine *>(pEngine);
    if( pLuaEngine == NULL )
    {
        return false;
    }
    //load xml
    CTiXmlDocument xmlDoc;
    //if( !xmlDoc.LoadFile( CPathResolver::getAssetRelativePath(lpcszConfigurationFile)))
    std::map<std::string, std::string>::iterator it = m_mapRootElementNames.find( lpcszConfigurationFile );
    char szRootName[128];
    if( it != m_mapRootElementNames.end() )
    {
        strcpy(szRootName, it->second.c_str());
    }
    else
    {
        std::string strConfigUrl = CCFileUtils::sharedFileUtils()->fullPathForFilename( lpcszConfigurationFile );
        if( !xmlDoc.LoadFile( strConfigUrl.c_str() ))
        {
            return false;
        }
        CCLuaValueDict xmlDict;

        CTiXmlElement *pRootObject = xmlDoc.RootElement();
        if( pRootObject == NULL )
        {
            return false;
        }
        strcpy(szRootName, pRootObject->Value());
    }


    CCLuaStack *pLuaStack = pLuaEngine->getLuaStack();
    //get global stack, Config = {}
    if( pLuaStack == NULL )
    {
        return false;
    }
    //
    lua_State *L = pLuaStack->getLuaState();
    lua_getglobal(L, "Config"); //push get _G.Config
    if( lua_isnil(L, -1) ) //if Config == nil then
    {
        lua_pop(L, 1);  //pop
        return true;
    }
    lua_getfield(L, -1, szRootName);
    if( !lua_isnil(L, -1) )      //if _G.Config.XmlFileName != nil then
    {
        lua_pop(L, 1);      //_G.Config
        //set _G.Config.XmlFileName = nil
        lua_pushstring(L, szRootName);
        lua_pushnil(L);
        lua_settable(L, -3);
    }
    else
    {
        lua_pop(L, 1);
    }
    //stack _G.Config

    lua_pop(L , 1); //stack _G
    m_setLoadedConfigurations.erase(lpcszConfigurationFile);
    return true;
}



CConfigurationCache::CConfigurationCache()
{

}

CConfigurationCache::~CConfigurationCache()
{
    
}

CConfigurationCache *CConfigurationCache::sharedConfigurationCache()
{
    static CConfigurationCache theCache;
    return &theCache;
}

bool CConfigurationCache::load(const char *lpcszConfigurationFile)
{
    if( m_setLoadedConfigurations.find(lpcszConfigurationFile) != m_setLoadedConfigurations.end() )
    {
        return true;
    }
    unsigned long uSize = 0UL;
    unsigned char *lpXMLBuffer = CCFileUtils::sharedFileUtils()->getFileData(CPathResolver::getAssetRelativePath(lpcszConfigurationFile), "r", &uSize);
    if( uSize == 0 )
    {
        return false;
    }
    lpXMLBuffer = (unsigned char *)realloc(lpXMLBuffer, uSize + 1);
    lpXMLBuffer[ uSize ] = '\0';

    if(lpXMLBuffer[0] == 'x')
    {
        char szBuffer[32];
        strcpy(szBuffer, "xia1ping85524547");
        xxtea_long len = 0;
        unsigned char *pResult = php_xxtea_decrypt(lpXMLBuffer + 1 , (xxtea_long)(uSize - 1), (unsigned char *)szBuffer, &len);
        free( lpXMLBuffer );
        lpXMLBuffer = pResult;
    }


    SXMLConfig *pXML = new SXMLConfig;
    try
    {
        pXML->xmlDoc.parse<0>((char *)lpXMLBuffer);
    }
    catch(const rapidxml::parse_error &e)
    {
        CCLOG("xml faild %s",lpcszConfigurationFile);
        CCMessageBox(e.where<char>(), e.what());
        free(lpXMLBuffer);
        lpXMLBuffer = NULL;
        return false;
    }
    pXML->lpXMLBuffer = (char *)lpXMLBuffer;
    strcpy(pXML->szRootName, pXML->xmlDoc.first_node()->name());
    strcpy(pXML->szPath, lpcszConfigurationFile);
    m_setLoadedConfigurations[ lpcszConfigurationFile ] = pXML;
    m_mapRootNameConfigurations[ pXML->szRootName ] = pXML;
    return true;
}

bool CConfigurationCache::unload(const char *lpcszConfigurationFile)
{
    std::map<std::string, SXMLConfig *>::iterator it = m_setLoadedConfigurations.find(lpcszConfigurationFile);
    if(it != m_setLoadedConfigurations.end())
    {
        m_mapRootNameConfigurations.erase(it->second->szRootName);
        delete it->second;
        m_setLoadedConfigurations.erase(it);
    }
    return true;
}

const char *CConfigurationCache::getRootElementName(const char *lpcszConfigurationFile)
{
    std::map<std::string,SXMLConfig*>::iterator it = m_setLoadedConfigurations.find(lpcszConfigurationFile);
    if( it != m_setLoadedConfigurations.end() )
    {
        return it->second->szRootName;
    }
    else
    {
        return NULL;
    }
}

rapidxml::xml_node<> *CConfigurationCache::selectSingleNode(const char *lpcszRootName, const char *lpcszPath)
{
    std::map<std::string, SXMLConfig *>::iterator it = m_mapRootNameConfigurations.find(lpcszRootName);
    if( it == m_mapRootNameConfigurations.end() )
        return NULL;
    char exp[512] = {0};

    char szNodeName[64] = {0};
    char szAttributeName[512] = {0};
    char szAttributeValue[512] = {0};
    int nIndex = -1;
    char *pStr = (char *)lpcszPath;
    if( strncmp(pStr,"/",1) == 0 )
        pStr++;
    char *pStart = pStr;
    char *pNext = pStr;
    rapidxml::xml_node<> *pRet = NULL;
    do
    {
        pStart = pNext;
        pNext = strstr(pNext, "/");
        if( pNext == NULL )
        {
            strcpy(exp, pStart );
        }
        else
        {
            strncpy(exp, pStart , (size_t)(pNext - pStart));
            pNext++;
        }
        szNodeName[0] = '\0';
        szAttributeName[0] = '\0';
        szAttributeValue[0] = '\0';
        nIndex = -1;
        //exp
        CCLOG("%s", exp);
        //@
        if( strncmp(exp, "@", 1) == 0 )
            return NULL;
        //[]
        char *pLeftQ = strstr( exp, "[" );
        if( pLeftQ != NULL )
        {
            strncpy(szNodeName, exp, (size_t)(pLeftQ - exp));
            //判断是否index还是@Attribute条件
            char *pRightQ = strstr( pLeftQ, "]");
            if( pRightQ == NULL )   //error
                return NULL;
            //判断@Attribute条件
            if( strstr(pLeftQ, "@") != NULL )
            {
                pLeftQ++;
                char *pEqual = strstr(pLeftQ, "=");
                if( pEqual == NULL )
                    return NULL;
                //name
                strncpy(szAttributeName, pLeftQ+1, (size_t)(pEqual - pLeftQ) - 1);
                strncpy(szAttributeValue, pEqual+1, (size_t)(pRightQ-pEqual) - 1);
                //value
            }
            else    //index
            {
                char szIndex[16];
                strncpy(szIndex, pLeftQ, (size_t)(pRightQ - pLeftQ));
                nIndex = atoi(szIndex);
            }
        }
        else
        {
            strcpy(szNodeName, exp);
        }
        //判断是否
        if( pRet == NULL )
        {
            if( nIndex > -1 )
            {
                int i = 0;
                for( pRet = it->second->xmlDoc.first_node()->first_node(szNodeName);
                    pRet != NULL ; pRet = pRet->next_sibling(szNodeName))
                {
                    if( i == nIndex )
                        break;
                }
            }
            else if( strlen(szAttributeName) > 0 && strlen(szAttributeValue) > 0 )
            {
                for( pRet = it->second->xmlDoc.first_node()->first_node(szNodeName);
                    pRet != NULL ; pRet = pRet->next_sibling(szNodeName))
                {
                    if( strcmp(pRet->first_attribute(szAttributeName)->value(), szAttributeValue) == 0 )
                    {
                        break;
                    }
                }
            }
            else
            {
                pRet = it->second->xmlDoc.first_node()->first_node(exp);
            }
        }
        else
        {
            if( nIndex > -1 )
            {
                int i = 0;
                for( pRet = pRet->first_node(szNodeName);
                    pRet != NULL ; pRet = pRet->next_sibling(szNodeName))
                {
                    if( i == nIndex )
                        break;
                }
            }
            else if( strlen(szAttributeName) > 0 && strlen(szAttributeValue) > 0 )
            {
                for( pRet = pRet->first_node(szNodeName);
                    pRet != NULL ; pRet = pRet->next_sibling(szNodeName))
                {
                    if( strcmp(pRet->first_attribute(szAttributeName)->value(), szAttributeValue) == 0 )
                    {
                        break;
                    }
                }
            }
            else
            {
                pRet = pRet->first_node(exp);
            }
        }
    }
    while(pNext!=NULL);
    return pRet;
}

rapidxml::xml_attribute<> *CConfigurationCache::getFirstAttribute(rapidxml::xml_node<> *pNode, const char *lpcszAttributeName)
{
    return pNode->first_attribute(lpcszAttributeName);
}

rapidxml::xml_node<> *CConfigurationCache::getFirstChildNode(rapidxml::xml_node<> *pNode, const char *lpcszNodeName)
{
    return pNode->first_node(lpcszNodeName);
    
}

CXMLNode CConfigurationCache::getRootElement(const char *lpcszRootName)
{
    std::map<std::string, SXMLConfig*>::iterator it = m_mapRootNameConfigurations.find(lpcszRootName);
    if( it == m_mapRootNameConfigurations.end() )
        return CXMLNode(NULL);
    else
        return CXMLNode(it->second->xmlDoc.first_node());
}
//-------------------------------------------


CXMLNode::CXMLNode(rapidxml::xml_node<> *pNode)
: m_pNode(pNode)
{

}

CXMLNode::CXMLNode(const CXMLNode &rhs)
: m_pNode(rhs.m_pNode)
{
    
}

CXMLNode::~CXMLNode()
{
    m_pNode = NULL;
}

const char *CXMLNode::getName()
{
    return m_pNode->name();
}

const char *CXMLNode::getAttribute(const char *lpcszAttributeName)
{
    rapidxml::xml_attribute<> *attr = m_pNode->first_attribute(lpcszAttributeName);
    if (attr != NULL)
    {
        return attr->value();
    }
    else
    {
        return NULL;
    }
}

CXMLNode CXMLNode::selectSingleNode(const char *lpcszXPath)
{
    char exp[512] = {0};
    char szNodeName[64] = {0};
    char szAttributeName[512] = {0};
    char szAttributeValue[512] = {0};
    int nIndex = -1;
    char *pStr = (char *)lpcszXPath;
    if( strncmp(pStr,"/",1) == 0 )
        pStr++;
    char *pStart = pStr;
    char *pNext = pStr;
    rapidxml::xml_node<> *pRet = NULL;
    do
    {
        memset(exp, 0, sizeof(char) * 512);
        memset(szNodeName, 0, sizeof(char) * 64);
        memset(szAttributeName, 0, sizeof(char) * 512);
        memset(szAttributeValue, 0, sizeof(char) * 512);
        nIndex = -1;
        pStart = pNext;
        pNext = strstr(pNext, "/");
        if( pNext == NULL )
        {
            strcpy(exp, pStart );
        }
        else
        {
            strncpy(exp, pStart , (size_t)(pNext - pStart));
            pNext++;
        }
        
        //exp
        CCLOG("%s", exp);
        //@
        if( strncmp(exp, "@", 1) == 0 )
            return NULL;
        //[]
        char *pLeftQ = strstr( exp, "[" );
        if( pLeftQ != NULL )
        {
            strncpy(szNodeName, exp, (size_t)(pLeftQ - exp));
            //判断是否index还是@Attribute条件
            char *pRightQ = strstr( pLeftQ, "]");
            if( pRightQ == NULL )   //error
                return NULL;
            //判断@Attribute条件
            if( strstr(pLeftQ, "@") != NULL )
            {
                pLeftQ++;
                char *pEqual = strstr(pLeftQ, "=");
                if( pEqual == NULL )
                    return NULL;
                //name
                strncpy(szAttributeName, pLeftQ+1, (size_t)(pEqual - pLeftQ) - 1);
                strncpy(szAttributeValue, pEqual+1, (size_t)(pRightQ-pEqual) - 1);
                //value
            }
            else    //index
            {
                char szIndex[16];
                strncpy(szIndex, pLeftQ, (size_t)(pRightQ - pLeftQ));
                nIndex = atoi(szIndex);
            }
        }
        else
        {
            strcpy(szNodeName, exp);
        }
        //判断是否
        if( pRet == NULL )
        {
            if( nIndex > -1 )
            {
                int i = 0;
                for( pRet = m_pNode->first_node(szNodeName);
                    pRet != NULL ; pRet = pRet->next_sibling(szNodeName))
                {
                    if( i == nIndex )
                        break;
                }
            }
            else if( strlen(szAttributeName) > 0 && strlen(szAttributeValue) > 0 )
            {
                for( pRet = m_pNode->first_node(szNodeName);
                    pRet != NULL ; pRet = pRet->next_sibling(szNodeName))
                {
                    rapidxml::xml_attribute<> *pAttribute = pRet->first_attribute(szAttributeName);
                    if( pAttribute != NULL && strcmp(pAttribute->value(), szAttributeValue) == 0 )
                    {
                        break;
                    }
                }
            }
            else
            {
                pRet = m_pNode->first_node(exp);
            }
        }
        else
        {
            if( nIndex > -1 )
            {
                int i = 0;
                for( pRet = pRet->first_node(szNodeName);
                    pRet != NULL ; pRet = pRet->next_sibling(szNodeName))
                {
                    if( i == nIndex )
                        break;
                }
            }
            else if( strlen(szAttributeName) > 0 && strlen(szAttributeValue) > 0 )
            {
                for( pRet = pRet->first_node(szNodeName);
                    pRet != NULL ; pRet = pRet->next_sibling(szNodeName))
                {
                    rapidxml::xml_attribute<> *pAttribute = pRet->first_attribute(szAttributeName);
                    if( pAttribute != NULL && strcmp(pAttribute->value(), szAttributeValue) == 0 )
                    {
                        break;
                    }
                }
            }
            else
            {
                pRet = pRet->first_node(exp);
            }
        }
    }
    while(pNext!=NULL);
    return CXMLNode(pRet);
}

CXMLNode CXMLNode::nextSibling(const char *lpcszNodeName)
{
    return CXMLNode(m_pNode->next_sibling(lpcszNodeName));
}

CXMLNodeList CXMLNode::children()
{
    return CXMLNodeList(m_pNode);
}

CXMLNode *CXMLNode::operator=(const CXMLNode &rhs)
{
    m_pNode = rhs.m_pNode;
    return this;
}


CXMLNodeList::CXMLNodeList(rapidxml::xml_node<> *pNode, const char *lpcszDefaultName)
: m_pNode(pNode)
{
    memset(szDefaultChildNodeName, 0, sizeof(char)*64);
    if(lpcszDefaultName != NULL)
    {
        strcpy(szDefaultChildNodeName, lpcszDefaultName);
    }
}

CXMLNodeList::CXMLNodeList(const CXMLNodeList &rhs)
: m_pNode(rhs.m_pNode)
{
    memset(szDefaultChildNodeName, 0, sizeof(char)*64);
    if( strlen(rhs.szDefaultChildNodeName) > 0 )
    {
        strcpy(szDefaultChildNodeName, rhs.szDefaultChildNodeName);
    }
}

CXMLNodeList::~CXMLNodeList()
{
    m_pNode = NULL;
}

CXMLNodeList *CXMLNodeList::operator=(const CXMLNodeList &rhs)
{
    m_pNode = rhs.m_pNode;
    szDefaultChildNodeName[0] = '\0';
    if( strlen(rhs.szDefaultChildNodeName) > 0 )
    {
        strcpy(szDefaultChildNodeName, rhs.szDefaultChildNodeName);
    }
    return this;
}

int CXMLNodeList::getCount(const char *lpcszNodeName)
{
    int nRet = 0;
    for (xml_node<> *pIter = m_pNode->first_node(lpcszNodeName); pIter != NULL; pIter = pIter->next_sibling(lpcszNodeName))
    {
        nRet++;
    }
    return nRet;
}

CXMLNode CXMLNodeList::get(int nIndex, const char *lpcszNodeName)
{
    const char *pszCondition = NULL;
    if( strlen(szDefaultChildNodeName) > 0 )
    {
        pszCondition = szDefaultChildNodeName;
    }
    else if(lpcszNodeName != NULL)
    {
        pszCondition = lpcszNodeName;
    }
    int nCurrentIndex = -1;
    for( xml_node<> *pIter = m_pNode->first_node(pszCondition); pIter != NULL ; pIter = pIter->next_sibling(pszCondition))
    {
        if(++nCurrentIndex == nIndex)
        {
            return CXMLNode(pIter);
        }
    }
    return CXMLNode(NULL);
}


