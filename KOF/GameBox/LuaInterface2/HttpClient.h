class CCHttpClient : public CCObject
{
public:
    static CCHttpClient *getInstance();
    
    static void destroyInstance();

    void send(CCHttpRequest* request);
  
    void setTimeoutForConnect(int value);
    
    int getTimeoutForConnect();
    
    void setTimeoutForRead(int value);
    
    int getTimeoutForRead();
};
