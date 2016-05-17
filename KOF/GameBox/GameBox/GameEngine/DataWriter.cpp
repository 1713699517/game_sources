//
//  DataWriter.cpp
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#include "DataWriter.h"
#include "MemoryAllocator.h"
using namespace ptola::io;
using namespace ptola::memory;

MEMORY_MANAGE_OBJECT_IMPL(CDataWriter);

CDataWriter::CDataWriter(IStream *pStream, bool bLittleEndian)
: m_pStream(pStream)
, m_bLittleEndian(bLittleEndian)
{
    
}

CDataWriter::~CDataWriter()
{
    
}

size_t CDataWriter::write(const void *src, int offset, size_t length)
{
    return m_pStream->write(src, offset, length);
}


#define DATA_WRITE_METHOD_IMPL(_Ty) \
    size_t CDataWriter::write(_Ty value){\
    return m_pStream->write( &value, 0, sizeof(_Ty) ); }

#define DATA_WRITE_METHOD_IMPL_HNS(_Ty) \
    size_t CDataWriter::write(_Ty value){\
    if( m_bLittleEndian ) \
        return m_pStream->write( &value, 0, sizeof(_Ty) ); \
    else {\
        _Ty rvalue = htons(value);\
        return m_pStream->write( &rvalue, 0, sizeof(_Ty) ); }\
}

#define DATA_WRITE_METHOD_IMPL_HNL(_Ty) \
    size_t CDataWriter::write(_Ty value){\
    if( m_bLittleEndian ) \
        return m_pStream->write( &value, 0, sizeof(_Ty) ); \
    else {\
        _Ty rvalue = htonl(value);\
        return m_pStream->write( &rvalue, 0, sizeof(_Ty) ); }\
}

DATA_WRITE_METHOD_IMPL(char)
DATA_WRITE_METHOD_IMPL(unsigned char)
DATA_WRITE_METHOD_IMPL_HNS(short)
DATA_WRITE_METHOD_IMPL_HNS(unsigned short)
DATA_WRITE_METHOD_IMPL_HNL(int)
DATA_WRITE_METHOD_IMPL_HNL(unsigned int)
DATA_WRITE_METHOD_IMPL(long long)
DATA_WRITE_METHOD_IMPL(unsigned long long)
DATA_WRITE_METHOD_IMPL(float)
DATA_WRITE_METHOD_IMPL(double)
DATA_WRITE_METHOD_IMPL(bool)

#undef DATA_WRITE_METHOD_IMPL
#undef DATA_WRITE_METHOD_IMPL_HNS
#undef DATA_WRITE_METHOD_IMPL_HNL

size_t CDataWriter::writel(const std::string &value)
{
    return writel( &value );
}

size_t CDataWriter::writel(const std::string *value)
{
    if( value == NULL )
        return 0U;
    write( (unsigned short)value->length() );
    write( value->c_str(), 0, value->length() );
    return value->length();
}

size_t CDataWriter::write(const std::string &value)
{
    return write( &value );
}

size_t CDataWriter::write(const std::string *value)
{
    if( value == NULL )
        return 0U;
    write( (unsigned char)value->length() );
    write( value->c_str(), 0, value->length() );
    return value->length();
}

void CDataWriter::close()
{
    if(m_pStream != NULL )
    {
        m_pStream->close();
        m_pStream = NULL;
    }
}

size_t CDataWriter::writeInt8(char value)
{
    return write(value);
}

size_t CDataWriter::writeInt8Unsigned(unsigned char value)
{
    return write(value);
}

size_t CDataWriter::writeInt16(short value)
{
    return write(value);
}

size_t CDataWriter::writeInt16Unsigned(unsigned short value)
{
    return write(value);
}

size_t CDataWriter::writeInt32(int value)
{
    return write(value);
}

size_t CDataWriter::writeInt32Unsigned(unsigned int value)
{
    return write(value);
}

size_t CDataWriter::writeInt64(long long value)
{
    return write(value);
}

size_t CDataWriter::writeInt64Unsigned(unsigned long long value)
{
    return write(value);
}

size_t CDataWriter::writeFloat(float value)
{
    return write(value);
}

size_t CDataWriter::writeDouble(double value)
{
    return write(value);
}

size_t CDataWriter::writeString(const std::string &value)
{
    return write( value );
}

size_t CDataWriter::writeString(const std::string *value)
{
    return write( value );
}

size_t CDataWriter::writeUTF(const std::string &value)
{
    return writel(value);
}

size_t CDataWriter::writeUTF(const std::string *value)
{
    return writel(value);
}

size_t CDataWriter::getLength()
{
    return m_pStream->getLength();
}

size_t CDataWriter::getPosition()
{
    return m_pStream->getPosition();
}

size_t CDataWriter::writeBoolean(bool value)
{
    return write(value);
}