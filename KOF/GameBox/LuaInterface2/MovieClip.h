class CMovieClip : public CUserControl,public CCBAnimationManagerDelegate,public CCBSelectorResolver,public CCBMemberVariableAssigner,public CCNodeLoaderListener
{
public:
    static CMovieClip *create(const char *lpcszResourceName);
    
    static void releaseAllResource();
    
    static void releaseResource(const char *lpcszResourceName);
    
    const char *getAnimationName();
    
    void play(const char *lpcszAnimationName,float fTweenDuration=0.0);
        
    void flipHorizontal();
    
    void flipVertical();
    
    const CCSize &getContentSize();
    
};
