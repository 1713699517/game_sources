//
//  LanguageManager.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-2.
//
//

#include "LanguageManager.h"
//#include "tinyxml.h"
#include "PathResolver.h"
#include "rapidxml.hpp"

using namespace ptola::io;
using namespace ptola::configuration;


CLanguageManager::CLanguageManager()
: m_lpcszEmptyString("\0")
, m_lpcszBuffer(NULL)
{
//    setLocate(CCApplication::sharedApplication()->getCurrentLanguage());
    setLocate(kLanguageChinese);
}

void CLanguageManager::setLocate(ccLanguageType lang)
{
    m_mapLangData.clear();
    //load string
    char szLangPath[512] = {0};
    sprintf( szLangPath, "Language.%d.xml" , lang );
    unsigned long uSize = 0UL;
    CC_SAFE_DELETE_ARRAY( m_lpcszBuffer );
    
    unsigned char *lpcszBuffer = CCFileUtils::sharedFileUtils()->getFileData(CPathResolver::getAssetRelativePath(szLangPath), "r", &uSize);
    if( uSize <= 0UL )
    {
        delete[] lpcszBuffer;
        return;
    }
    lpcszBuffer[ uSize - 1 ] = '\0';
    rapidxml::xml_document<> xmlDoc;
    m_lpcszBuffer = lpcszBuffer;
    try
    {
        xmlDoc.parse<0>((char *)m_lpcszBuffer);
    }
    catch (const rapidxml::parse_error &e)
    {
        CCMessageBox(e.where<char>(), e.what());
        delete[] lpcszBuffer;
        m_lpcszBuffer = NULL;
        return;
    }

    rapidxml::xml_node<> *rootNode = xmlDoc.first_node();

    for (rapidxml::xml_node<> *child = rootNode->first_node("string"); child != NULL; child = child->next_sibling("string"))
    {
        rapidxml::xml_attribute<> *id = child->first_attribute("id");
        rapidxml::xml_attribute<> *value = child->first_attribute("value");
        if( id != NULL && value != NULL )
        {
            m_mapLangData[ id->value() ] = value->value();
        }
    }
    //
    m_Lang = lang;
}

ccLanguageType CLanguageManager::getLocate()
{
    return m_Lang;
}

CLanguageManager::~CLanguageManager()
{
    CC_SAFE_DELETE_ARRAY(m_lpcszBuffer);
}

CLanguageManager *CLanguageManager::sharedLanguageManager()
{
    static CLanguageManager mgr;
    return &mgr;
}

const char *CLanguageManager::getString(const char *key)
{
    std::string _key = key;
    std::map<std::string, std::string>::iterator it = m_mapLangData.find(_key);
    return ( it == m_mapLangData.end() ) ? m_lpcszEmptyString : it->second.c_str();
}