//
//  UpdateConfig.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-21.
//
//

#include "UpdateConfig.h"
#include "cocos-ext.h"
#include "FileStream.h"
#include "Application.h"

#include "tinyxml.h"

using namespace rapidxml;
USING_NS_CC;
USING_NS_CC_EXT;
using namespace ptola::update;
using namespace ptola::io;

CUpdateConfig::CUpdateConfig()
: m_bLoaded(false)
, m_bLoadError(false)
{

}

CUpdateConfig::~CUpdateConfig()
{
}

bool CUpdateConfig::isLoaded()
{
    return m_bLoaded;
}

bool CUpdateConfig::isLoadError()
{
    return m_bLoadError;
}

bool CUpdateConfig::loadFromLocal(const char *lpcszFilePath)
{
    m_bLoaded = m_bLoadError = false;
    unsigned long fileLength = 0L;
    char szPath[1024] = {0};
    sprintf(szPath, "%s", CCFileUtils::sharedFileUtils()->fullPathForFilename( lpcszFilePath ).c_str() );
    CCLOG("load from local = %s", szPath);
    bool bexists = CFileStream::exists(szPath);
    CCLOG("exists = %d", bexists);
    unsigned char *lpcszFileData = CCFileUtils::sharedFileUtils()->getFileData(szPath, "r+", &fileLength);
    if( fileLength == 0 )   //read error or file doesn't exists
    {
        if( lpcszFileData == NULL )
        {
            delete[] lpcszFileData;
        }
        m_bLoaded = m_bLoadError = true;
        return false;
    }
    lpcszFileData[ fileLength - 1 ] = '\0';
    m_strXmlData = (char *)lpcszFileData;
    try
    {
        m_xmlDoc.parse<0>((char *)m_strXmlData.c_str());
    }
    catch(const parse_error &e)
    {
        CCMessageBox(e.where<char>(), e.what());
        delete[] lpcszFileData;
        return false;
    }
    delete[] lpcszFileData;
    m_bLoadError = m_bLoaded = true;
    //load ok
    return true;
}


bool CUpdateConfig::loadFromHttp(const char *lpcszHttpPath)
{
    CCLOG("http update url = %s", lpcszHttpPath);
    CCHttpRequest *pRequest = new CCHttpRequest;
    pRequest->setUrl(lpcszHttpPath);
    pRequest->setRequestType(CCHttpRequest::kHttpGet);
    CCHttpClient::getInstance()->setTimeoutForConnect(10);
    CCHttpClient::getInstance()->setTimeoutForRead(30);
    pRequest->setResponseCallback(this, callfuncND_selector(CUpdateConfig::onHttpCallback));
    CCHttpClient::getInstance()->send(pRequest);
    pRequest->release();
    return false;
}

const char *CUpdateConfig::getResourceUrl()
{
    if( !isLoaded() || isLoadError() )
        return NULL;
    xml_node<> *pRootNode = m_xmlDoc.first_node();
    if( pRootNode == NULL )
        return NULL;
    xml_attribute<> *pResUrlAttr = pRootNode->first_attribute("url_ios_res");
    return pResUrlAttr == NULL ? NULL : pResUrlAttr->value();
}

void CUpdateConfig::onHttpCallback(CCNode *pNode, void *pData)
{
    CCHttpResponse *pResponse = (CCHttpResponse *)pData;
    if( pResponse == NULL )
    {
        m_bLoaded = m_bLoadError = true;
        return;
    }
    CCHttpRequest *pRequest = pResponse->getHttpRequest();
    CCLOG("response url2 = %s", pRequest->getUrl() );
    int nStatusCode = pResponse->getResponseCode();
    if( nStatusCode != 200 || !pResponse->isSucceed() )    //HTTP 200 OK
    {
        CCLOG("[Update Module] Http Response(%d) Error: %s", nStatusCode, pResponse->getErrorBuffer());
        m_strErrorBuffer = pResponse->getErrorBuffer();
        m_bLoaded = m_bLoadError = true;
        return;
    }

    std::vector<char> *pBuffer = pResponse->getResponseData();
    m_strXmlData.assign(pBuffer->begin(), pBuffer->end());
    m_httpTmpData.assign(pBuffer->begin(), pBuffer->end());
    const char *lpcszBuffer = m_httpTmpData.c_str();
    try
    {
        m_xmlDoc.parse<0>((char *)lpcszBuffer);
    }
    catch (const parse_error &e)
    {
        CCMessageBox(e.where<char>(), e.what());
        m_bLoaded = true;
        m_bLoadError = true;
        return;
    }
    m_bLoaded = true;
    m_bLoadError = false;
}

const char *CUpdateConfig::getErrorBuffer()
{
    return m_strErrorBuffer.c_str();
}

void CUpdateConfig::saveAs(const char *lpcszFilePath, int nLevelResource)
{
    CTiXmlDocument doc;
    doc.Parse(m_strXmlData.c_str());
    if( nLevelResource < 60 )
    {
        CTiXmlElement *pRoot = doc.RootElement();
        if( pRoot != NULL )
        {
            for(CTiXmlElement *pDElement = pRoot->FirstChildElement("d");
                pDElement != NULL ; pDElement = pDElement->NextSiblingElement("d") )
            {
                if( strcmp(pDElement->Attribute("n"), "060") == 0)
                {
                    pRoot->RemoveChild(pDElement);
                    break;
                }
            }
        }
    }
    const char *lpcszLastUpdateTime = doc.RootElement()->Attribute("time_last");
    if( lpcszLastUpdateTime != NULL )
    {
        int nLastUpdateTime = atoi(lpcszLastUpdateTime);
        CCUserDefault::sharedUserDefault()->setIntegerForKey("LAST_UPDATE_TIME", nLastUpdateTime);
        CCUserDefault::sharedUserDefault()->flush();
    }
    doc.SaveFile(lpcszFilePath);
    
    
//    CFileStream fs(lpcszFilePath, "w");
//    fs.write(m_strXmlData.c_str(), 0, m_strXmlData.length() );
//    fs.flush();
//    fs.close();
}
