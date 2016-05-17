//
//  GameUpdateScene.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-14.
//
//

#include "GameUpdateScene.h"
#include "Launcher.h"
#include "UpdateConfigComparer.h"
#include "FileStream.h"
#include "Device.h"
#include "DateTime.h"
#include "PathResolver.h"
#include "Constant.h"
#include "MD5Crypto.h"
#include "Application.h"
#include "ptola.h"
#include "AWebView.h"
#include <signal.h>

#include "_553_SDK.h"


#include "_553_Login.h"
#include "LoginHttpApi.h"

#include "SwitchScene.h"

#include "_553_Android_Login.h"


#include "_PP_IOS_Login.h"

#include "UpdateLogView.h"

#include "Mi_Login.h"

#include "Wdj_Login.h"

#include "_360_Android_Login.h"

#include "_91_Android_Login.h"

#include "_APP_Login.h"

#include "_OPPO_Android_Login.h"
#include "_UC_Android_Login.h"
#include "_baidu_Login.h"

using namespace ptola;
using namespace ptola::io;
USING_NS_CC;
USING_NS_CC_EXT;

#define HTTP_CHECK_TAG  100000


#define UPDATE_SIZE_WITH_PROMPT 1024*1024   //1M
#define UPDATE_THREAD_IN_SAME_TIME  5       //5

CGameUpdateScene::CGameUpdateScene()
:pWebView(NULL)
, m_mutexObj()
{

}

CGameUpdateScene::~CGameUpdateScene()
{
    if (!(m_mutexObj.TryLock()))
    {
        kill(m_pidMutexOwner, SIGIO);
        m_mutexObj.Lock();
    }
    m_mutexObj.Unlock();
}

CGameUpdateScene *CGameUpdateScene::create(int nLevelLimit)
{
    CGameUpdateScene *pRet = new CGameUpdateScene;
    if( pRet != NULL && pRet->init(nLevelLimit) )
    {
        pRet->autorelease();
        return pRet;
    }
    else
    {
        CC_SAFE_DELETE(pRet);
        return NULL;
    }
}

CCScene *CGameUpdateScene::scene(int nLevelLimit)
{
    CCScene *pScene = CCScene::create();
    if( pScene != NULL )
    {
        CGameUpdateScene *pLayer = CGameUpdateScene::create(nLevelLimit);
        if( pLayer != NULL )
        {
            pScene->addChild(pLayer);
        }
    }
    return pScene;
}

bool CGameUpdateScene::init(int nLevelLimit)
{
    if( !CCLayer::init() )
        return false;

    m_nLevelLimit = nLevelLimit;
    
    //CCTextureCache::sharedTextureCache()->removeUnusedTextures();
    //CCSpriteFrameCache::sharedSpriteFrameCache()->removeUnusedSpriteFrames();
    //unload all unused resource

    m_pBackground = CCSprite::create("update/loading_underframe.jpg");
    if( m_pBackground != NULL )
    {
        addChild(m_pBackground);
    }

    m_pProgressBackground = CCScale9Sprite::create("update/loading_strip_frame.png");
    if( m_pProgressBackground != NULL )
    {
        m_pProgressBackground->setPreferredSize(CCSizeMake(547, 12));
        addChild(m_pProgressBackground);
    }
    m_pProgressTransparentBackground = CCSprite::create("transparent.png");
    m_pProgressTransparentBackground->setContentSize(CCSizeMake(m_pProgressBackground->getPreferredSize().width - 50.0f,1.0f));
    m_pProgressProcess    = CCSprite::create("update/loading_strip.png");
    m_pProgressThumb      = CCSprite::create();

    m_pProgressParticle = CMovieClip::create("CharacterMovieClip/effects_loading.ccbi");
    if( m_pProgressParticle != NULL )
    {
        m_pProgressParticle->play("effects_loading");
        m_pProgressThumb->addChild(m_pProgressParticle);
    }
//    m_pProgressParticle   = NULL;//CCParticleFlower::create();
//    if( m_pProgressParticle != NULL )
//    {
//        m_pProgressParticle->setTexture(CCTextureCache::sharedTextureCache()->addImage("ccbResources/ccbParticleStars.png"));
//        m_pProgressParticle->setPosVar(ccp(10.0f, 5.0f));
//        m_pProgressParticle->setStartColor(ccc4f(0.33f, 0.94f, 0.71, 1.0f));
//        m_pProgressParticle->setEndColor(ccc4f(0.33f, 0.94f, 0.71, 0.0f));
//        
////        m_pProgressParticle->setAngle(180.0f);
////        m_pProgressParticle->setAngleVar(1.0f);
////        m_pProgressParticle->setTotalParticles(35U);
////        m_pProgressParticle->setEmissionRate(40.0f);
//
//        m_pProgressParticle->setAngle(0.0);
//        m_pProgressParticle->setAngleVar(359.0f);
//        m_pProgressParticle->setTotalParticles(220U);
//        m_pProgressParticle->setEmissionRate(110.0f);
//
//        m_pProgressParticle->setLife(0.5f);
//        m_pProgressParticle->setLifeVar(0.25f);
//        m_pProgressParticle->setStartSize(10.0f);
//        m_pProgressParticle->setStartSizeVar(5.0f);
//        m_pProgressParticle->setSpeed(100.0f);
//        m_pProgressParticle->setSpeedVar(10.0f);
//        m_pProgressParticle->setAnchorPoint(CCPointZero);
//        m_pProgressParticle->setPosition(CCPointZero);
//        m_pProgressThumb->addChild(m_pProgressParticle);
//    }
    m_pProgress = CCControlSlider::create(m_pProgressTransparentBackground, m_pProgressProcess, m_pProgressThumb);
    
    if( m_pProgress != NULL )
    {
        m_pProgress->setMinimumAllowedValue(0.0f);
        m_pProgress->setMinimumValue(0.0f);
        m_pProgress->setMaximumAllowedValue(1.0f);
        m_pProgress->setMaximumValue(1.0f);
        m_pProgress->setTouchEnabled(false);
        addChild(m_pProgress);
    }
    layout();

    m_pProgress->setValue(0.0f);

    CCSize winSize = CCDirector::sharedDirector()->getVisibleSize();
    m_pProcessingLabel = CCLabelTTF::create("资源加载中...", "Arial", 22.0f);
    CCSize fcs = m_pProcessingLabel->getContentSize();
    CCSize scs = CCDirector::sharedDirector()->getVisibleSize();
    m_pProcessingLabel->setDimensions(CCSizeMake(scs.width, fcs.height));
    m_pProcessingLabel->setPosition(ccp(winSize.width/2,90));
    addChild(m_pProcessingLabel);
//    //test
//    CUpdateConfig config;
//    config.loadFromLocal("update.xml");
//
//    size_t size = 0U;
//    CUpdateConfigComparer::CompareResult result;
//    CUpdateConfigComparer::compare(config, config, &result, &size);
//    CUpdateConfig config2;
//    config2.loadFromHttp("");
    //
    initializeFirstRun();

    return true;
}

//void CGameUpdateScene::onLocate()
//{
//
//}



void CGameUpdateScene::onInitializedAsset(cocos2d::CCObject *pTarget, ptola::event::CEvent *pEvent)
{
    CCInteger *pInt = (CCInteger *)pEvent->getData();
//    m_nAll = pInt->getValue();
//    m_nCurrent = 0;
//    char szStr[64];
//    strcpy(szStr, "解包中...");
//    m_pProcessingLabel->setString(szStr);
    CCLOG("begin initialize asset file need to be copy count=%d", pInt->getValue());
}

void CGameUpdateScene::onProgressAsset(cocos2d::CCObject *pTarget, ptola::event::CEvent *pEvent)
{
    CCFloat *pPercentage = (CCFloat *)pEvent->getData();
    float fProgressPercentage = pPercentage->getValue();
    m_pProgress->setValue( fProgressPercentage * m_fPercentCopyAsset);

//    char szStr[64];
//    sprintf(szStr, "(%d/%d)", ++m_nCurrent, m_nAll);
//    m_pProcessingLabel->setString(szStr);
    
}

void CGameUpdateScene::onCompleteAsset(cocos2d::CCObject *pTarget, ptola::event::CEvent *pEvent)
{
    CCLOG("end copy!");
    CCSequence *pInterval = CCSequence::create(CCDelayTime::create(0.1f), CCCallFunc::create(this, callfunc_selector(CGameUpdateScene::checkUpdate)), NULL);
    runAction(pInterval);
    CLauncher::sharedLauncher()->purgeLauncher();
}


void CGameUpdateScene::statisticsApp()
{
    CCHttpRequest *pRequest = new CCHttpRequest;
    char szID[64] = {0};
    const char *lpcszVersion = CDevice::sharedDevice()->getOSVersion();
    float version = atof(lpcszVersion);
    if( version >= 7.0f )
    {
        
    }
    else
    {
        strcpy(szID, CDevice::sharedDevice()->getMAC() );
    }
    CDateTime nowTime;
    int nLocalTime          = nowTime.getTotalSeconds();
    char szTime[64];
    sprintf(szTime, "%d", nLocalTime);
    char szSign[1024];
    sprintf(szSign, "%s%d%s%s%d", szID, 211000, "jksdf832jfdff;e0354w6ftyvkl", szTime, 2);

    char szPath[1024];
    strcpy(szPath,"http://mapi.553.com/phonegame/tj/?sign=");
    strcat(szPath, CMD5Crypto::md5(szSign, strlen(szSign)));
    strcat(szPath, "&sn=");
    strcat(szPath, szID);
    strcat(szPath, "&fid=");
    strcat(szPath, "211000");
    strcat(szPath, "&type=");
    strcat(szPath, "2");
    strcat(szPath, "&t=");
    strcat(szPath, szTime);
    strcat(szPath, "&v=");
    strcat(szPath, "v1");
    
    //

    //md5String.c_str()//md5(sn.c_str()+fid.c_str()+key+time+type.c_str())

    //sprintf(urlchar, "%s&sn=%s&fid=%s&type=%s&t=%ld&v=%s", md5String.c_str(),sn.c_str(),fid.c_str(),type.c_str(),time,version.c_str()) ;

    pRequest->setUrl(szPath);
    pRequest->setRequestType(CCHttpRequest::kHttpGet);
    pRequest->setResponseCallback(this, callfuncND_selector(CGameUpdateScene::onStatisticsCallBack));
    CCHttpClient::getInstance()->send(pRequest);
    pRequest->release();
}

void CGameUpdateScene::onStatisticsCallBack(CCNode *pNode, void *pData)
{
    CCHttpResponse *pResponse = (CCHttpResponse *)pData;
    if( pResponse->isSucceed() && pResponse->getResponseCode() == 200 )
    {
        std::vector<char> *pResponseData = pResponse->getResponseData();
        std::string strBuffer( pResponseData->begin(), pResponseData->end());
        if( strcmp(strBuffer.c_str(), "3") != 0 )
        {
            statisticsApp();
        }
    }
}

void CGameUpdateScene::initializeFirstRun()
{
    if(CLauncher::hasVersionFile())
    {
        m_fPercentCopyAsset = 0.0f;
        m_fPercentUpdate    = 1.0f;
        checkUpdate();
        return;
    }
#if (AGENT_SDK_CODE == 3)
    statisticsApp();
#endif
    CCLOG("Copy Asset Files To The Resource Directory!");
    //10 percent progress for copy the file to Resource Directory
    CLauncher::sharedLauncher()->addEventListener("InitAsset", this, eventhandler_selector(CGameUpdateScene::onInitializedAsset));
    CLauncher::sharedLauncher()->addEventListener("ProgressAsset", this, eventhandler_selector(CGameUpdateScene::onProgressAsset));
    CLauncher::sharedLauncher()->addEventListener("CompleteAsset", this, eventhandler_selector(CGameUpdateScene::onCompleteAsset));

    m_fPercentCopyAsset = 0.1f;
    m_fPercentUpdate    = 0.9f;
    
    CLauncher::sharedLauncher()->copyAssetToResource();
}

void CGameUpdateScene::checkUpdate()
{
#ifdef LOCAL_VERSION
    onUpdateComplete();
    return;
#endif
    CDateTime nowTime;
    int nLocalTime          = nowTime.getTotalSeconds();
    // begin by:yiping
    const char *lpcszMac  = CDevice::sharedDevice()->getMAC();
    char lpcszUuid[64];
    strcpy( lpcszUuid, CCUserDefault::sharedUserDefault()->getStringForKey("uuid").c_str() );
    if( strlen(lpcszUuid) == 0 )
    {
        strcpy(lpcszUuid, "0");
    }
    const char *lpcszVersions = CApplication::sharedApplication()->getBundleVersion();
    
    char lpcszOs[1024] =
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    "iOS"
#else
    "Android"
#endif
    ;
    char lpcszOsVer[1024] = {0};
    CCSize _resSize = CCDirector::sharedDirector()->getVisibleSize();
    char lpcszRes[1024] = {0};
    sprintf(lpcszRes, "%d", (int)_resSize.height);
    char lpcszResVer[1024] = {0};
    char lpcszSource[1024] = {0};
    char lpcszSourceSub[1024] = {0};
    //const char *lpcszDevice    = CDevice::sharedDevice()->getModel();
    char lpcszDevice[1024] = {0};
    char lpcszScreen[1024]    = {0};
    char lpcszLanguage[1024]  = {0};
    char lpcszReferrer[1024]  = {0};
    
    char lpcszCid[1024]  = CID_w_217; // 
    char lpcszKey[1024]  = PRIVATEKEY_W_217; //
    char lpcszTime[1024] = {0}; //
    sprintf(lpcszTime, "%d", nLocalTime);


    int nLastUpdateTime = CCUserDefault::sharedUserDefault()->getIntegerForKey("LAST_UPDATE_TIME", 0);
    char lpcszLastUpdateTime[64] = {0};
    sprintf(lpcszLastUpdateTime, "%d", nLastUpdateTime);
    // end by:yiping
    
    char szSign[1024] = {0};
    strcat(szSign, "cid=");
    strcat(szSign, lpcszCid);
    
    strcat(szSign, "&mac=");
    strcat(szSign, lpcszMac);
    
    strcat(szSign, "&uuid=");
    strcat(szSign, lpcszUuid);
    
    strcat(szSign, "&versions=");
    strcat(szSign, lpcszVersions);
    
    strcat(szSign, "&os=");
    strcat(szSign, lpcszOs);
    
    strcat(szSign, "&os_ver=");
    strcat(szSign, lpcszOsVer);
    
    strcat(szSign, "&res=");
    strcat(szSign, lpcszRes);
    
    strcat(szSign, "&res_ver=");
    strcat(szSign, lpcszResVer);
    
    strcat(szSign, "&source=");
    strcat(szSign, lpcszSource);
    
    strcat(szSign, "&source_sub=");
    strcat(szSign, lpcszSourceSub);
    
    strcat(szSign, "&device=");
    strcat(szSign, lpcszDevice);
    
    strcat(szSign, "&screen=");
    strcat(szSign, lpcszScreen);
    
    strcat(szSign, "&language=");
    strcat(szSign, lpcszLanguage);
    
    strcat(szSign, "&referrer=");
    strcat(szSign, lpcszReferrer);
    
    strcat(szSign, "&time=");
    strcat(szSign, lpcszTime);
    // URL
    char szUrl[1024]  = {0};
    sprintf(szUrl, PHONE_UPDATE_URL, SDK_HOST);
    strcat(szUrl, szSign);
    // key
    strcat(szSign, "&key=");
    strcat(szSign, lpcszKey);
    // Md5
    std::string szSignMd5 = CMD5Crypto::md5(szSign, strlen(szSign));
    strcat(szUrl, "&sign=");
    strcat(szUrl, szSignMd5.c_str() );

    //time
    strcat(szUrl, "&time_last=");
    strcat(szUrl, lpcszLastUpdateTime);
    //zip
    strcat(szUrl, "&zip=0");

    //cid={$args['cid']}&mac={$args['mac']}&uuid={$args['uuid']}&versions={$args['versions']}&os={$args['os']}&os_ver={$args['os_ver']}&res={$args['res']}&res_ver={$args['res_ver']}&source={$args['source']}&source_sub={$args['source_sub']}&device={$args['device']}&screen={$args['screen']}&language={$args['language']}&referrer={$args['referrer']}&time={$args['time']}&key={$key}
    // m_httpConfig.loadFromHttp("http://192.168.1.9:89/api/u/ios/640/update.xml?cid=217");
    CCLOG(szUrl);
    m_httpConfig.loadFromHttp(szUrl);
    if(m_localConfig.loadFromLocal("update.xml"))
    {
        CCSequence *pInterval = CCSequence::create(CCDelayTime::create(0.1f), CCCallFunc::create(this, callfunc_selector(CGameUpdateScene::onHttpLoading)), NULL);
        CCActionInterval * pActions = CCRepeatForever::create(pInterval);
        pActions->setTag(HTTP_CHECK_TAG);
        runAction(pActions);
    }
    else
    {
        CCLOG("load error");
    }
}

void CGameUpdateScene::onHttpLoading()
{
    if( m_httpConfig.isLoaded() )
    {
        CCLOG("complete loaded");
        stopActionByTag(HTTP_CHECK_TAG);
        if( m_httpConfig.isLoadError() )
        {
            CCMessageBox(m_httpConfig.getErrorBuffer(), "Update Error");
            return;
        }
        checkAndStartUpdate();
    }
}

void CGameUpdateScene::checkAndStartUpdate()
{
    m_mapUpdateResult.clear();
    size_t uOutput;
    
    
    if(!CUpdateConfigComparer::compare(m_localConfig, m_httpConfig, m_mapUpdateResult, &uOutput))
    {
        std::vector<std::string> m_Filted;
        char szLevel[16];
        for( CUpdateConfigComparer::CompareResult::iterator it = m_mapUpdateResult.begin(); it != m_mapUpdateResult.end(); it++ )
        {
            size_t sPos = it->first.find("/");
            if( sPos != std::string::npos )
            {
                strncpy(szLevel, it->first.c_str(), sPos);
                int nLevel = atoi(szLevel);
                if( nLevel > m_nLevelLimit )
                {
                    m_Filted.push_back(it->first);
                }
            }
        }
        for (std::vector<std::string>::iterator it2 = m_Filted.begin(); it2 != m_Filted.end(); it2++)
        {
            m_mapUpdateResult.erase(*it2);
        }
        //
//        if( uOutput > UPDATE_SIZE_WITH_PROMPT && CDevice::sharedDevice()->getNetworkStatus() == eNS_WWAN )
//        {   //prompt
//            CCLOG("prompt to update");
//        }
//        else
        {
            beginUpdate(true);
        }
    }
    else
    {
        m_pProgress->setValue(1.0f);
//        onUpdateComplete();
        
        beginUpdate(false);
        if (m_pProcessingLabel != NULL) {
            CCSize winSize = CCDirector::sharedDirector()->getVisibleSize();
            
            m_pProcessingLabel->setString("加载完成!");
            m_pProcessingLabel->setPosition(ccp(winSize.width/2-190,90));
        }
    }
}

void CGameUpdateScene::beginUpdate(bool isUpdate)
{
    bool _isUpdate = isUpdate;
    m_nCurrentDownloadTotoal = m_nCurrentDownload = 0;
    if( m_mapUpdateResult.empty() )
    {
        _isUpdate = false;
        m_pProgress->setValue(1.0f);
        
        if (m_pProcessingLabel != NULL) {
            CCSize winSize = CCDirector::sharedDirector()->getVisibleSize();
            
            m_pProcessingLabel->setString("加载完成!");
            m_pProcessingLabel->setPosition(ccp(winSize.width/2-190,90));
        }
//        onUpdateComplete();
//        return;
    }

    pWebView = CUpdateLogView::create(this,_isUpdate);
    addChild(pWebView);
}

void CGameUpdateScene::continueUpdate()
{
    m_nCurrentDownloadTotoal = (int)m_mapUpdateResult.size();
    m_setCurrentUpdateing.clear();



    m_nAll = (int)m_nCurrentDownloadTotoal;
    m_nCurrent = 0;
    char szStr[64];
    sprintf(szStr, "(%d/%d)", m_nCurrent, m_nAll);
    m_pProcessingLabel->setString(szStr);

    //start update
    const char *lpPathPrefix = m_httpConfig.getResourceUrl();
    int nCount = 0;

    //delete files that need to be deleted
    for( CUpdateConfigComparer::CompareResult::iterator it = m_mapUpdateResult.begin() ;
        it != m_mapUpdateResult.end(); it++ )
    {
        if( it->second == CUpdateConfigComparer::eUM_Delete )
        {
            char szPath[1024] = {0};
            sprintf(szPath, "%s", CCFileUtils::sharedFileUtils()->fullPathForFilename(it->first.c_str()).c_str() );
            bool bret = CFileStream::deleteFile(szPath);
            CCLOG("[delete %d] %s", bret, szPath);
            m_nCurrentDownload++;

            m_nCurrent = m_nCurrentDownload;
            sprintf(szStr, "(%d/%d)", m_nCurrent, m_nAll);
            m_pProcessingLabel->setString(szStr);
        }
    }
    //update files in thread
    for( CUpdateConfigComparer::CompareResult::iterator it = m_mapUpdateResult.begin() ;
        it != m_mapUpdateResult.end() && nCount < UPDATE_THREAD_IN_SAME_TIME ; it++ )
    {
        if( it->second == CUpdateConfigComparer::eUM_Add || it->second == CUpdateConfigComparer::eUM_Update )
        {
            updateFile(lpPathPrefix, it->first.c_str());
            nCount++;
        }
    }
    if( nCount == 0 )
    {
        onUpdateComplete();
    }

}

void CGameUpdateScene::updateFile(const char *lpcszPathPrefix, const char *lpcszFilePath)
{
    waitMutex();
    char szPath[1024] = {0};
    sprintf(szPath, "%s%s", lpcszPathPrefix, lpcszFilePath);
    CCLOG("[update] %s", szPath);


    char szStr[1024];
    sprintf(szStr, "(%d/%d) %s", m_nCurrent, m_nAll, lpcszFilePath);
    m_pProcessingLabel->setString(szStr);
    
    CCHttpRequest *pRequest = new CCHttpRequest;
    pRequest->setUrl(szPath);
    pRequest->setRequestType(CCHttpRequest::kHttpGet);
    pRequest->setTag(lpcszFilePath);
    pRequest->setResponseCallback(this, callfuncND_selector(CGameUpdateScene::onProgressUpdate));
    m_setCurrentUpdateing.insert(lpcszFilePath);
    CCHttpClient::getInstance()->send(pRequest);
    pRequest->release();
    clearMutex();
}

void CGameUpdateScene::onProgressUpdate(cocos2d::CCNode *pNode, void *pData)
{
    CCHttpResponse *pResponse = static_cast<CCHttpResponse *>(pData);
    if( pResponse == NULL )
        return;
    CCHttpRequest *pRequest = pResponse->getHttpRequest();
    if( pRequest == NULL )
        return;
    waitMutex();
    const char *lpcszUrl = m_httpConfig.getResourceUrl();
    const char *lpcszTag = pRequest->getTag();

    int nStatusCode = pResponse->getResponseCode();
    char szStr[1024];
    if( nStatusCode != 200 )
    {   //load error
        CCLOG("StatusCode [%d] %s%s", nStatusCode, lpcszUrl, lpcszTag);

        sprintf(szStr, "(%d/%d) [%d] %s%s", m_nCurrent, m_nAll, nStatusCode, lpcszUrl, lpcszTag);
        m_pProcessingLabel->setString(szStr);
        clearMutex();
        
        updateFile(lpcszUrl, lpcszTag);
        return;
    }
    if( !pResponse->isSucceed() )
    {
        clearMutex();
        CCLOG("Update Not success %s%s", lpcszUrl, lpcszTag);
        updateFile(lpcszUrl, lpcszTag);
        return;
    }
    std::vector<char> *pResponseData = pResponse->getResponseData();
    if( pResponseData == NULL )
    {
        clearMutex();
        updateFile(lpcszUrl, lpcszTag);
        return;
    }
    //write the data to file
    //local path
    char szLocalPath[1024] = {0};
    sprintf(szLocalPath, "%s%s", CApplication::sharedApplication()->getResourcePath(), lpcszTag);
    //if exists , delete it
    if( CFileStream::exists(szLocalPath) )
        CFileStream::deleteFile(szLocalPath);
    //find the directory
    char *pPos = strstr(szLocalPath, "/");
    char *lastSlash = pPos;
    while( pPos != NULL )
    {
        pPos = strstr( pPos + 1 , "/" );
        if( pPos != NULL )
            lastSlash = pPos;
    }
    if( lastSlash != NULL )
    {
        size_t len = lastSlash - szLocalPath + 1;
        char szDirPath[1024];
        strncpy(szDirPath, szLocalPath, len);
        if(!CFileStream::existsDirectory(szDirPath))
            CFileStream::createDirectoryRecursive(szDirPath);
    }
    
    //write a new file
    CFileStream fs(szLocalPath, "wb");
    size_t uLen = pResponseData->size();
    for( size_t i = 0 ; i < uLen ; i++ )
    {
        char chData = pResponseData->at(i);
        fs.write(&chData, 0, sizeof(char));
    }
    fs.flush();
    fs.close();
    //update complete, set progress
    m_nCurrentDownload++;
    float fCurrPercent = m_fPercentCopyAsset + ((float)m_nCurrentDownload / (float)m_nCurrentDownloadTotoal) * m_fPercentUpdate;

    m_nCurrent++;
    sprintf(szStr, "(%d/%d) %s", m_nCurrent, m_nAll, lpcszTag);
    
    m_pProgress->setValue(fCurrPercent);
    m_pProcessingLabel->setString(szStr);

    clearMutex();
    //check if any other
    for( CUpdateConfigComparer::CompareResult::iterator it = m_mapUpdateResult.begin();
        it != m_mapUpdateResult.end(); it++ )
    {
        if( m_setCurrentUpdateing.find(it->first.c_str()) != m_setCurrentUpdateing.end() )
        {
            continue;
        }
        if( it->second == CUpdateConfigComparer::eUM_Delete )
        {
            continue;
        }
        //not updating , start update
        updateFile(lpcszUrl, it->first.c_str());
        break;
    }
    //m_setCurrentUpdateing.erase(lpcszTag);
    if( m_nCurrentDownload == m_nCurrentDownloadTotoal )
    {
        waitMutex();
        char szPath[1024] = {0};
        sprintf(szPath, "%s%s", CApplication::sharedApplication()->getResourcePath(), "update.xml");

        CCLOG("[All File Downloaded] save to %s", szPath);
        m_httpConfig.saveAs(szPath, m_nLevelLimit);
        CCSize winSize = CCDirector::sharedDirector()->getVisibleSize();
        
        m_pProcessingLabel->setString("更新完成!");
        m_pProcessingLabel->setPosition(ccp(winSize.width/2-190,90));
//        
        if (pWebView != NULL)
        {
            pWebView->endUpdata();
        }
        else
        {
            onUpdateComplete();
        }
        clearMutex();
    }
}

void CGameUpdateScene::updataEndBtnCallBack( float dt )
{
    delayComplete(dt);
}

void CGameUpdateScene::onUpdateComplete()
{
    //testscene-->go to login
    //update to update.xml
    if( m_pProgressThumb != NULL )
    {
        m_pProgressThumb->removeChild(m_pProgressParticle, true);
    }
    m_pProgress->setValue(1.0f);
    scheduleOnce(schedule_selector(CGameUpdateScene::delayComplete), 0.2f);
    CCLOG("update complete!!!");
}

void CGameUpdateScene::delayComplete(float dt)
{
    
    if( m_nLevelLimit > 0 )
    {
        //改写CCUserDefault
        int nLevel = CCUserDefault::sharedUserDefault()->getIntegerForKey("LevelResource", 0);
        if( nLevel > m_nLevelLimit )
        {
            CCUserDefault::sharedUserDefault()->setIntegerForKey("LevelResource", m_nLevelLimit);
        }
        CCDirector::sharedDirector()->popScene();
        CCNotificationCenter::sharedNotificationCenter()->postNotification("LevelResource");
    }
    else
    {
#ifdef SINGLE_VERSION
    
    CCScriptEngineProtocol *pEngineProtocol = CCScriptEngineManager::sharedManager()->getScriptEngine();
    CCLuaEngine *pEngine = dynamic_cast<CCLuaEngine *>(pEngineProtocol);
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    CCString* pstrFileContent = CCString::createWithContentsOfFile("hello.lua");
    if (pstrFileContent)
    {
        pEngine->executeString(pstrFileContent->getCString());
    }
#else
    if( pEngine != NULL )
    {
        std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("hello.lua");
        pEngine->addSearchPath(path.substr(0, path.find_last_of("/")).c_str());
        pEngine->executeScriptFile(path.c_str());
    }
#endif

#else
    
//    CCScene *pSDK_Scene = C553_SDK::scene();
//    CCDirector::sharedDirector()->replaceScene(pSDK_Scene);
//    CCLOG("goto 553 sdk");


//#if( AGENT_SDK_CODE == 1 )
//    CCScene *p553Login_Scene = C553_Login::scene();
//    CCDirector::sharedDirector()->replaceScene(p553Login_Scene);
//#endif
#if (AGENT_SDK_CODE == 2)
        CCScene *p360_Login_Scene = C360_Android_Login::scene();
        CCDirector::sharedDirector()->replaceScene(p360_Login_Scene);
#elif (AGENT_SDK_CODE == 3)
        CCScene *APP_Login_Scene = CAPP_Login::scene();
        CCDirector::sharedDirector()->replaceScene(APP_Login_Scene);
#elif (AGENT_SDK_CODE == 4)   //553 Android SDK
    CCScene *p553_Android_Login_Scene = C553_Android_Login::scene();
    CCDirector::sharedDirector()->replaceScene(p553_Android_Login_Scene);
#elif (AGENT_SDK_CODE == 5)
    CCScene *pPP_IOS_Login_Scene = CPP_IOS_Login::scene();
    CCDirector::sharedDirector()->replaceScene(pPP_IOS_Login_Scene);
#elif (AGENT_SDK_CODE == 6)
    CCScene *pScene = C553_Login::scene();
    CLoginHttpApi::setInternalVerify(false);
    CCDirector::sharedDirector()->replaceScene(pScene);
#elif (AGENT_SDK_CODE == 7)
    CCScene *pScene = CMi_Login::scene();
    if( pScene != NULL )
    {
        CLoginHttpApi::setInternalVerify(true);
        CCDirector::sharedDirector()->replaceScene(pScene);
    }
#elif (AGENT_SDK_CODE == 8)
        CCScene *pScene = COppo_Login::scene();
        if( pScene != NULL )
        {
            CLoginHttpApi::setInternalVerify(true);
            CCDirector::sharedDirector()->replaceScene(pScene);
        }
#elif (AGENT_SDK_CODE == 9)
    CCScene *pScene = C91Android_Login::scene();
    if( pScene != NULL )
    {
        CLoginHttpApi::setInternalVerify(true);
        CCDirector::sharedDirector()->replaceScene(pScene);
    }
#elif (AGENT_SDK_CODE == 10)
        CCScene *pScene = UC_Android_Login::scene();
        if( pScene != NULL )
        {
            CLoginHttpApi::setInternalVerify(true);
            CCDirector::sharedDirector()->replaceScene(pScene);
        }
#elif (AGENT_SDK_CODE == 12)
        CCScene *pScene = CBaidu_Login::scene();
        if( pScene != NULL )
        {
            CLoginHttpApi::setInternalVerify(true);
            CCDirector::sharedDirector()->replaceScene(pScene);
        }
#elif (AGENT_SDK_CODE == 13)
        CCScene *pScene = CWdj_Login::scene();
        if( pScene != NULL )
        {
            CLoginHttpApi::setInternalVerify(true);
            CCDirector::sharedDirector()->replaceScene(pScene);
        }
#else
    CCScene *pSwitchScene = CSwitchScene::scene();
    CCDirector::sharedDirector()->replaceScene(pSwitchScene);
#endif

#endif
    }
    unschedule(schedule_selector(CGameUpdateScene::delayComplete));
}

void CGameUpdateScene::layout()
{
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();

    ///640
    m_pBackground->setPosition(ccp(winSize.width/2.0f, winSize.height/2.0f));
    m_pProgressTransparentBackground->setContentSize(CCSizeMake(526.0f,1.0f));
    m_pProgressBackground->setPosition(ccp(winSize.width/2.0f + 30.0f, 70.0f));
    m_pProgress->setPosition(ccp(winSize.width/2.0f + 17.0f, 70.0f));
    if( m_pProgressParticle != NULL )
    {
        m_pProgressParticle->setPosition(ccp(-5.0f, -1.0f));
    }
}

void CGameUpdateScene::waitMutex()
{
    m_mutexObj.Lock();
    m_pidMutexOwner = getpid();
}

void CGameUpdateScene::clearMutex()
{
    m_mutexObj.Unlock();
}
