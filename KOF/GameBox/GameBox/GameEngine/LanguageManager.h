//
//  LanguageManager.h
//  GameBox
//
//  Created by Caspar on 2013-5-2.
//
//

#ifndef __GameBox__LanguageManager__
#define __GameBox__LanguageManager__

#include "DataReader.h"
#include "DataWriter.h"
#include "cocos2d.h"
#include <map>

USING_NS_CC;

namespace ptola
{

namespace configuration
{

    class CLanguageManager
    {
    public:
        CLanguageManager();
        ~CLanguageManager();

        static CLanguageManager *sharedLanguageManager();

        void setLocate(ccLanguageType lang);
        ccLanguageType getLocate();

        const char *getString(const char *key);
    private:
        ccLanguageType m_Lang;
        const char *m_lpcszEmptyString;
        unsigned char *m_lpcszBuffer;
        std::map<std::string, std::string> m_mapLangData;
    };

}

}


#endif /* defined(__GameBox__LanguageManager__) */
