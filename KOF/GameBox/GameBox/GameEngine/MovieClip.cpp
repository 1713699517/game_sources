//
//  MovieClip.cpp
//  GameBox
//
//  Created by Caspar on 13-5-8.
//
//

#include "MovieClip.h"
#include "LuaScriptFunctionInvoker.h"

#include "MemoryAllocator.h"

using namespace ptola::gui;
using namespace ptola::memory;

static std::map<std::string, std::set<std::string> > s_mapMovieClipResources;

MEMORY_MANAGE_OBJECT_IMPL(CMovieClip);

CMovieClip::CMovieClip()
: m_pAnimationNode(NULL)
, m_pAnimationManager(NULL)
{

}

CMovieClip::~CMovieClip()
{
    if( m_pAnimationNode != NULL )
    {
        removeChild(m_pAnimationNode, true);
        m_pAnimationNode = NULL;
    }

    //Caspar 2013-7-26 modify by fix setDelegate() to MovieClip
//    for( set<string>::iterator it = m_setLoaded.begin(); it != m_setLoaded.end(); it++ )
//    {
//        CCSpriteFrameCache::sharedSpriteFrameCache()->removeSpriteFramesFromFile(it->c_str());
//    }
}

CMovieClip *CMovieClip::create(const char *lpcszResourceName)
{
    return create(lpcszResourceName, NULL);
}

CMovieClip *CMovieClip::create(const char *lpcszResourceName, CLoaderProperty *pLoader)
{
    CMovieClip *pRet = new CMovieClip;
    if( pRet != NULL && pRet->init(lpcszResourceName, pLoader) )
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

void CMovieClip::releaseAllResource()
{
    for( std::map<std::string, std::set<std::string> >::iterator it = s_mapMovieClipResources.begin(); it != s_mapMovieClipResources.end(); )
    {
        releaseResource( it++ );
    }
    s_mapMovieClipResources.clear();
}

void CMovieClip::releaseResource(std::map<std::string, std::set<std::string> >::iterator it)
{
    releaseResource(it->first.c_str());
}

void CMovieClip::releaseResource(const char *lpcszResourceName)
{
    std::map<std::string,std::set<std::string> >::iterator it = s_mapMovieClipResources.find(lpcszResourceName);
    if( it == s_mapMovieClipResources.end() )
        return;
    for( std::set<std::string>::iterator it2 = it->second.begin();
        it2 != it->second.end(); it2++ )
    {

        //真正清除资源
        const char *lpcszUrl = (*it2).c_str();
        
        std::string fullPath = CCFileUtils::sharedFileUtils()->fullPathForFilename(lpcszUrl);
        CCDictionary *dict = CCDictionary::createWithContentsOfFileThreadSafe(fullPath.c_str());
        if( dict != NULL )
        {
            CCDictionary* framesDict = (CCDictionary*)dict->objectForKey("frames");

            CCDictElement* pElement = NULL;
            CCDICT_FOREACH(framesDict, pElement)
            {
                CCSpriteFrame *pFrame = CCSpriteFrameCache::sharedSpriteFrameCache()->spriteFrameByName(pElement->getStrKey());
                if( pFrame != NULL )
                {
                    while( pFrame->retainCount() > 1 )
                    {
                        CC_SAFE_RELEASE(pFrame);
                    }
                }
            }
            dict->release();
        }
        CCSpriteFrameCache::sharedSpriteFrameCache()->removeSpriteFramesFromFile(lpcszUrl);
    }
}

bool CMovieClip::init(const char *lpcszResourceName, CLoaderProperty *pLoader)
{
    if( !CUserControl::init() )
        return onInitialized(false);
    //read ccbi
    CCNodeLoaderLibrary *pSharedLib = CCNodeLoaderLibrary::sharedCCNodeLoaderLibrary();
    if( pLoader != NULL )
    {
        if( pSharedLib->getCCNodeLoader(pLoader->getClassName()) == NULL )
        {
            pSharedLib->registerCCNodeLoader(pLoader->getClassName(), pLoader);
        }
    }
    CCBReader reader(pSharedLib);
//    m_pAnimationManager = NULL;
    m_pAnimationNode = reader.readNodeGraphFromFile(lpcszResourceName, this);
    if( m_pAnimationNode == NULL )
        return onInitialized(false);

    std::map<std::string,std::set<std::string> >::iterator it = s_mapMovieClipResources.find(lpcszResourceName);
    if( it == s_mapMovieClipResources.end() )
    {
        s_mapMovieClipResources[ lpcszResourceName ] = reader.getLoadedSpriteSheet();
    }
    
    setAnchorPoint(ccp(0.5f,0.5f));
    
    m_pAnimationManager = dynamic_cast<CCBAnimationManager *>(m_pAnimationNode->getUserObject());
    m_pAnimationManager->setDelegate(this);
    //Caspar 2013-7-26 modify by fix setDelegate() to MovieClip
    CC_SAFE_RELEASE(this);
    addChild(m_pAnimationNode);
    return onInitialized(true);
}

const char *CMovieClip::getAnimationName()
{
    return m_pAnimationManager->getRunningSequenceName();
}

void CMovieClip::play(const char *lpcszAnimationName, float fTweenDuration)
{
    CCArray *pArray = m_pAnimationManager->getSequences();
    CCObject *pArrayElement = NULL;
    bool bFound = false;
    CCARRAY_FOREACH(pArray, pArrayElement)
    {
        CCBSequence *pSequence = dynamic_cast<CCBSequence *>(pArrayElement);
        if( pSequence == NULL )
            continue;
        if( strcmp(pSequence->getName(), lpcszAnimationName) == 0 )
        {
            bFound = true;
            break;
        }
    }
    if( !bFound )
    {
        char szMessageLog[1024] = {0};
        sprintf(szMessageLog, "%s AnimationName not found", lpcszAnimationName);
        CCMessageBox(szMessageLog,"ERROR");
        return;
    }
    m_pAnimationManager->runAnimationsForSequenceNamedTweenDuration(lpcszAnimationName, fTweenDuration);
}


void CMovieClip::completedAnimationSequenceNamed(const char *name)
{
    CLuaScriptFunctionInvoker::executeAnimationCompleteScript(m_pControlScriptHandler, name);
}

SEL_MenuHandler CMovieClip::onResolveCCBCCMenuItemSelector(CCObject * pTarget, const char* pSelectorName)
{
    return NULL;
}

SEL_CallFuncN CMovieClip::onResolveCCBCCCallFuncSelector(CCObject * pTarget, const char* pSelectorName)
{
    return NULL;
}

SEL_CCControlHandler CMovieClip::onResolveCCBCCControlSelector(CCObject * pTarget, const char* pSelectorName)
{
    return NULL;
}

bool CMovieClip::onAssignCCBMemberVariable(CCObject* pTarget, const char* pMemberVariableName, CCNode* pNode)
{
    return false;
}

bool CMovieClip::onAssignCCBCustomProperty(CCObject* pTarget, const char* pMemberVariableName, CCBValue* pCCBValue)
{
    return false;
}

void CMovieClip::onNodeLoaded(CCNode * pNode, CCNodeLoader * pNodeLoader)
{
    CLuaScriptFunctionInvoker::executeLoadScript(m_pControlScriptHandler, pNode);
}

void CMovieClip::flipHorizontal()
{
    setScaleX(0.0f - getScaleX());
}

void CMovieClip::flipVertical()
{
    setScaleY(0.0f - getScaleY());
}

void __recurrence_get_size( CCNode *pNode, CCSize *pSize )
{
    if( pNode == NULL )
        return;
    CCArray *pChildren = pNode->getChildren();
    CCObject *pChildObject = NULL;
    CCARRAY_FOREACH(pChildren, pChildObject)
    {
        CCNode *pChild = dynamic_cast<CCNode *>(pChildObject);
        if( pChild != NULL && pChild->isVisible() )
        {
            float fx,fy;
            pChild->getPosition(&fx, &fy);
            float fw = pChild->getContentSize().width;
            float fh = pChild->getContentSize().height;
            if( pSize->width < fx + fw )
                pSize->width = fx + fw;
            if( pSize->height < fy + fh )
                pSize->height = fy + fh;
            __recurrence_get_size( pChild, pSize );
        }
    }
}

const CCSize &CMovieClip::getContentSize()
{
    m_tContentSize.setSize(0.0f, 0.0f);
    __recurrence_get_size( m_pAnimationNode, &m_tContentSize );
    return m_tContentSize;
}

bool CMovieClip::containsPoint(CCPoint *pGLPoint)
{
    CCSize size = m_tContentSize;
    if( m_tContentSize.width == 0.0f && m_tContentSize.height == 0.0f )
    {
        size = getContentSize();
    }
    CCPoint anchorPoint = getAnchorPoint();
    CCRect temp = CCRectMake(-size.width*anchorPoint.x,-size.height*anchorPoint.y,size.width,size.height);
    bool ret = temp.containsPoint(*pGLPoint);
    return ret;
}

