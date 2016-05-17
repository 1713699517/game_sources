//
//  Platform.h
//  VedioTest
//
//  Created by Himi on 12-10-9.
//
//

#ifndef __VedioTest__Platform__
#define __VedioTest__Platform__

#include "cocos2d.h"
using namespace cocos2d;

class VideoPlatform {
public:
    static void playVedio(char *name);
    static bool isPlaying();
    static void cancelPlaying();
};

#endif
