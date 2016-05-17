//
//  SharedPtr.h
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#ifndef __GameBox__SharedPtr__
#define __GameBox__SharedPtr__

#include <assert.h>

namespace ptola
{
    template< typename T >
    class CSharedPtr
    {
    public:
        CSharedPtr( T *ptr )
        : m_ptrData(ptr)
        , m_pnReferenceCount(new int(1))
        {

        };
        ~CSharedPtr()
        {
            if( m_ptrData == NULL || (*m_pnReferenceCount) == 0 )
            {
                assert("reference count error~");
            }
            if( (--(*m_pnReferenceCount)) == 0 )
            {
                delete m_ptrData;
                delete m_pnReferenceCount;
                m_ptrData = NULL;
                m_pnReferenceCount = NULL;
            }
        };
        CSharedPtr( const CSharedPtr<T> &rhs )
        {
            m_ptrData = rhs.m_ptrData;
            m_pnReferenceCount = rhs.m_pnReferenceCount;
            if( m_pnReferenceCount != NULL )
            {
                (*m_pnReferenceCount)++;
            }
        };

        void operator=( const CSharedPtr<T> &rhs )
        {
            if( m_ptrData != NULL && (--(*m_pnReferenceCount)) == 0 )
            {
                delete m_ptrData;
                delete m_pnReferenceCount;
            }
            m_ptrData = rhs.m_ptrData;
            m_pnReferenceCount = rhs.m_pnReferenceCount;
            if( m_pnReferenceCount != NULL )
            {
                (*m_pnReferenceCount)++;
            }
        };

        T *operator->()
        {
            return m_ptrData;
        };

        T &operator*()
        {
            return *m_ptrData;
        };

        bool operator!()
        {
            return !m_ptrData;
        };

        T *getOriginPtr()
        {
            return m_ptrData;
        };

        bool operator==( const CSharedPtr<T> &rhs )
        {
            return m_ptrData == rhs.m_ptrData;
        };

        bool operator!=( const CSharedPtr<T> &rhs )
        {
            return m_ptrData != rhs.m_ptrData;
        };
    private:
        T *m_ptrData;
        int *m_pnReferenceCount;
    };


}

#endif /* defined(__GameBox__SharedPtr__) */
