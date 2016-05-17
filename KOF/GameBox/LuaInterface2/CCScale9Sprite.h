class CCScale9Sprite : public CCNodeRGBA
{

public:

    CCSize getOriginalSize();

    CCSize getPreferredSize();
    
    void setPreferredSize(CCSize value);

    CCRect getCapInsets();
    
    void setCapInsets(CCRect value);

    float getInsetLeft();
    
    void setInsetLeft(float value);

    float getInsetTop();
    
    void setInsetTop(float value);

    float getInsetRight();
    
    void setInsetRight(float value);

    static CCScale9Sprite* create(const char* file, CCRect rect,  CCRect capInsets);

    static CCScale9Sprite* create(const char* file, CCRect rect);

    static CCScale9Sprite* create(CCRect capInsets, const char* file);

    static CCScale9Sprite* create(const char* file);
    
    static CCScale9Sprite* createWithSpriteFrame(CCSpriteFrame* spriteFrame, CCRect capInsets); 

    static CCScale9Sprite* createWithSpriteFrame(CCSpriteFrame* spriteFrame);  

    static CCScale9Sprite* createWithSpriteFrameName(const char*spriteFrameName, CCRect capInsets);
    
    static CCScale9Sprite* createWithSpriteFrameName(const char*spriteFrameName);
    
    CCScale9Sprite* resizableSpriteWithCapInsets(CCRect capInsets);
    
    static CCScale9Sprite* create();

    virtual void setOpacityModifyRGB(bool bValue);
    
    virtual bool isOpacityModifyRGB(void);

    virtual void setSpriteFrame(CCSpriteFrame * spriteFrame);
};