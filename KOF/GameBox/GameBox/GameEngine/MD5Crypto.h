//
//  MD5Crypto.h
//  GameBox
//
//  Created by Mac on 13-5-23.
//
//

#ifndef __GameBox__MD5Crypto__
#define __GameBox__MD5Crypto__

#include <string.h>

namespace ptola
{
    namespace io
    {
        
        class CMD5Crypto
        {
        public:
            static const char *md5(const char *lpcszSource, unsigned int uLength);
        };
    }
}

#endif /* defined(__GameBox__MD5Crypto__) */
