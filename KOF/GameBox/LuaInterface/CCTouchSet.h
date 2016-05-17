    class CCTouchSet : public CCObject
    {
    public:
        CCTouchSet(CCSet *pSet);

        int count();

        CCTouch *anyObject();
        
        CCTouch *at(int nIndex);

    };
