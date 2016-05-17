//
//  MemoryStream.h
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#ifndef __GameBox__MemoryStream__
#define __GameBox__MemoryStream__

#include <stdio.h>
#include <stdlib.h>
#include "ptola.h"
#include "IStream.h"
#include "SharedPtr.h"

//using namespace ptola;

namespace ptola
{
namespace io
{

    class CMemoryStream : public IStream
    {
    private:
        class CMemoryStorage
        {
        public:
            CMemoryStorage();
            CMemoryStorage(size_t uCapacity);
            CMemoryStorage(const CMemoryStorage &rhs);
            ~CMemoryStorage();
            char *getData();
            bool resize(size_t newSize);
            size_t getLength();
            size_t getActuallLength();
            size_t getPosition();
            void setPosition(size_t position);
            void addPosition(int position);
        private:
            char *m_pData;
            size_t m_dataActuallyLength;
            size_t m_dataLength;
            size_t m_uPosition;
        };
    public:
        MEMORY_MANAGE_OBJECT(CMemoryStream);
        
        CMemoryStream(size_t nCapacity=256);
        CMemoryStream(const CMemoryStream &rhs);
        ~CMemoryStream();

        void operator=(const CMemoryStream &rhs);

        virtual void close();
        virtual size_t getLength();
        virtual size_t read(void *lpDst, size_t uOffset, size_t uLength );
        virtual size_t write(const void *lpSrc, size_t uOffset, size_t uLength );
        virtual size_t getPosition();
        virtual size_t seek(int offset, enumSeekOrigin origin = eSO_Current);
        virtual void *getData();
    private:
        CSharedPtr<CMemoryStorage> m_pStorage;
    };

}
}
#endif /* defined(__GameBox__MemoryStream__) */
