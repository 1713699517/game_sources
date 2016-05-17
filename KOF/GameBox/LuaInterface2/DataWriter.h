    class CDataWriter : public CCObject
    {
    public:
        CDataWriter(IStream *pStream, bool bLittleEndian);
        ~CDataWriter();

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
    };
    
