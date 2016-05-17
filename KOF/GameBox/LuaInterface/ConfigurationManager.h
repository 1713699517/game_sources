    class CXMLNode
    {
    public:
        ~CXMLNode();
        const char *getAttribute(const char *lpcszAttributeName);
        CXMLNode nextSibling(const char *lpcszNodeName);
        const char *getName();
        CXMLNodeList children();
        CXMLNode selectSingleNode(const char *lpcszXPath);
    };

    class CXMLNodeList
    {
    public:
        ~CXMLNodeList();
        int getCount(const char *lpcszNodeName = NULL);
        CXMLNode get(int nIndex, const char *lpcszNodeName);
        CXMLNodeList *operator=(const CXMLNodeList &rhs);
    };
    
    class CConfigurationCache
    {
    public:
        CConfigurationCache();
        ~CConfigurationCache();

        static CConfigurationCache *sharedConfigurationCache();
        bool load(const char *lpcszConfigurationFile);
        bool unload(const char *lpcszConfigurationFile);
        CXMLNode getRootElement(const char *lpcszRootName);
    };