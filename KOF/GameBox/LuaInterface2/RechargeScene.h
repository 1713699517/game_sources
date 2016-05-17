
class CRechargeScene : public CCLayer
{
public:
    static void setRechargeData(const char *lpcszKey, const char *lpcszValue);
    
    static const char *getRechargeData(const char *lpcszKey);

    static CCScene *create();

};
