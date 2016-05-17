//
//  DataWriter.h
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#ifndef __ResureTheDiaos__DataWriter__
#define __ResureTheDiaos__DataWriter__

#include "cocos2d.h"
#include "ptola.h"
#include <string>
#include "IStream.h"
#include <netinet/in.h>
USING_NS_CC;

namespace ptola
{
namespace io
{

    class CDataWriter : public CCObject
    {
    public:
        MEMORY_MANAGE_OBJECT(CDataWriter);
        
        CDataWriter(IStream *pStream, bool bLittleEndian=false);
        ~CDataWriter();
        
        size_t write(char value);
        size_t write(unsigned char value);
        
        size_t write(short value);
        size_t write(unsigned short value);
        
        size_t write(int value);
        size_t write(unsigned int value);
        
        size_t write(long long value);
        size_t write(unsigned long long value);
        
        size_t write(float value);
        size_t write(double value);

        size_t write(bool value);
        
        size_t write(const void *src, int offset, size_t length);
        
        size_t writel(const std::string &value);
        size_t writel(const std::string *value);

        size_t write(const std::string &value);
        size_t write(const std::string *value);

        size_t writeInt8(char value);
        size_t writeInt8Unsigned(unsigned char value);

        size_t writeInt16(short value);
        size_t writeInt16Unsigned(unsigned short value);

        size_t writeInt32(int value);
        size_t writeInt32Unsigned(unsigned int value);

        size_t writeInt64( long long value );
        size_t writeInt64Unsigned(unsigned long long value);

        size_t writeFloat(float value);
        size_t writeDouble(double value);

        size_t writeUTF(const std::string &value);
        size_t writeUTF(const std::string *value);
        size_t writeString(const std::string &value);
        size_t writeString(const std::string *value);

        size_t writeBoolean(bool value);
        
        void close();

        size_t getLength();
        size_t getPosition();
    private:
        IStream *m_pStream;
        bool m_bLittleEndian;
    };
    
}
}

#endif /* defined(__ResureTheDiaos__DataWriter__) */
