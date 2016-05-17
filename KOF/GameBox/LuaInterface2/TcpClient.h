class CTcpClient : public CCObject
{
public:
    static CTcpClient *sharedTcpClient();
    
    int connect( IPAddress &address , unsigned short ustPort );
    
    int connect( const char *lpcszHost, unsigned short ustPort);
    
    void close();
    
    void send(CReqMessage *pReq);
    
    int getTag();
    
    void setPauseProcess(bool bPause);
    
    bool getPauseProcess();
    
    void mainThreadProcess(float dt);
    
    bool isConnected();
};
