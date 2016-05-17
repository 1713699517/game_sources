//
//  Math.cpp
//  GameBox
//
//  Created by Caspar on 2013-6-7.
//
//

#include "PMath.h"

using namespace ptola::math;

float CMath::pointsToAngle(const cocos2d::CCPoint &pos1, const cocos2d::CCPoint &pos2)
{
    float fX = pos2.x - pos1.x;
    float fY = pos2.y - pos1.y;
    float fCos = fX / sqrtf( powf(fX, 2.0f) + powf(fY, 2.0f) );
    float angle = 180.0f / (M_PI / acosf(fCos) );
    if( fY < 0 )
    {
        angle = -angle;
    }
    else if((fY == 0.0f) && (fX < 0.0f))
    {
        angle = 180.0f;
    }
    return angle;
}

float CMath::angleToRadian(float fAngle)
{
    return fAngle * M_PI / 180.0f;
}

float CMath::radianToAngle(float fRadian)
{
    return fRadian / M_PI * 180.0f;
}