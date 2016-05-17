class CConfigurationManager
{
public:
    CConfigurationManager();
    ~CConfigurationManager();
    
    static CConfigurationManager *sharedConfigurationManager();
    bool load(const char *lpcszConfigurationFile);
    bool unload(const char *lpcszConfigurationFile);
};

struct SXMLConfig
{
    SXMLConfig();
    ~SXMLConfig();
};

class CXMLNode
{
public:
    CXMLNode(rapidxml::xml_node<> *pNode);
    CXMLNode(const CXMLNode &rhs);
    ~CXMLNode();
    const char *getAttribute(const char *lpcszAttributeName);
    CXMLNode nextSibling(const char *lpcszNodeName = NULL);
    const char *getName();
    CXMLNodeList children();
    CXMLNode selectSingleNode(const char *lpcszXPath);
    bool isEmpty();
};

class CXMLNodeList
{
public:
    CXMLNodeList(rapidxml::xml_node<> *pNode, const char *lpcszDefaultName=NULL);
    CXMLNodeList(const CXMLNodeList &rhs);
    ~CXMLNodeList();
    int getCount(const char *lpcszNodeName = NULL);
    CXMLNode get(int nIndex, const char *lpcszNodeName = NULL);
};

class CConfigurationCache
{
public:
    CConfigurationCache();
    ~CConfigurationCache();
    
    static CConfigurationCache *sharedConfigurationCache();
    bool load(const char *lpcszConfigurationFile);
    bool unload(const char *lpcszConfigurationFile);
    
    rapidxml::xml_node<> *selectSingleNode(const char *lpcszRootName, const char *lpcszPath);
    
    rapidxml::xml_attribute<> *getFirstAttribute(rapidxml::xml_node<> *pNode, const char *lpcszAttributeName = NULL);
    
    rapidxml::xml_node<> *getFirstChildNode(rapidxml::xml_node<> *pNode, const char *lpcszNodeName = NULL);
    
    const char *getRootElementName(const char *lpcszConfigurationFile);
    
    CXMLNode getRootElement(const char *lpcszRootName);
};
