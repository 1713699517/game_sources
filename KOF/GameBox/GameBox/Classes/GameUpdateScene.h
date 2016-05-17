//
//  GameUpdateScene.h
//  GameBox
//
//  Created by Caspar on 2013-5-14.
//
//

#ifndef __GameBox__GameUpdateScene__
#define __GameBox__GameUpdateScene__

#include "Event.h"
#include "cocos-ext.h"

#include "UpdateConfig.h"
#include "UpdateConfigComparer.h"
#include <set>

#include "UpdateLogView.h"
#include "MovieClip.h"

#include "../GameEngine/misc/socketcc.h"

using namespace ptola::event;
USING_NS_CC;
USING_NS_CC_EXT;
using namespace ptola::update;
using namespace ptola::gui;

class CGameUpdateScene : public CCLayer
{
public:
    CGameUpdateScene();
    virtual ~CGameUpdateScene();
    
    static CGameUpdateScene *create(int nLevelLimit);
    bool init(int nLevelLimit);

    void layout();

    static CCScene *scene(int nLevelLimit);

    void initializeFirstRun();

    void checkUpdate();
    void checkAndStartUpdate();
    void updataEndBtnCallBack(float dt);

    void onInitializedAsset(CCObject *pTarget, CEvent *pEvent);
    void onProgressAsset(CCObject *pTarget, CEvent *pEvent);
    void onCompleteAsset(CCObject *pTarget, CEvent *pEvent);

    void onInitializedFirstRun(CCObject *pTarget, CEvent *pEvent);


    void continueUpdate();
private:

    void statisticsApp();
    void onStatisticsCallBack(CCNode *pNode, void *pData);

    CUpdateLogView *pWebView;
    
    void onHttpLoading();

    void beginUpdate(bool isUpdate);
    void updateFile(const char *lpcszPathPrefix, const char *lpcszFilePath);
    void onProgressUpdate(CCNode *pNode, void *pData);
    void onUpdateComplete();

    void delayComplete(float dt);

    void waitMutex();
    void clearMutex();

    CCSprite *m_pBackground;
    CCSprite *m_pProgressTransparentBackground;
    CCScale9Sprite *m_pProgressBackground;
    CCSprite *m_pProgressProcess;
    CCSprite *m_pProgressThumb;
    CMovieClip *m_pProgressParticle;
    CCControlSlider *m_pProgress;

    CCLabelTTF *m_pProcessingLabel;
    int m_nAll;
    int m_nCurrent;
    
    //progress relative
    float m_fPercentCopyAsset;
    float m_fPercentUpdate;

    CUpdateConfig m_httpConfig;
    CUpdateConfig m_localConfig;

    CUpdateConfigComparer::CompareResult m_mapUpdateResult;
    std::set<std::string> m_setCurrentUpdateing;
    int m_nCurrentDownload;
    int m_nCurrentDownloadTotoal;

    int m_nLevelLimit;


    
    MutualExclusion m_mutexObj;
    pid_t m_pidMutexOwner;
};

#endif /* defined(__GameBox__GameUpdateScene__) */
