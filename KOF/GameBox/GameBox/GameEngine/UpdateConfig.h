//
//  UpdateConfig.h
//  GameBox
//
//  Created by Caspar on 2013-5-21.
//
//

#ifndef __GameBox__UpdateConfig__
#define __GameBox__UpdateConfig__

#include "cocos2d.h"
#include <iostream>
#include "misc/rapidxml.hpp"

namespace ptola
{
namespace update
{
    class CUpdateConfigComparer;

    class CUpdateConfig : public cocos2d::CCObject
    {
    public:
        CUpdateConfig();
        ~CUpdateConfig();

    public:
        bool loadFromLocal(const char *lpcszFilePath);
        bool loadFromHttp(const char *lpcszHttpPath);

        bool isLoaded();
        bool isLoadError();

        const char *getResourceUrl();
        const char *getErrorBuffer();
        void saveAs(const char *lcpszFilePath, int nLevelResource);
    protected:

    private:
        void onHttpCallback(cocos2d::CCNode *pNode, void *pData);
    private:
        rapidxml::xml_document<> m_xmlDoc;
        bool m_bLoaded;
        bool m_bLoadError;
        std::string m_strXmlData;
        std::string m_httpTmpData;
        std::string m_strErrorBuffer;
        friend class CUpdateConfigComparer;
    };

}
}

#endif /* defined(__GameBox__UpdateConfig__) */
