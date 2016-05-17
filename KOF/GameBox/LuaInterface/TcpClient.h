    class CTcpClient
    {
    public:
        static CTcpClient *sharedTcpClient();
    public:

        int connect( const char *lpcszHost , unsigned short ustPort );
        void close();
        void send(CReqMessage *pReq);
        int getTag();

	void setPauseProcess(bool bPause);
        bool getPauseProcess();
    };

