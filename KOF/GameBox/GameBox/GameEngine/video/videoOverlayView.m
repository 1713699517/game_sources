/*
 * CCVideoPlayer
 *
 * cocos2d-extensions
 * https://github.com/cocos2d/cocos2d-iphone-extensions
 *
 * Copyright (c) 2010-2011 Stepan Generalov
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

#import "videoOverlayView.h"

@implementation VideoOverlayView

- (id)init:(id)ptr :(id)p
{
    id ret = [super init];
    
    m_pVideoPlayer = ret;
    
    return ret;
}

- (void) setCanJump:(BOOL)value;
{
    _canJump=value;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        
        //self.alpha = 0.0f;
        self.backgroundColor = [UIColor colorWithRed:0.0f green: 0.0f blue: 0.0f alpha: 0.0f];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touch = YES;
    
    if (_canJump) {
        [CCVideoPlayer cancelPlaying];
        _canJump = false;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( _touch )
    {
        // stop video
        [CCVideoPlayer userCancelPlaying];
    }
    _touch = NO;
}


- (void)dealloc {
    [super dealloc];
}


@end

#endif
