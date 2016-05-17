//
//  FontMetric_Android.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#include "FontMetric.h"

#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

using namespace ptola;

CCSize CFontMetric::measureTextSize(const char *lpcszString, const char *lpcszFontFamily, float fFontSize, float fLineWidth)
{
    return CCSizeZero;
}

#endif