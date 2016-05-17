
    enum enumActionType
    {
        eAT_None
        ,eAT_FadeIn
        ,eAT_FadeOut
    };

    class CFloatLayer : public CUserControl
    {
    public:

        static CFloatLayer *create();
        virtual void show(CCNode *pParent, const CCPoint &pos, enumActionType eActionType);
        virtual void show(CCNode *pParent, float fx, float fy, enumActionType eActionType);
        
        virtual void hide(enumActionType eActionType);
    };
