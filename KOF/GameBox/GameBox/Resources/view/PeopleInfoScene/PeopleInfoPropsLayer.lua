
CPeopleInfoPropsLayer = {}



function CPeopleInfoPropsLayer.layer(self)
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("bagResurece/bag.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("General.plist");
    self.Scenelayer = CContainer :create()
    self.Scenelayer : setControlName( "this is CPeopleInfoPropsLayer self.Scenelayer 13  " )
    self:init(winSize)

    
    return self.Scenelayer
end

function CPeopleInfoPropsLayer :init(winSize)
    self.PropsBtnLayout = CHorizontalLayout :create()
    self.PropsBtnLayout :setCellSize(CCSizeMake(120,120))
    self.PropsBtnLayout :setLineNodeSum(3)
    self.PropsBtnLayout :setVerticalDirection(true)
    self.PropsBtnLayout :setPosition(550,100)
    self.Scenelayer :addChild(self.PropsBtnLayout,10)

    for i = 1,12 do
        local m_btnPropBackGround = CButton :createWithSpriteFrameName("","equipcell.png")
        self.PropsBtnLayout :addChild(m_btnPropBackGround)
    end
end