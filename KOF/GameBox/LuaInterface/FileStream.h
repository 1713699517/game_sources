    enum enumFileMode
    {
         eFM_Read = 0x1
        ,eFM_Write = 0x2
        ,eFM_Binary = 0x4
    };

    class CFileStream : public IStream
    {
    public:
        static bool exists(const char *lpcszFileName);
        static bool existsFromResourcePath(const char *lpcszFileName);
    public:
        CFileStream(const char *lpcszFileName, const char *lpcszFileMode);
        ~CFileStream();
        void flush();
        virtual void close();
        
        virtual size_t getLength();
        virtual size_t read(void *lpDst, size_t uOffset, size_t uLength );
        virtual size_t write(const void *lpSrc, size_t uOffset, size_t uLength );
        virtual size_t getPosition();
        virtual size_t seek(int offset, enumSeekOrigin origin);

        virtual void *getData();
    };
