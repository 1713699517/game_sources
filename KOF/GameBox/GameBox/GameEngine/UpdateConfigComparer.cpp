//
//  UpdateConfigComparer.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-21.
//
//

#include "UpdateConfigComparer.h"
#include "FileStream.h"
#include <string>

using namespace ptola::update;
using namespace ptola::io;
using namespace rapidxml;

#define MD5_NODE_NAME "m"
#define DIRECTORY_NODE_NAME "d"
#define DIRECTORY_ATTR_NAME "n"
#define FILE_NODE_NAME "f"
#define FILE_ATTR_NAME "n"
#define FILE_ATTR_SIZE "s"

xml_node<> *_internal_httpToLocal_findChildNode(xml_node<> *parent,const char *lpcszNodeName, const char *lpcszAttributeName, const char *lpcszAttributeValue)
{
    if( parent == NULL )
        return NULL;
    for( xml_node<> *child = parent->first_node(lpcszNodeName) ; child != NULL ; child = child->next_sibling(lpcszNodeName) )
    {
        xml_attribute<> *attr = child->first_attribute( lpcszAttributeName );
        if( attr == NULL )
            continue;
        if( strcasecmp( attr->value(), lpcszAttributeValue ) == 0 )
            return child;
    }
    return NULL;
};

void _internal_recursive_compareNode( xml_node<> *local_node, xml_node<> *http_node, const char *lpcszName, CUpdateConfigComparer::CompareResult &Output, size_t *pOutoutSize)
{
    char szPathName[1024];

    //add or update check
    for( xml_node<> *child = http_node->first_node() ; child != NULL ; child = child->next_sibling() )
    {
        strcpy(szPathName, lpcszName);
        const char *nodeName = child->name();
        if( strcasecmp(nodeName, FILE_NODE_NAME) == 0 )
        {
            xml_attribute<> *pAttrFileName = child->first_attribute(FILE_ATTR_NAME);
            if( pAttrFileName == NULL )
                continue;
            xml_attribute<> *pHttpFileMD5 = child->first_attribute(MD5_NODE_NAME);
            if( pHttpFileMD5 == NULL )
                continue;
            xml_attribute<> *pAttrFileSize = child->first_attribute(FILE_ATTR_SIZE);
            
            const char *fileName = pAttrFileName->value();
            //find local
            xml_node<> *localChild = _internal_httpToLocal_findChildNode(local_node, FILE_NODE_NAME, FILE_ATTR_NAME, fileName);
            strcat(szPathName, fileName);

            if( localChild == NULL )
            {   //add file
                if( pAttrFileSize != NULL )
                {
                    const char *fileSize = pAttrFileSize->value();
                    *pOutoutSize += atoi( fileSize );
                }
                Output[ szPathName ] = CUpdateConfigComparer::eUM_Add;
            }
            else
            {
                //check is the same
                xml_attribute<> *pLocalFileMD5 = localChild->first_attribute(MD5_NODE_NAME);
                if( pLocalFileMD5 == NULL )
                {
                    //update
                    goto __lab_update_file;
                }
                //check local is here
//                if( !CFileStream::existsFromResourcePath(szPathName) )
//                {
//                    goto __lab_update_file;
//                }
                if( strcasecmp(pLocalFileMD5->value(), pHttpFileMD5->value()) == 0 )
                {
                    continue;   //no need to update
                }
            __lab_update_file:
                {
                    if( pAttrFileSize != NULL )
                    {
                        const char *fileSize = pAttrFileSize->value();
                        *pOutoutSize += atoi( fileSize );
                    }
                    Output[ szPathName ] = CUpdateConfigComparer::eUM_Update;
                };
            }
        }
        else if( strcasecmp(nodeName, DIRECTORY_NODE_NAME) == 0 )
        {
            xml_attribute<> *pAttrDirName = child->first_attribute(DIRECTORY_ATTR_NAME);
            if( pAttrDirName == NULL )
                continue;
            xml_attribute<> *pAttrDirMD5 = child->first_attribute(MD5_NODE_NAME);
            if( pAttrDirMD5 == NULL )
                continue;
            const char *dirName = pAttrDirName->value();
            if( dirName != NULL )
            {
                strcat(szPathName, dirName);
                strcat(szPathName, "/");
            }
            xml_node<> *localDirNode = _internal_httpToLocal_findChildNode(local_node, DIRECTORY_NODE_NAME, DIRECTORY_ATTR_NAME, dirName);
            if( !CFileStream::existsDirectoryFromResourcePath(szPathName) )
            {
                if( localDirNode != NULL )
                {
                    xml_attribute<> *pLocalAttrMD5 = localDirNode->first_attribute(MD5_NODE_NAME);
                    if( pLocalAttrMD5 != NULL && strcasecmp(pLocalAttrMD5->value(), pAttrDirMD5->value()) == 0 )
                    {
                        continue;   //no need to update
                    }
                }
            }
//            else
//            {
//                if( localDirNode == NULL )
//                    continue;
//            }
            _internal_recursive_compareNode(localDirNode, child, szPathName, Output, pOutoutSize);
        }
    }

    //delete check

    if( local_node != NULL )
    {
        for( xml_node<> *child = local_node->first_node() ; child != NULL ; child = child->next_sibling() )
        {
            strcpy(szPathName, lpcszName);
            
            const char *nodeName = child->name();
            if( strcasecmp(nodeName, FILE_NODE_NAME) == 0 )
            {
                //
                xml_attribute<> *pAttrFileName = child->first_attribute(FILE_ATTR_NAME);
                if( pAttrFileName == NULL )
                    continue;
                const char *fileName = pAttrFileName->value();
                xml_node<> *httpChild = _internal_httpToLocal_findChildNode(http_node, FILE_NODE_NAME, FILE_ATTR_NAME, fileName);
                if( httpChild == NULL )
                {   //delete
                    strcat(szPathName, fileName);
                    Output[ szPathName ] = CUpdateConfigComparer::eUM_Delete;
                }
            }
            else if( strcasecmp(nodeName, DIRECTORY_NODE_NAME) == 0 )
            {
                xml_attribute<> *pAttrDirName = child->first_attribute(DIRECTORY_ATTR_NAME);
                if( pAttrDirName == NULL )
                    continue;
                const char *dirName = pAttrDirName->value();
                xml_node<> *httpDirNode = _internal_httpToLocal_findChildNode(http_node, DIRECTORY_NODE_NAME, DIRECTORY_ATTR_NAME, dirName);
                if( httpDirNode == NULL )
                {   //delete
                    strcat(szPathName, dirName);
                    strcat(szPathName, "/");
                    Output[ szPathName ] = CUpdateConfigComparer::eUM_Delete;
                }
            }
        }
    }
};

bool CUpdateConfigComparer::compare(const CUpdateConfig &local, const CUpdateConfig &http, CompareResult &Output, size_t *pOutoutSize)
{
    *pOutoutSize = 0U;
    Output.clear();
    xml_node<> *pLocalRoot = local.m_xmlDoc.first_node();
    if( pLocalRoot == NULL )
        return true;
    xml_node<> *pHttpRoot  = http.m_xmlDoc.first_node();
    if( pHttpRoot == NULL )
        return true;

    xml_attribute<> *pIsUpdate = pHttpRoot->first_attribute("is_update");
    if (pIsUpdate != NULL && strcmp(pIsUpdate->value(), "0") == 0 )
    {
        return true;
    }
#if (AGENT_SDK_CODE == 3)
    xml_attribute<> *pAppStoreUpdate = pHttpRoot->first_attribute("app_store");
    const char *lpAppStoreUpdateValue = pAppStoreUpdate->value();
    if (strcmp(lpAppStoreUpdateValue, "0") == 0)
    {
        return true;
    }
#endif
//    xml_attribute<> *pLocalMd5 = pLocalRoot->first_attribute(MD5_NODE_NAME);
//    if( pLocalMd5 == NULL )
//        return true;
//
//    
//    xml_attribute<> *pHttpMd5  = pHttpRoot->first_attribute(MD5_NODE_NAME);
//    if( pHttpMd5 == NULL )
//        return true;
//
//    if( strcasecmp(pLocalMd5->value(), pHttpMd5->value()) == 0 )
//    {
//        return true;
//    }

    //diff
    _internal_recursive_compareNode( pLocalRoot, pHttpRoot, "", Output , pOutoutSize);

    //delete local xml ptr

    
    return Output.empty();
}