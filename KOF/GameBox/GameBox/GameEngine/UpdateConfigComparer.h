//
//  UpdateConfigComparer.h
//  GameBox
//
//  Created by Caspar on 2013-5-21.
//
//

#ifndef __GameBox__UpdateConfigComparer__
#define __GameBox__UpdateConfigComparer__

#include "UpdateConfig.h"
#include <map>

namespace ptola
{
namespace update
{


    class CUpdateConfigComparer
    {
    public:
        enum enumUpdateMethod
        {
            eUM_Add,eUM_Update,eUM_Delete
        };
        typedef std::map<std::string, enumUpdateMethod> CompareResult;
    public:
        static bool compare(const CUpdateConfig &local, const CUpdateConfig &http, CompareResult &Output, size_t *pOutputSize);
    };

}
}


#endif /* defined(__GameBox__UpdateConfigComparer__) */
