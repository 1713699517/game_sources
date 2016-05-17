//
//  DataReader.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#include "DataReader.h"
#include "MemoryAllocator.h"
#include <assert.h>
#include <netinet/in.h>

using namespace ptola::io;
using namespace ptola::memory;

MEMORY_MANAGE_OBJECT_IMPL(CDataReader);

CDataReader::CDataReader(IStream *pStream, bool bLittleEndian)
: m_pStream(pStream)
, m_pReaderBuffer(NULL)
, m_uMaxLength(0)
, m_bLittleEndian(bLittleEndian)
{
    
}

CDataReader::~CDataReader()
{
    if( m_pReaderBuffer != NULL )
    {
        free(m_pReaderBuffer);
        m_pReaderBuffer = NULL;
        m_uMaxLength = 0;
    }
}

size_t CDataReader::read(void *dst, int offset, size_t length)
{
    return m_pStream->read(dst, offset, length);
}

#define DATA_READ_METHOD_IMPL(_Ty, Name) \
    _Ty CDataReader::read##Name(){ \
    _Ty ret;m_pStream->read( &ret, 0, sizeof(_Ty) );return ret;}

#define DATA_READ_METHOD_IMPL_NTHS(_Ty, Name) \
    _Ty CDataReader::read##Name(){ \
    _Ty ret;m_pStream->read( &ret, 0, sizeof(_Ty) );\
    if( !m_bLittleEndian ) \
        return ntohs( ret ); \
    else \
        return ret; }

#define DATA_READ_METHOD_IMPL_NTHL(_Ty, Name) \
    _Ty CDataReader::read##Name(){ \
    _Ty ret;m_pStream->read( &ret, 0, sizeof(_Ty) );\
    if( !m_bLittleEndian ) \
        return ntohl( ret ); \
    else \
        return ret; }


DATA_READ_METHOD_IMPL(char, Int8)
DATA_READ_METHOD_IMPL(unsigned char, Int8Unsigned)
DATA_READ_METHOD_IMPL_NTHS(short, Int16)
DATA_READ_METHOD_IMPL_NTHS(unsigned short, Int16Unsigned)
DATA_READ_METHOD_IMPL_NTHL(int, Int32)
DATA_READ_METHOD_IMPL_NTHL(unsigned int, Int32Unsigned)
DATA_READ_METHOD_IMPL(long long, Int64)
DATA_READ_METHOD_IMPL(unsigned long long, Int64Unsigned)
DATA_READ_METHOD_IMPL(float, Float)
DATA_READ_METHOD_IMPL(double, Double)
DATA_READ_METHOD_IMPL(bool, Boolean)

#undef DATA_READ_METHOD_IMPL
#undef DATA_READ_METHOD_IMPL_NTHS
#undef DATA_READ_METHOD_IMPL_NTHL

#define DATA_READEX_METHOD_IMPL(_Ty,Name) \
    size_t CDataReader::read##Name(_Ty *_value){\
    return m_pStream->read( _value, 0, sizeof(_Ty) ); }


#define DATA_READEX_METHOD_IMPL_NTHS(_Ty,Name) \
    size_t CDataReader::read##Name(_Ty *_value){\
    if( m_bLittleEndian ) \
        return m_pStream->read( _value, 0, sizeof(_Ty) ); \
    else {\
    size_t ret = m_pStream->read( _value, 0, sizeof(_Ty) );\
    _Ty val = *_value; *_value = ntohs(val); \
    return ret;}}


#define DATA_READEX_METHOD_IMPL_NTHL(_Ty,Name) \
size_t CDataReader::read##Name(_Ty *_value){\
if( m_bLittleEndian ) \
return m_pStream->read( _value, 0, sizeof(_Ty) ); \
else {\
size_t ret = m_pStream->read( _value, 0, sizeof(_Ty) );\
_Ty val = *_value; *_value = ntohl(val); \
return ret;}}


DATA_READEX_METHOD_IMPL(char, Int8)
DATA_READEX_METHOD_IMPL(unsigned char, Int8Unsigned)
DATA_READEX_METHOD_IMPL_NTHS(short, Int16)
DATA_READEX_METHOD_IMPL_NTHS(unsigned short, Int16Unsigned)
DATA_READEX_METHOD_IMPL_NTHL(int, Int32)
DATA_READEX_METHOD_IMPL_NTHL(unsigned int, Int32Unsigned)
DATA_READEX_METHOD_IMPL(long long, Int64)
DATA_READEX_METHOD_IMPL(unsigned long long, Int64Unsigned)
DATA_READEX_METHOD_IMPL(float, Float)
DATA_READEX_METHOD_IMPL(double, Double)
DATA_READEX_METHOD_IMPL(bool, Boolean)

#undef DATA_READEX_METHOD_IMPL
#undef DATA_READEX_METHOD_IMPL_NTHS
#undef DATA_READEX_METHOD_IMPL_NTHL

const char *CDataReader::readString()
{
    size_t len = readInt8Unsigned();
    if( len > 0 )
    {
        len++;
        if( m_pReaderBuffer == NULL )
        {
            m_pReaderBuffer = malloc( len );
            m_uMaxLength = len;
        }
        else
        {
            if( len > m_uMaxLength )
            {
                m_uMaxLength = len;
                void *_pTmpBuffer = realloc( m_pReaderBuffer, m_uMaxLength);
                if( _pTmpBuffer != NULL )
                {
                    m_pReaderBuffer = _pTmpBuffer;
                }
                else
                {
                    assert("realloc error!");
                }
            }
        }
        read( m_pReaderBuffer, 0, len - 1 );
        char *lpEnd = (char *)m_pReaderBuffer;
        lpEnd += len - 1;
        *lpEnd = '\0';
        return (const char *)m_pReaderBuffer;
    }
    return NULL;
}

const char *CDataReader::readUTF()
{
    size_t len = readInt16Unsigned();
    if( len > 0 )
    {
        len++;
        if( m_pReaderBuffer == NULL )
        {
            m_pReaderBuffer = malloc( len );
            m_uMaxLength = len;
        }
        else
        {
            if( len > m_uMaxLength )
            {
                m_uMaxLength = len;
                void *_pTmpBuffer = realloc( m_pReaderBuffer, m_uMaxLength);
                if( _pTmpBuffer != NULL )
                {
                    m_pReaderBuffer = _pTmpBuffer;
                }
                else
                {
                    assert("realloc error!");
                }
            }
        }
        read( m_pReaderBuffer, 0, len - 1 );
        char *lpEnd = (char *)m_pReaderBuffer;
        lpEnd += len - 1;
        *lpEnd = '\0';
        CCLOG("r=%s", (const char *)m_pReaderBuffer);
        return (const char *)m_pReaderBuffer;
    }
    return NULL;
}

std::string CDataReader::readStringString()
{
    std::string ret;
    readString( ret );
    return ret;
}

std::string CDataReader::readStringUTF()
{
    std::string ret;
    readUTF(ret);
    return ret;
}

size_t CDataReader::readUTF( std::string &_value )
{
    size_t ret = readInt16Unsigned();
    if( ret > 0 )
    {
        ret++;
        if( m_pReaderBuffer == NULL )
        {
            m_pReaderBuffer = malloc( ret );
            m_uMaxLength = ret;
        }
        else
        {
            if( ret > m_uMaxLength )
            {
                m_uMaxLength = ret;
                void *_pTmpBuffer = realloc( m_pReaderBuffer, m_uMaxLength);
                if( _pTmpBuffer != NULL )
                {
                    m_pReaderBuffer = _pTmpBuffer;
                }
                else
                {
                    assert("realloc error!");
                }
            }
        }
        read( m_pReaderBuffer, 0, ret - 1 );
        char *lpEnd = (char *)m_pReaderBuffer;
        lpEnd += ret - 1;
        *lpEnd = '\0';
        _value.clear();
        _value.assign( (char *)m_pReaderBuffer, ret);
        
    }
    return ret;
}

size_t CDataReader::readString( std::string &_value )
{
    size_t ret = readInt8Unsigned();
    if( ret > 0 )
    {
        ret++;
        if( m_pReaderBuffer == NULL )
        {
            m_pReaderBuffer = malloc( ret );
            m_uMaxLength = ret;
        }
        else
        {
            if( ret > m_uMaxLength )
            {
                m_uMaxLength = ret;
                void *_pTmpBuffer = realloc( m_pReaderBuffer, m_uMaxLength);
                if( _pTmpBuffer != NULL )
                {
                    m_pReaderBuffer = _pTmpBuffer;
                }
                else
                {
                    assert("realloc error!");
                }
            }
        }
        read( m_pReaderBuffer, 0, ret - 1 );
        char *lpEnd = (char *)m_pReaderBuffer;
        lpEnd += ret - 1;
        *lpEnd = '\0';
        _value.clear();
        _value.assign( (char *)m_pReaderBuffer, ret);
    }
    return ret;
}

void CDataReader::close()
{
    if( m_pStream != NULL )
    {
        m_pStream->close();
        m_pStream = NULL;
    }
}