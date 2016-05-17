//
//  ConfigurationManager.h
//  GameBox
//
//  Created by Caspar on 2013-5-2.
//
//

#ifndef __GameBox__ConfigurationManager__
#define __GameBox__ConfigurationManager__

#include "DataReader.h"
#include "DataWriter.h"
#include "tinyxml.h"
#include <set>

#include "misc/rapidxml.hpp"

using namespace rapidxml;

namespace ptola
{

namespace configuration
{

    class CConfigurationManager
    {
    public:
        CConfigurationManager();
        ~CConfigurationManager();

        static CConfigurationManager *sharedConfigurationManager();
        bool load(const char *lpcszConfigurationFile);
        bool unload(const char *lpcszConfigurationFile);
    private:
        std::set<std::string> m_setLoadedConfigurations;
        std::map<std::string, std::string> m_mapRootElementNames;
    };

    struct SXMLConfig
    {
        SXMLConfig()
        : lpXMLBuffer(NULL)
        {
            memset(szRootName,0,sizeof(char)*32);
            memset(szPath,0,sizeof(char)*1024);
        };

        ~SXMLConfig()
        {
            if( lpXMLBuffer != NULL )
            {
                delete [] lpXMLBuffer;
                lpXMLBuffer = NULL;
            }
        };
        char szRootName[32];
        char szPath[1024];
        rapidxml::xml_document<> xmlDoc;
        char *lpXMLBuffer;
    };

    class CXMLNode;
    class CXMLNodeList;

    class CXMLNode
    {
    public:
        CXMLNode(rapidxml::xml_node<> *pNode);
        CXMLNode(const CXMLNode &rhs);
        ~CXMLNode();
        const char *getAttribute(const char *lpcszAttributeName);
        CXMLNode nextSibling(const char *lpcszNodeName = NULL);
        const char *getName();
        CXMLNodeList children();
        CXMLNode selectSingleNode(const char *lpcszXPath);
        bool isEmpty(){ return m_pNode == NULL; };
        CXMLNode *operator=(const CXMLNode &rhs);
    private:
        rapidxml::xml_node<> *m_pNode;
    };

    class CXMLNodeList
    {
    public:
        CXMLNodeList(rapidxml::xml_node<> *pNode, const char *lpcszDefaultName=NULL);
        CXMLNodeList(const CXMLNodeList &rhs);
        ~CXMLNodeList();
        int getCount(const char *lpcszNodeName = NULL);
        CXMLNode get(int nIndex, const char *lpcszNodeName = NULL);
        CXMLNodeList *operator=(const CXMLNodeList &rhs);
    private:
        rapidxml::xml_node<> *m_pNode;
        char szDefaultChildNodeName[64];
    };
    
    class CConfigurationCache
    {
    public:
        CConfigurationCache();
        ~CConfigurationCache();

        static CConfigurationCache *sharedConfigurationCache();
        bool load(const char *lpcszConfigurationFile);
        bool unload(const char *lpcszConfigurationFile);
        int getXMLNodeList(const char *lpcszRootName, std::vector< rapidxml::xml_node<> > &rOutput, const char *lpcszPath);

        rapidxml::xml_node<> *selectSingleNode(const char *lpcszRootName, const char *lpcszPath);

        rapidxml::xml_attribute<> *getFirstAttribute(rapidxml::xml_node<> *pNode, const char *lpcszAttributeName = NULL);

        rapidxml::xml_node<> *getFirstChildNode(rapidxml::xml_node<> *pNode, const char *lpcszNodeName = NULL);

        const char *getAttribute(const char *lpcszRootName, const char *lpcszPath);
        const char *getRootElementName(const char *lpcszConfigurationFile);

        CXMLNode getRootElement(const char *lpcszRootName);
    private:
        std::map<std::string, SXMLConfig* > m_setLoadedConfigurations;
        std::map<std::string, SXMLConfig* > m_mapRootNameConfigurations;
    };
}

}

#endif /* defined(__GameBox__ConfigurationManager__) */
