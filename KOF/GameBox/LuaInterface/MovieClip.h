    class CMovieClip : public CUserControl
    {
    public:

        static CMovieClip *create(const char *lpcszResourceName);

        static void releaseAllResource();
        static void releaseResource(const char *lpcszResourceName);
        
        const char *getAnimationName();
        void play(const char *lpcszAnimationName, float fTweenDuration);

        void flipHorizontal();
        void flipVertical();

        const CCSize &getContentSize();
    };

