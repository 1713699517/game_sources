//
//  FileStream.h
//  GameBox
//
//  Created by Caspar on 2013-4-25.
//
//

#ifndef __GameBox__FileStream__
#define __GameBox__FileStream__

#include "IStream.h"
#include "SharedPtr.h"
#include "ptola.h"

namespace ptola
{
namespace io
{

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

        static bool existsDirectory(const char *lpcszDirectoryName);
        static bool existsDirectoryFromResourcePath(const char *lpcszDirectoryName);

        static bool createDirectoryRecursive(const char *lpcszDirectoryName);
        static bool createDirectory(const char *lcpszDirectoryName);
        static bool removeDirectory(const char *lpcszDirectoryName);

        static bool deleteFile(const char *lpcszFileName);
    public:
        MEMORY_MANAGE_OBJECT(CFileStream);
        
        CFileStream(const char *lpcszFileName, const char *lpcszFileMode);
        ~CFileStream();
        void flush();
        virtual void close();
        
        virtual size_t getLength();
        virtual size_t read(void *lpDst, size_t uOffset, size_t uLength );
        virtual size_t write(const void *lpSrc, size_t uOffset, size_t uLength );
        virtual size_t getPosition();
        virtual size_t seek(int offset, enumSeekOrigin origin = eSO_Current);

        virtual void *getData();
    private:
        FILE *m_pFile;
    };

}
}

#endif /* defined(__GameBox__FileStream__) */
