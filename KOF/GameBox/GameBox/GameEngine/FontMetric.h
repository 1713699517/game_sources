//
//  FontMetric.h
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#ifndef __GameBox__FontMetric__
#define __GameBox__FontMetric__

#include "cocos2d.h"

USING_NS_CC;

namespace ptola
{

    class CFontMetric
    {
    public:
        static CCSize measureTextSize(const char *lpcszString, const char *lpcszFontFamily, float fFontSize, float fLineWidth);
    };

}



#endif /* defined(__GameBox__FontMetric__) */
