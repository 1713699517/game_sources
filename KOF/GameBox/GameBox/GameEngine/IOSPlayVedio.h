//
//  IOSPlayVedio.h
//  VedioTest
//
//  Created by Himi on 12-10-10.
//
//

#ifndef __VedioTest__IOSPlayVedio__
#define __VedioTest__IOSPlayVedio__

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

class IOSPlayVedio{
public:
    static void playVedio4iOS(char *name);
    static bool isPlaying();
    static void cancelPlaying();
};
#endif
#endif /* defined(__VedioTest__IOSPlayVedio__) */
