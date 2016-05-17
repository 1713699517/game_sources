//
//  Application.h
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#ifndef __GameBox__Application__
#define __GameBox__Application__

#include "cocos2d.h"

using namespace cocos2d;

namespace ptola
{

    class CApplication
    {
    public:
        CApplication();
        ~CApplication();
        static CApplication *sharedApplication()
        {
            static CApplication app;
            return &app;
        };

        const char *getBundleVersion()
        {
            return m_strBundleVersion.c_str();
        };

        const char *getStartupPath()
        {
            return m_strStartupPath.c_str();
        };
        
        const char *getResourcePath()
        {
            return m_strResourcePath.c_str();
        };

    private:
        void reInitializeStartupPath();
        void reInitializeResourcePath();
        void reInitializeBundleVersion();
        
        std::string m_strStartupPath;
        std::string m_strResourcePath;
        std::string m_strBundleVersion;
    };

}

#endif /* defined(__GameBox__Application__) */
