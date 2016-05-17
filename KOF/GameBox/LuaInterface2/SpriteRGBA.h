    class CSpriteRGBA : public CCScale9Sprite
    {
    public:

        static CSpriteRGBA *create();
        static CSpriteRGBA *create(const char *file);
        static CSpriteRGBA *create(CCRect capInsets, const char *file);
        static CSpriteRGBA *create(const char *file, cocos2d::CCRect rect);
        static CSpriteRGBA *create(const char *file, cocos2d::CCRect rect, cocos2d::CCRect capInsets);
        
        static CSpriteRGBA *createWithSpriteFrameName(const char *frame);
        static CSpriteRGBA *createWithSpriteFrameName(const char *frame, cocos2d::CCRect rect);

        void shaderDotColor(float r, float g, float b, float a);
        void shaderDotColor(int r, int g, int b, int a);
        void shaderDotColor(const ccColor4F &_color);
        void shaderDotColor(const ccColor4B &_color);


        void shaderMulColor(float r, float g, float b, float a);
        void shaderMulColor(int r, int g, int b, int a);
        void shaderMulColor(const ccColor4F &_color);
        void shaderMulColor(const ccColor4B &_color);

        void shaderResetNull();
    };
