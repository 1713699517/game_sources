
    enum enumJoyStickTouchMode
    {
         eJSTM_HalfScreenTouchPoint = 0
        ,eJSTM_Fixed
    };

    class CJoyStick : public CUserControl
    {
    public:

        static CJoyStick *create(const char *lpcszBackground, const char *lpcszStick, const char *lpcszCirclePeace);

        static CJoyStick *create(CCSprite *pBackground, CCSprite *pStick, const char *lpcszCirclePeace);

        virtual void setFireInterval(float _fireInterval);
        
        virtual float getFireInterval();

        virtual void setMaxRadius(float _maxRadius);
        
        virtual float getMaxRadius();

        virtual void setMaxStickRadius(float _maxRadius);
        
        virtual float getMaxStickRadius();

        virtual void setAutoHide(bool _bAutoHide);
        
        virtual bool getAutoHide();

        virtual enumJoyStickTouchMode getFireMode();
        
        virtual void setFireMode(enumJoyStickTouchMode eValue);

        virtual void setFirePosition(const CCPoint &pos);
        
        virtual const CCPoint &getFirePosition();

    };
