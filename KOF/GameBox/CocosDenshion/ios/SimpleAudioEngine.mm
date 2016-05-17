/****************************************************************************
Copyright (c) 2010 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/

#include "SimpleAudioEngine.h"
#include "SimpleAudioEngine_objc.h"
#include "cocos2d.h"
USING_NS_CC;

static void static_end()
{
    [SimpleAudioEngine  end];
}

static void static_preloadBackgroundMusic(const char* pszFilePath)
{
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic: [NSString stringWithUTF8String: pszFilePath]];
}

static void static_playBackgroundMusic(const char* pszFilePath, bool bLoop)
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic: [NSString stringWithUTF8String: pszFilePath] loop: bLoop];
}

static void static_stopBackgroundMusic()
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

static void static_pauseBackgroundMusic()
{
     [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

static void static_resumeBackgroundMusic()
{
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
} 

static void static_rewindBackgroundMusic()
{
    [[SimpleAudioEngine sharedEngine] rewindBackgroundMusic];
}

static bool static_willPlayBackgroundMusic()
{
    return [[SimpleAudioEngine sharedEngine] willPlayBackgroundMusic];
}

static bool static_isBackgroundMusicPlaying()
{
    return [[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying];
}

static float static_getBackgroundMusicVolume()
{
    return [[SimpleAudioEngine sharedEngine] backgroundMusicVolume];
}

static void static_setBackgroundMusicVolume(float volume)
{
    volume = MAX( MIN(volume, 1.0), 0 );
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = volume;
}
     
static float static_getEffectsVolume()
{
    return [[SimpleAudioEngine sharedEngine] effectsVolume];
}
     
static void static_setEffectsVolume(float volume)
{
    volume = MAX( MIN(volume, 1.0), 0 );
    [SimpleAudioEngine sharedEngine].effectsVolume = volume;
}
     
static unsigned int static_playEffect(const char* pszFilePath, bool bLoop)
{
    return [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithUTF8String: pszFilePath] loop:bLoop]; 
}
     
static void static_stopEffect(int nSoundId)
{
    [[SimpleAudioEngine sharedEngine] stopEffect: nSoundId];
}
     
static void static_preloadEffect(const char* pszFilePath)
{
    [[SimpleAudioEngine sharedEngine] preloadEffect: [NSString stringWithUTF8String: pszFilePath]];
}
     
static void static_unloadEffect(const char* pszFilePath)
{
    [[SimpleAudioEngine sharedEngine] unloadEffect: [NSString stringWithUTF8String: pszFilePath]];
}

static void static_pauseEffect(unsigned int uSoundId)
{
    [[SimpleAudioEngine sharedEngine] pauseEffect: uSoundId];
}

static void static_pauseAllEffects()
{
    [[SimpleAudioEngine sharedEngine] pauseAllEffects];
}

static void static_resumeEffect(unsigned int uSoundId)
{
    [[SimpleAudioEngine sharedEngine] resumeEffect: uSoundId];
}

static void static_resumeAllEffects()
{
    [[SimpleAudioEngine sharedEngine] resumeAllEffects];
}

static void static_stopAllEffects()
{
    [[SimpleAudioEngine sharedEngine] stopAllEffects];
}

namespace CocosDenshion {

static SimpleAudioEngine *s_pEngine;

SimpleAudioEngine::SimpleAudioEngine()
{

}

SimpleAudioEngine::~SimpleAudioEngine()
{

}

SimpleAudioEngine* SimpleAudioEngine::sharedEngine()
{
    if (! s_pEngine)
    {
        s_pEngine = new SimpleAudioEngine();
    }
    
    return s_pEngine;
}

void SimpleAudioEngine::end()
{
    if (s_pEngine)
    {
        delete s_pEngine;
        s_pEngine = NULL;
    }
    
    static_end();
}

void SimpleAudioEngine::preloadBackgroundMusic(const char* pszFilePath)
{
    // Changing file path to full path
    std::string fullPath = CCFileUtils::sharedFileUtils()->fullPathForFilename(pszFilePath);

#ifdef SOUND_ON
    static_preloadBackgroundMusic(fullPath.c_str());
#endif
}

void SimpleAudioEngine::playBackgroundMusic(const char* pszFilePath, bool bLoop)
{
    // Changing file path to full path
    std::string fullPath = CCFileUtils::sharedFileUtils()->fullPathForFilename(pszFilePath);
#ifdef SOUND_ON
    static_playBackgroundMusic(fullPath.c_str(), bLoop);
#endif
}

void SimpleAudioEngine::stopBackgroundMusic(bool bReleaseData)
{
#ifdef SOUND_ON
    static_stopBackgroundMusic();
#endif
}

void SimpleAudioEngine::pauseBackgroundMusic()
{
#ifdef SOUND_ON
    static_pauseBackgroundMusic();
#endif
}

void SimpleAudioEngine::resumeBackgroundMusic()
{
#ifdef SOUND_ON
    static_resumeBackgroundMusic();
#endif
} 

void SimpleAudioEngine::rewindBackgroundMusic()
{
#ifdef SOUND_ON
        static_rewindBackgroundMusic();
#endif
}

bool SimpleAudioEngine::willPlayBackgroundMusic()
{
    return static_willPlayBackgroundMusic();
}

bool SimpleAudioEngine::isBackgroundMusicPlaying()
{
    return static_isBackgroundMusicPlaying();
}

float SimpleAudioEngine::getBackgroundMusicVolume()
{
    return static_getBackgroundMusicVolume();
}

void SimpleAudioEngine::setBackgroundMusicVolume(float volume)
{
#ifdef SOUND_ON
    static_setBackgroundMusicVolume(volume);
#endif
}

float SimpleAudioEngine::getEffectsVolume()
{
    return static_getEffectsVolume();
}

void SimpleAudioEngine::setEffectsVolume(float volume)
{
#ifdef SOUND_ON
    static_setEffectsVolume(volume);
#endif
}

unsigned int SimpleAudioEngine::playEffect(const char* pszFilePath, bool bLoop)
{
    // Changing file path to full path
    std::string fullPath = CCFileUtils::sharedFileUtils()->fullPathForFilename(pszFilePath);
    if( m_loadedEffects.find(fullPath) == m_loadedEffects.end() )
    {
        m_loadedEffects.insert(fullPath);
    }
    int nRet = CD_MUTE;
#ifdef SOUND_ON
    nRet = static_playEffect(fullPath.c_str(), bLoop);
#endif
    return nRet;
}

void SimpleAudioEngine::stopEffect(unsigned int nSoundId)
{
#ifdef SOUND_ON
    static_stopEffect(nSoundId);
#endif
}

void SimpleAudioEngine::preloadEffect(const char* pszFilePath)
{
    // Changing file path to full path

#ifdef SOUND_ON
    std::string fullPath = CCFileUtils::sharedFileUtils()->fullPathForFilename(pszFilePath);
    if( m_loadedEffects.find(fullPath) == m_loadedEffects.end() )
    {
        m_loadedEffects.insert(fullPath);
    }
    static_preloadEffect(fullPath.c_str());
#endif
}

void SimpleAudioEngine::unloadEffect(const char* pszFilePath)
{

#ifdef SOUND_ON
    // Changing file path to full path
    std::string fullPath = CCFileUtils::sharedFileUtils()->fullPathForFilename(pszFilePath);
    static_unloadEffect(fullPath.c_str());
    std::set<std::string>::iterator it = m_loadedEffects.find(fullPath);
    if( it != m_loadedEffects.end() )
    {
        m_loadedEffects.erase(it);
    }
#endif
}

void SimpleAudioEngine::pauseEffect(unsigned int uSoundId)
{
#ifdef SOUND_ON
    static_pauseEffect(uSoundId);
#endif
}

void SimpleAudioEngine::resumeEffect(unsigned int uSoundId)
{
#ifdef SOUND_ON
    static_resumeEffect(uSoundId);
#endif
}

void SimpleAudioEngine::pauseAllEffects()
{
#ifdef SOUND_ON
    static_pauseAllEffects();
#endif
}

void SimpleAudioEngine::resumeAllEffects()
{
#ifdef SOUND_ON
    static_resumeAllEffects();
#endif
}

void SimpleAudioEngine::stopAllEffects()
{

#ifdef SOUND_ON
    static_stopAllEffects();
#endif
}

void SimpleAudioEngine::unloadAllEffects()
{

#ifdef SOUND_ON
    for( std::set<std::string>::iterator it = m_loadedEffects.begin();
        it != m_loadedEffects.end(); it++ )
    {
        static_unloadEffect( (*it).c_str() );
    }
    m_loadedEffects.clear();
#endif
}

} // endof namespace CocosDenshion {
