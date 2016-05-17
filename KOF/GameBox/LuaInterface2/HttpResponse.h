class CCHttpResponse : public CCObject
{
public:
    CCHttpResponse(CCHttpRequest* request);
    
    virtual ~CCHttpResponse();
    
    CCObject* autorelease(void);
    
    CCHttpRequest* getHttpRequest();
    
    bool isSucceed();
    
    std::vector<char>* getResponseData();
    
    const char *getResponseText();
    
    int getResponseCode();
    
    const char* getErrorBuffer();
    
    void setSucceed(bool value);
    
    void setResponseData(std::vector<char>* data);
    
    void setResponseCode(int value);
    
    void setErrorBuffer(const char* value);
    
};
