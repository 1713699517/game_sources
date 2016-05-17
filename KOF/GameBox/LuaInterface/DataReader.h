    class CDataReader : public CCObject
    {
    public:
        CDataReader(IStream *pStream, bool bLittleEndian);
        ~CDataReader();
        
        char readInt8();
        unsigned char readInt8Unsigned();
        
        short readInt16();
        unsigned short readInt16Unsigned();
        
        int readInt32();
        unsigned int readInt32Unsigned();
        
        long long readInt64();
        unsigned long long readInt64Unsigned();
        
        float readFloat();
        double readDouble();

        const char *readString();
        const char *readUTF();
        
        bool readBoolean();
        
        size_t read(void *dst, int offset, size_t length);
        
        size_t readInt8( char *_value );
        size_t readInt8Unsigned( unsigned char *_value);
        size_t readInt16( short *_value );
        size_t readInt16Unsigned( unsigned short *_value );
        size_t readInt32( int *_value );
        size_t readInt32Unsigned( unsigned int *_value );
        size_t readInt64( long long *_value );
        size_t readInt64Unsigned( unsigned long long *_value );
        size_t readFloat( float *_value );
        size_t readDouble( double *_value );
        size_t readString( std::string &_value );
        size_t readUTF( std::string &_value);
        
        void close();
    };
