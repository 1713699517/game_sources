class CCHttpClient : public CCObject
{
public:
    /** Return the shared instance **/
    static CCHttpClient *getInstance();
    
    /** Relase the shared instance **/
    static void destroyInstance();
        
    /**
     * Add a get request to task queue
     * @param request a CCHttpRequest object, which includes url, response callback etc.
                      please make sure request->_requestData is clear before calling "send" here.
     * @return NULL
     */
    void send(CCHttpRequest* request);
  
    
    /**
     * Change the connect timeout
     * @param timeout 
     * @return NULL
     */
    void setTimeoutForConnect(int value);
    
    /**
     * Get connect timeout
     * @return int
     *
     */
    int getTimeoutForConnect();
    
    
    /**
     * Change the download timeout
     * @param value
     * @return NULL
     */
    void setTimeoutForRead(int value);
    

    /**
     * Get download timeout
     * @return int
     */
    int getTimeoutForRead();

};
