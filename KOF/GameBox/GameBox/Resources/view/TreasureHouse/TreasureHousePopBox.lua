require "view/view"

CTreasureHousePopBox = class(view,function (self)

                          end)

function CTreasureHousePopBox.create(self,_theGoodId,_position) 
    local winSize    = CCDirector:sharedDirector():getVisibleSize()
    self.Scenelayer  = CContainer :create()

    self.theGoodId   = _theGoodId
    self.m_position  = _position

    self : init (winSize,self.Scenelayer) 

    return self.Scenelayer
end

function CTreasureHousePopBox.loadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
    _G.Config:load("config/hidden_describe.xml")
end

function CTreasureHousePopBox.layout(self, _winSize)  --适配布局

        self.windowsBackGroundSprite : setPosition(480,320+80)
        self.TheGoodBtn              : setPosition (480-105,450)
        self : setPopupViewPosition()
end

function CTreasureHousePopBox.init(self, _winSize, _layer)
    self : loadResources()                        --资源初始化
    self : initView(_winSize,_layer)  --界面初始化
    self : layout(_winSize)                       --适配布局初始化
    self : initParameter()                        --参数初始化
end

function CTreasureHousePopBox.initParameter(self)
    self.theGoodsSprite = nil
    local  id  = self.theGoodId
    if id ~= nil then
        local node   = _G.Config.hiddens : selectSingleNode("hidden[@id="..tostring(id).."]") --节点节点

        local name     = node: getAttribute("name") 
        local icon     = node: getAttribute("icon") 
        local describe = node: getAttribute("describe") 

        local icon_url       = "Icon/i"..icon..".jpg"
        self.theGoodsSprite  = CSprite : create(icon_url)            
        self.TheGoodBtn      : addChild(self.theGoodsSprite,-1)

        self.TheGoodBtnLabel    : setString (name)
        self.TheGoodRemarkLabel : setString (describe)
    end
end

function CTreasureHousePopBox.initView(self,_winSize,_layer)
    --背景图
    self.windowsBackGroundSprite = CSprite : createWithSpriteFrameName("general_tips_underframe.png")       --box底图
    self.windowsBackGroundSprite : setPreferredSize(CCSizeMake(350,250))
    _layer                       : addChild (self.windowsBackGroundSprite)

    --物品
    self.TheGoodBtn = CButton :createWithSpriteFrameName("","general_props_frame_click.png")
    self.TheGoodBtn : setTouchesPriority(-110)   
    _layer          : addChild(self.TheGoodBtn)

    self.TheGoodBtnLabel = CCLabelTTF :create("物品名称","Arial",18)
    self.TheGoodBtnLabel : setPosition(105,25) 
    self.TheGoodBtn      : addChild(self.TheGoodBtnLabel)  

    self.LineSprite = CSprite: createWithSpriteFrameName("general_tips_line.png")
    self.LineSprite : setPosition(105,-60) 
    self.TheGoodBtn : addChild(self.LineSprite) 

    self.TheGoodRemarkLabel = CCLabelTTF :create("描述","Arial",18)
    self.TheGoodRemarkLabel : setHorizontalAlignment(kCCTextAlignmentLeft) --左对齐 
    self.TheGoodRemarkLabel : setDimensions( CCSizeMake(310,120))          --设置文字区域
    self.TheGoodRemarkLabel : setPosition(110,-140) 
    self.TheGoodBtn         : addChild(self.TheGoodRemarkLabel)  
end

--设置Tip的位置 --使其在屏幕内显示
function CTreasureHousePopBox.setPopupViewPosition( self)

    print(" CPopupView.setPopupViewPosition00000: ",self.m_position.x, self.m_position.y)

    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_backgroundsize = self.windowsBackGroundSprite : getPreferredSize()
    if self.m_position.x+self.m_backgroundsize.width > winSize.width then
        self.m_position.x = winSize.width - self.m_backgroundsize.width
    end
    if self.m_position.y-self.m_backgroundsize.height < 0 then
        self.m_position.y = self.m_backgroundsize.height
    end
    print(" CPopupView.setPopupViewPosition: ",self.m_position.x, self.m_position.y)
    self.Scenelayer :setPosition( ccp( self.m_position.x, self.m_position.y-590+60+60))
end





