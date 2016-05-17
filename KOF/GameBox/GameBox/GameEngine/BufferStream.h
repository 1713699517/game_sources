//
//  BufferStream.h
//  GameBox
//
//  Created by Caspar on 2013-4-26.
//
//

#ifndef __GameBox__BufferStream__
#define __GameBox__BufferStream__

#include <stdio.h>
#include <stdlib.h>
#include "IStream.h"
#include "SharedPtr.h"
#include <string.h>

namespace ptola
{
namespace io
{

    template< size_t BUFFER_SIZE >
    class CBufferStream : public IStream
    {
    public:
        CBufferStream()
        : m_uPosition(0)
        {
            memset( m_szBuffer, 0, BUFFER_SIZE );
        };
        CBufferStream(const CBufferStream &rhs)
        : m_uPosition(rhs.m_szBuffer)
        {
            memcpy( m_szBuffer, rhs.m_szBuffer, BUFFER_SIZE );
        };
        ~CBufferStream()
        {

        };

        void operator=(const CBufferStream &rhs)
        {
            m_uPosition = rhs.m_uPosition;
            memcpy( m_szBuffer, rhs.m_szBuffer, BUFFER_SIZE);
        };

        virtual void close(){};
        virtual size_t getLength(){ return BUFFER_SIZE; };
        virtual size_t read(void *lpDst, size_t uOffset, size_t uLength )
        {
            if( m_uPosition + uLength > BUFFER_SIZE )
            {
                assert("memory out of range");
            }
            void *lpDstPos = (void *)((char *)lpDst + uOffset);
            void *lpSrcPos = (void *)(m_szBuffer + m_uPosition);
            memcpy(lpDstPos, lpSrcPos, uLength);
            m_uPosition += uLength;
            return uLength;
        };
        virtual size_t write(const void *lpSrc, size_t uOffset, size_t uLength )
        {
            if( uOffset >= uLength )
            {
                assert("length must greater than offset!");
            }
            if( m_uPosition + uLength - uOffset >= BUFFER_SIZE )
            {
                assert("memory out of range");
            }
            void *lpSrcPos = (void *)((char *)lpSrc + uOffset);
            void *lpDstPos = (void *)((char *)m_szBuffer + m_uPosition);
            memcpy( lpDstPos, lpSrcPos, uLength - uOffset);
            m_uPosition += uLength - uOffset;
            return uLength - uOffset;
        };
        virtual size_t getPosition(){ return m_uPosition; };
        virtual size_t seek(int offset, enumSeekOrigin origin = eSO_Current)
        {
            switch( origin )
            {
                case eSO_Begin:
                    if( offset < 0 )
                        offset = 0;
                    if( offset > BUFFER_SIZE )
                        offset = BUFFER_SIZE;
                    m_uPosition = offset;
                    break;
                case eSO_Current:
                    if( (int)m_uPosition + offset < 0 )
                        m_uPosition = 0;
                    else if( m_uPosition + offset > BUFFER_SIZE )
                        m_uPosition = BUFFER_SIZE;
                    else
                        m_uPosition += offset;
                    break;
                case eSO_End:
                    if( offset < 0 )
                        offset = 0;
                    if( offset > BUFFER_SIZE )
                        offset = BUFFER_SIZE;
                    m_uPosition = BUFFER_SIZE - offset;
                    break;
            }
            return m_uPosition;
        };
        virtual void *getData(){ return m_szBuffer; };
    private:
        size_t m_uPosition;
        char m_szBuffer[BUFFER_SIZE];
    };

}
}
#endif /* defined(__GameBox__BufferStream__) */
