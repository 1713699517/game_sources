//
//  Joystick.h
//  GameBox
//
//  Created by Caspar on 2013-6-7.
//
//

#ifndef __GameBox__Joystick__
#define __GameBox__Joystick__

#include "Sprite.h"
USING_NS_CC;
using namespace ptola::gui;

#define JOYSTICK_DIRECTION_COUNT 8      //方向

namespace ptola
{
namespace input
{
    enum enumJoyStickTouchMode
    {
         eJSTM_HalfScreenTouchPoint = 0
        ,eJSTM_Fixed
    };

    class CJoyStick : public CUserControl
    {
    public:
        CJoyStick();
        ~CJoyStick();

        static CJoyStick *create(const char *lpcszBackground, const char *lpcszStick, const char *lpcszCirclePeace);
        bool init(const char *lpcszBackground, const char *lpcszStick, const char *lpcszCirclePeace);

        static CJoyStick *create(CSprite *pBackground, CSprite *pStick, const char *lpcszCirclePeace);
        bool init(CSprite *pBackground, CSprite *pStick, const char *lpcszCirclePeace);

        //seconds
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

        virtual void onEnter();

        virtual void ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent);
        virtual void ccTouchesMoved(CCSet *pTouches, CCEvent *pEvent);
        virtual void ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent);
        virtual void ccTouchesCancelled(CCSet *pTouches, CCEvent *pEvent);
    private:
        void fireCallback(float dt);

        float m_fFireInterval;
        float m_fMaxRadius;
        float m_fMaxDisplayRadius;
        bool m_bAutoHide;
        enumJoyStickTouchMode m_exTouchMode;
        CCPoint m_cpFirePosition;
        float m_preAngle;

        CSprite *m_pBackground;
        CSprite *m_pStick;

        int m_nTouchId;
        int m_highLightLastIndex;

        CSprite *m_pLightupDirection[JOYSTICK_DIRECTION_COUNT];
    };

}
}

#endif /* defined(__GameBox__Joystick__) */
