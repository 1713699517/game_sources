//
//  MemoryStream.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#include "BufferStream.h"
#include "MemoryAllocator.h"
#include "MemoryStream.h"
#include <string.h>

using namespace ptola::io;
using namespace ptola::memory;

MEMORY_MANAGE_OBJECT_IMPL(CMemoryStream);

CMemoryStream::CMemoryStorage::CMemoryStorage()
: m_pData(NULL)
, m_dataLength(0)
, m_uPosition(0)
, m_dataActuallyLength(0)
{

}

CMemoryStream::CMemoryStorage::CMemoryStorage(size_t uCapacity)
: m_pData((char *)malloc(uCapacity))
, m_dataLength(0)
, m_uPosition(0)
, m_dataActuallyLength(0)
{
    if( m_pData != NULL )
    {
        m_dataLength = uCapacity;
    }
}

CMemoryStream::CMemoryStorage::CMemoryStorage( const CMemoryStorage &rhs )
{
    m_pData = rhs.m_pData;
    m_dataLength = rhs.m_dataLength;
    m_uPosition = rhs.m_uPosition;
    m_dataActuallyLength = rhs.m_dataActuallyLength;
}

CMemoryStream::CMemoryStorage::~CMemoryStorage()
{
    if( m_pData != NULL )
    {
        free( m_pData );
        m_pData = NULL;
        m_dataLength = 0;
        m_uPosition = 0;
        m_dataActuallyLength = 0;
    }
}

char *CMemoryStream::CMemoryStorage::getData()
{
    return m_pData;
}

size_t CMemoryStream::CMemoryStorage::getLength()
{
    return m_dataLength;
}

bool CMemoryStream::CMemoryStorage::resize(size_t newSize)
{
    if( newSize <= m_dataLength )
        return false;
    char *pNew = (char *)realloc((void *)m_pData, newSize);
    if( pNew != NULL )
    {
        m_pData = pNew;
        m_dataLength = newSize;
        return true;
    }
    else
    {
        return false;
    }
}

size_t CMemoryStream::CMemoryStorage::getActuallLength()
{
    return m_dataActuallyLength;
}

size_t CMemoryStream::CMemoryStorage::getPosition()
{
    return m_uPosition;
}

void CMemoryStream::CMemoryStorage::setPosition(size_t position)
{
    m_uPosition = position;
    if( m_uPosition > m_dataActuallyLength )
        m_dataActuallyLength = m_uPosition;
}

void CMemoryStream::CMemoryStorage::addPosition(int position)
{
    m_uPosition += position;
    if( m_uPosition > m_dataActuallyLength )
        m_dataActuallyLength = m_uPosition;
}


CMemoryStream::CMemoryStream(size_t nCapacity)
: m_pStorage(new CMemoryStorage(nCapacity))
{

}


CMemoryStream::CMemoryStream(const CMemoryStream &rhs)
: m_pStorage(rhs.m_pStorage)
{

}

CMemoryStream::~CMemoryStream()
{
    close();
}

void CMemoryStream::close()
{
    
}

void CMemoryStream::operator=(const ptola::io::CMemoryStream &rhs)
{
    m_pStorage = rhs.m_pStorage;
}

size_t CMemoryStream::getLength()
{
    return m_pStorage->getLength();
}

size_t CMemoryStream::getPosition()
{
    return m_pStorage->getPosition();
}

size_t CMemoryStream::seek(int offset, enumSeekOrigin origin)
{
    switch( origin )
    {
        case eSO_Begin:
            if( offset < 0 )
                offset = 0;
            if( offset > m_pStorage->getLength() )
                offset = m_pStorage->getLength();
            m_pStorage->setPosition(offset);
            break;
        case eSO_Current:
            if( (int)m_pStorage->getPosition() + offset < 0 )
                m_pStorage->setPosition(0);
            else if( (int)m_pStorage->getPosition() + offset > m_pStorage->getLength() )
                m_pStorage->setPosition(m_pStorage->getLength());
            else
                m_pStorage->addPosition(offset);
            break;
        case eSO_End:
            if( offset < 0 )
                offset = 0;
            if( offset > m_pStorage->getLength() )
                offset = m_pStorage->getLength();
            m_pStorage->setPosition( m_pStorage->getLength() - offset );
            break;
    }
    return m_pStorage->getPosition();
}

size_t CMemoryStream::read(void *lpDst, size_t uOffset, size_t uLength)
{
    if( m_pStorage->getPosition() + uLength > m_pStorage->getLength() )
    {
        assert("memory out of range!");
    }
    void *lpDstPos = (void *)((char *)lpDst + uOffset);
    void *lpSrcPos = (void *)(m_pStorage->getData() + m_pStorage->getPosition());
    memcpy( lpDstPos, lpSrcPos, uLength);
    m_pStorage->addPosition(uLength);
    return uLength;
}

size_t CMemoryStream::write(const void *lpSrc, size_t uOffset, size_t uLength)
{
    if( uOffset >= uLength )
    {
        assert("length must greater than offset!");
    }
    if( m_pStorage->getPosition() + uLength - uOffset >= m_pStorage->getLength() )
    {
        size_t uAfter = m_pStorage->getLength() + 64U;
        while( uAfter < m_pStorage->getPosition() + uLength - uOffset )
        {
            uAfter += 64U;
        }
        if( !m_pStorage->resize( uAfter ) )
        {
            assert("memory running out!");
        }
    }
    void *lpSrcPos = (void *)((char *)lpSrc + uOffset);
    void *lpDstPos = (void *)((char *)m_pStorage->getData() + m_pStorage->getPosition());
    memcpy( lpDstPos, lpSrcPos, uLength - uOffset );
    m_pStorage->addPosition(uLength - uOffset);
    return uLength - uOffset;
}

void *CMemoryStream::getData()
{
    return m_pStorage->getData();
}

