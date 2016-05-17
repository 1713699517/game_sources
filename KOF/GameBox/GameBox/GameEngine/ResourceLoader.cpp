//
//  ResourceLoader.cpp
//  GameBox
//
//  Created by Caspar on 2013-5-16.
//
//

#include "ConfigurationManager.h"
#include "ResourceLoader.h"
#include "cocos-ext.h"

using namespace std;
using namespace ptola::resources;
using namespace ptola::configuration;
USING_NS_CC;
USING_NS_CC_EXT;

CResourceLoader *CResourceLoader::sharedResourceLoader()
{
    static CResourceLoader theResourceLoader;
    return &theResourceLoader;
}

CResourceLoader::CResourceLoader()
: m_bLoading(false)
, m_needToBeLoadCount(0U)
{
    m_setLoadFiles.clear();
    m_setLoadedFiles.clear();
}

CResourceLoader::~CResourceLoader()
{
    
}

bool CResourceLoader::isLoading()
{
    return m_bLoading;
}

void CResourceLoader::appendFile(const char *lpcszFile)
{
    m_setLoadFiles.insert( lpcszFile );
}

void CResourceLoader::startLoad()
{
    m_setLoadedFiles.clear();
    if( m_setLoadFiles.empty() )
    {
        onLoaded();
        return;
    }
    m_needToBeLoadCount = m_setLoadFiles.size();
    //start load
    m_bLoading = true;
    
    CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(CResourceLoader::mainThreadProcess), this, 0.0f, false);
}

void CResourceLoader::onLoaded()
{
    m_setLoadFiles.clear();
    m_setLoadedFiles.clear();
    m_bLoading = false;
}

void CResourceLoader::mainThreadProcess(float dt)
{
    if( !m_setLoadFiles.empty() )
    {
        string file = *m_setLoadFiles.begin();
        const char *lpcszFile = file.c_str();
        char *lpPos = strstr(lpcszFile, ".");
        char *lpExt = NULL;
        while( lpPos != NULL )
        {
            lpExt = lpPos;
            lpPos = strstr( lpPos + 1, ".");
        }

        if( lpExt == NULL )     //no extension
        {

        }
        else if(
               strcasecmp(lpExt, ".jpg") == 0
            || strcasecmp(lpExt, ".png") == 0
            || strcasecmp(lpExt, ".gif") == 0
            || strcasecmp(lpExt, ".bmp") == 0
                )
        {
            CCTextureCache::sharedTextureCache()->addImage(lpcszFile);
        }
        else if(
               strcasecmp(lpExt, ".pvr") == 0
            || strcasecmp(lpExt, ".czz") == 0
                )
        {
            CCTextureCache::sharedTextureCache()->addPVRImage(lpcszFile);
        }
        else if( strcasecmp(lpExt, ".plist") == 0 )
        {
            CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile(lpcszFile);
            CCAnimationCache::sharedAnimationCache()->addAnimationsWithFile(lpcszFile);
        }
        else if( strcasecmp(lpExt, ".ccbi") == 0 )
        {
            //read ccbi
            CCBReader reader(CCNodeLoaderLibrary::sharedCCNodeLoaderLibrary());
            CCNode *pTmpNode = reader.readNodeGraphFromFile(lpcszFile);
            CC_SAFE_DELETE(pTmpNode);
        }
        else if( strcasecmp(lpExt, ".xml") == 0 )
        {
            CConfigurationCache::sharedConfigurationCache()->load(lpcszFile);
            //CConfigurationManager::sharedConfigurationManager()->load(lpcszFile);
        }
        //
        m_setLoadFiles.erase( file );
        m_setLoadedFiles.insert(file);
        

        if( hasEventListener(EVENT_NAME_RESOURCE_LOADER_PROGRESS) )
        {
            CProgressEvent evt(this, m_setLoadedFiles.size(), m_needToBeLoadCount );
            dispatchEvent(this, &evt);
        }
        if( hasLuaEventListener(EVENT_NAME_RESOURCE_LOADER_PROGRESS) )
        {
            SLuaEventArg Loaded((float)m_setLoadedFiles.size());
            SLuaEventArg Total((float)m_needToBeLoadCount);
            dispatchLuaEvent(EVENT_NAME_RESOURCE_LOADER_PROGRESS, &Loaded, &Total, NULL);
        }
    }
    else
    {
        //
        if( hasEventListener(EVENT_NAME_RESOURCE_LOADER_LOADCOMPLETE))
        {
            CEvent evt(EVENT_NAME_RESOURCE_LOADER_LOADCOMPLETE, this, NULL);
            dispatchEvent(this, &evt);
        }
        if( hasLuaEventListener(EVENT_NAME_RESOURCE_LOADER_LOADCOMPLETE))
        {
            dispatchLuaEvent(EVENT_NAME_RESOURCE_LOADER_LOADCOMPLETE, NULL);
        }
        onLoaded();
        CCDirector::sharedDirector()->getScheduler()->unscheduleSelector(schedule_selector(CResourceLoader::mainThreadProcess), this);
    }
}

//void CResourceLoader::CleanUp()
//{
//    onLoaded();
//}

void CResourceLoader::clearUnusedResources()
{
    CCSpriteFrameCache::sharedSpriteFrameCache()->removeUnusedSpriteFrames();
    CCTextureCache::sharedTextureCache()->removeUnusedTextures();
}










void CResourceLoader::addEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector)
{
    m_eventDispatcher.addEventListener(lpcszEventName, pTarget, selector);
}

void CResourceLoader::removeEventListener(const char *lpcszEventName, CCObject *pTarget, SEL_PtolaEventHandler selector)
{
    m_eventDispatcher.removeEventListener(lpcszEventName, pTarget, selector);
}

void CResourceLoader::removeAllEventListener()
{
    m_eventDispatcher.removeAllEventListener();
}

void CResourceLoader::dispatchEvent(CCObject *pSender, CEvent *pEvent)
{
    m_eventDispatcher.dispatchEvent(pSender, pEvent);
}

bool CResourceLoader::hasEventListener(const char *lpcszEventName)
{
    return m_eventDispatcher.hasEventListener(lpcszEventName);
}

void CResourceLoader::addLuaEventListener(const char *lpcszEventName, int selector)
{
    m_luaEventDispatcher.addEventListener(lpcszEventName, selector);
}

void CResourceLoader::removeLuaEventListener(const char *lpcszEventName, int selector)
{
    m_luaEventDispatcher.removeEventListener(lpcszEventName, selector);
}

void CResourceLoader::removeLuaAllEventListener()
{
    m_luaEventDispatcher.removeAllEventListener();
}

bool CResourceLoader::hasLuaEventListener(const char *lpcszEventName)
{
    return m_luaEventDispatcher.hasEventListener(lpcszEventName);
}

void CResourceLoader::dispatchLuaEvent(const char *lpcszEventName, ...)
{
    std::vector<SLuaEventArg *> vecArgs;
    va_list args;
    va_start(args, lpcszEventName);
    SLuaEventArg *i = va_arg(args, SLuaEventArg*);
    while(i != NULL)
    {
        vecArgs.push_back(i);
        i = va_arg(args, SLuaEventArg*);
    }
    va_end(args);
    m_luaEventDispatcher.dispatchEvent(lpcszEventName, &vecArgs);
}

void CResourceLoader::dispatchLuaEvent(const char *lpcszEventName, std::vector<SLuaEventArg *> *args)
{
    m_luaEventDispatcher.dispatchEvent(lpcszEventName, args);
}

void CResourceLoader::dispatchLuaEvent(const char *lpcszEventName, int nLuaTable)
{
    m_luaEventDispatcher.dispatchEvent(lpcszEventName, nLuaTable);
}

void CResourceLoader::removeEventListeners(const char *lpcszEventName)
{
    m_eventDispatcher.removeEventListeners(lpcszEventName);
}

void CResourceLoader::removeLuaEventListeners(const char *lpcszEventName)
{
    m_luaEventDispatcher.removeEventListeners(lpcszEventName);
}
