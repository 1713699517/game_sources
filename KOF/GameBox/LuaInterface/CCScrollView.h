enum CCScrollViewDirection{
	kCCScrollViewDirectionNone = -1,
    kCCScrollViewDirectionHorizontal = 0,
    kCCScrollViewDirectionVertical,
    kCCScrollViewDirectionBoth
} ;

class CCScrollView : public CCLayer
{
public:

    virtual void registerWithTouchDispatcher();

    static CCScrollView* create(CCSize size, CCNode* container = NULL);

    static CCScrollView* create();
    void setContentOffset(CCPoint offset, bool animated = false);
    CCPoint getContentOffset();
    void setContentOffsetInDuration(CCPoint offset, float dt); 

    void setZoomScale(float s);
    void setZoomScale(float s, bool animated);

    float getZoomScale();

    void setZoomScaleInDuration(float s, float dt);
    CCPoint minContainerOffset();
    CCPoint maxContainerOffset(); 
    bool isNodeVisible(CCNode * node);
    void pause(CCObject* sender);
    void resume(CCObject* sender);


    bool isDragging();
    bool isTouchMoved();
    bool isBounceable();
    void setBounceable(bool bBounceable);
    CCSize getViewSize();
    void setViewSize(CCSize size);

    CCNode * getContainer();
    void setContainer(CCNode * pContainer);

    CCScrollViewDirection getDirection();
    virtual void setDirection(CCScrollViewDirection eDirection);
    CCScrollViewDelegate* getDelegate();
    void setDelegate(CCScrollViewDelegate* pDelegate);

    virtual void setContentSize(const CCSize & size);
    virtual const CCSize& getContentSize();

	void updateInset();
    /**
     * Determines whether it clips its children or not.
     */
    bool isClippingToBounds();
    void setClippingToBounds(bool bClippingToBounds);
};
