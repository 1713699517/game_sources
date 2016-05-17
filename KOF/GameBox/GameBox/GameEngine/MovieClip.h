//
//  MovieClip.h
//  GameBox
//
//  Created by Caspar on 13-5-8.
//
//

#ifndef __GameBox__MovieClip__
#define __GameBox__MovieClip__

#include "UserControl.h"
#include "MovieClipLoader.h"
#include "ptola.h"
USING_NS_CC_EXT;

namespace ptola
{
namespace gui
{

    class CMovieClip : public CUserControl
        ,public CCBAnimationManagerDelegate
        ,public CCBSelectorResolver
        ,public CCBMemberVariableAssigner
        ,public CCNodeLoaderListener
    {
    public:

        MEMORY_MANAGE_OBJECT(CMovieClip);
        
        CMovieClip();
        ~CMovieClip();

        static CMovieClip *create(const char *lpcszResourceName);

        static CMovieClip *create(const char *lpcszResourceName, CLoaderProperty *pLoader);

        static void releaseAllResource();
        static void releaseResource(std::map<std::string,std::set<std::string> >::iterator it);
        static void releaseResource(const char *lpcszResourceName);

        bool init(const char *lpcszResourceName, CLoaderProperty *pLoader);

        const char *getAnimationName();
        void play(const char *lpcszAnimationName, float fTweenDuration=0.0f);

        void flipHorizontal();
        void flipVertical();
        
        virtual bool containsPoint(CCPoint *pGLPoint);
    public:
        virtual void completedAnimationSequenceNamed(const char *name);

        virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(CCObject * pTarget, const char* pSelectorName);
        virtual SEL_CallFuncN onResolveCCBCCCallFuncSelector(CCObject * pTarget, const char* pSelectorName);
        virtual SEL_CCControlHandler onResolveCCBCCControlSelector(CCObject * pTarget, const char* pSelectorName);
        virtual bool onAssignCCBMemberVariable(CCObject* pTarget, const char* pMemberVariableName, CCNode* pNode);
        virtual bool onAssignCCBCustomProperty(CCObject* pTarget, const char* pMemberVariableName, CCBValue* pCCBValue);
        
        virtual void onNodeLoaded(CCNode * pNode, CCNodeLoader * pNodeLoader);

        const CCSize &getContentSize();
    private:
        CCSize m_tContentSize;
        CCNode *m_pAnimationNode;
        CCBAnimationManager *m_pAnimationManager;
        //std::set<std::string> m_setLoaded;

    };

}
}

#endif /* defined(__GameBox__MovieClip__) */
