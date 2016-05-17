//
//  Math.h
//  GameBox
//
//  Created by Caspar on 2013-6-7.
//
//

#ifndef __GameBox__Math__
#define __GameBox__Math__

#include <math.h>
#include "cocos2d.h"

USING_NS_CC;

namespace ptola
{
namespace math
{

    class CMath
    {
    public:
        static float pointsToAngle(const CCPoint &pos1, const CCPoint &pos2);
        static float angleToRadian(float fAngle);
        static float radianToAngle(float fRadian);
    };

}
}
#endif /* defined(__GameBox__Math__) */
