
class CCHttpRequest : public CCObject
{
public:
    /** Use this enum type as param in setReqeustType(param) */
    typedef enum
    {
        kHttpGet,
        kHttpPost,
        kHttpUnkown,
    } HttpRequestType;

    CCHttpRequest();
    
    /** Destructor */
    virtual ~CCHttpRequest();
     
    /** Required field for HttpRequest object before being sent.
        kHttpGet & kHttpPost is currently supported
     */
    inline void setRequestType(HttpRequestType type);    /** Get back the kHttpGet/Post/... enum value */
    inline HttpRequestType getRequestType();
    /** Required field for HttpRequest object before being sent.
     */
    inline void setUrl(const char* url);    /** Get back the setted url */
    inline const char* getUrl();
    /** Option field. You can set your post data here
     */
    inline void setRequestData(const char* buffer, unsigned int len);    /** Get the request data pointer back */
    inline char* getRequestData();    /** Get the size of request data back */
    inline int getRequestDataSize();
    /** Option field. You can set a string tag to identify your request, this tag can be found in HttpResponse->getHttpRequest->getTag()
     */
    inline void setTag(const char* tag);    /** Get the string tag back to identify the request.
        The best practice is to use it in your MyClass::onMyHttpRequestCompleted(sender, HttpResponse*) callback
     */
    inline const char* getTag();
    /** Option field. You can attach a customed data in each request, and get it back in response callback.
        But you need to new/delete the data pointer manully
     */
    inline void setUserData(void* pUserData);    /** Get the pre-setted custom data pointer back.
        Don't forget to delete it. HttpClient/HttpResponse/HttpRequest will do nothing with this pointer
     */
    inline void* getUserData();
    /** Required field. You should set the callback selector function at ack the http request completed
     */    /** Get the target of callback selector funtion, mainly used by CCHttpClient */
    /** Get the selector function pointer, mainly used by CCHttpClient */


    /** Get custom headers **/
    void setLuaCallback(int nHandler);
    int getLuaCallback();
};
