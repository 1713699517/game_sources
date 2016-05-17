class CCHttpResponse : public CCObject
{
public:
    /** Constructor, it's used by CCHttpClient internal, users don't need to create HttpResponse manually
     @param request the corresponding HttpRequest which leads to this response 
     */
    CCHttpResponse(CCHttpRequest* request);
    /** Destructor, it will be called in CCHttpClient internal,
     users don't need to desturct HttpResponse object manully 
     */
    virtual ~CCHttpResponse();
    /** Override autorelease method to prevent developers from calling it */
    CCObject* autorelease(void);
    // getters, will be called by users
    
    /** Get the corresponding HttpRequest object which leads to this response 
        There's no paired setter for it, coz it's already setted in class constructor
     */
    inline CCHttpRequest* getHttpRequest();
    /** To see if the http reqeust is returned successfully,
        Althrough users can judge if (http return code = 200), we want an easier way
        If this getter returns false, you can call getResponseCode and getErrorBuffer to find more details
     */
    inline bool isSucceed();
    /** Get the http response raw data */
    inline std::vector<char>* getResponseData();
    /** Get the http response errorCode
     *  I know that you want to see http 200 :)
     */
    inline int getResponseCode();
    /** Get the rror buffer which will tell you more about the reason why http request failed
     */
    inline const char* getErrorBuffer();
    // setters, will be called by CCHttpClient
    // users should avoid invoking these methods
    
    const char *getResponseText();
    /** Set if the http request is returned successfully,
     Althrough users can judge if (http code == 200), we want a easier way
     This setter is mainly used in CCHttpClient, users mustn't set it directly
     */
    inline void setSucceed(bool value);
    
    /** Set the http response raw buffer, is used by CCHttpClient      
     */
    inline void setResponseData(std::vector<char>* data);
    
    /** Set the http response errorCode
     */
    inline void setResponseCode(int value);
    
    /** Set the error buffer which will tell you more the reason why http request failed
     */
    inline void setErrorBuffer(const char* value);
};
