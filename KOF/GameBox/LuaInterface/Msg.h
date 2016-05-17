    typedef struct
    {
        unsigned int uLength;
        unsigned short ustChecksum;
        unsigned int uMsgId;
        unsigned short uHex;
        bool isValid();
    } SReqHeader;


    typedef struct
    {
        unsigned int uLength;
        unsigned short ustChecksum;
        unsigned int uMsgId;
        bool bCompression;
        bool isValid();
    } SAckHeader;


    class CReqMessage : public CCObject
    {
    public:
        CReqMessage(unsigned int uMsgId);
        ~CReqMessage();
    public:
        SReqHeader *getHeader();
        virtual void serialize(CDataWriter *pWriter);
        IStream *getStreamData();
        void setLength(size_t len);
        size_t getLength();
    };

    class CAckMessage : public CCObject
    {
    public:
        CAckMessage(unsigned int uMsgId);
    public:
        SAckHeader *getHeader();
        virtual void deserialize(CDataReader *pReader);
        IStream *getStreamData();
        void resetStream();
        size_t getLength();
        unsigned int getMsgID();
    };