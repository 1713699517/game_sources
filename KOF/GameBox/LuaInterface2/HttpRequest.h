
class CCHttpRequest : public CCObject
{
public:
    typedef enum
    {
        kHttpGet,
        kHttpPost,
        kHttpUnkown,
    } HttpRequestType;
    
    CCHttpRequest();
    
    virtual ~CCHttpRequest();
    
    CCObject* autorelease(void);
    
    void setRequestType(HttpRequestType type);
    HttpRequestType getRequestType();
    void setUrl(const char* url);
    const char* getUrl();

    void setRequestData(const char* buffer, unsigned int len);
    char* getRequestData();
    int getRequestDataSize();
    
    void setTag(const char* tag);
    const char* getTag();
    
    void setUserData(void* pUserData);
    void* getUserData();
    
    void setLuaCallback(LUA_FUNCTION nHandler);
    LUA_FUNCTION getLuaCallback();
};
