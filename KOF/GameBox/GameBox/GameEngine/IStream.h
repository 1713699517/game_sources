//
//  IStream.h
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#ifndef GameBox_IStream_h
#define GameBox_IStream_h

#include <stdio.h>

namespace ptola
{
namespace io
{

    enum enumSeekOrigin
    {
         eSO_Begin = 0
        ,eSO_Current = 1
        ,eSO_End = 2
    };

    class IStream
    {
    public:
        virtual size_t getLength() = 0;
        virtual size_t read(void *lpDst, size_t uOffset, size_t uLength ) = 0;
        virtual size_t write(const void *lpSrc, size_t uOffset, size_t uLength ) = 0;
        virtual size_t getPosition() = 0;
        virtual size_t seek(int offset, enumSeekOrigin origin = eSO_Current) = 0;
        virtual void close() = 0;

        virtual void *getData() = 0;
    };

}
}

#endif
