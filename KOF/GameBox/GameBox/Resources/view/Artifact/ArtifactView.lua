--*********************************
--2013-8-16 by 陈元杰
--神器主界面-CArtifactView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "view/Artifact/ArtifactShopView"
require "view/Artifact/ArtifactAdvanceView"
require "view/Artifact/ArtifactStrengthenView"


CArtifactView = class(view, function(self)

end)



----------------------------
--常量
----------------------------
--按钮tag值
CArtifactView.TAG_CLOSE     = 201

--tab 页面Tag值
CArtifactView.TAG_Strengthen = 301
CArtifactView.TAG_Advance    = 302
CArtifactView.TAG_Shop       = 303
CArtifactView.TAG_Shop2      = 304

--颜色
CArtifactView.RED   = ccc4(255,0,0,255)
CArtifactView.GOLD  = ccc4(255,215,0,255)
CArtifactView.GREEN = ccc4(120,222,66,255)
CArtifactView.WHITE = ccc4(255,255,255,255)


function CArtifactView.initView( self, _mainSize )
    local winSize = CCDirector:sharedDirector():getVisibleSize()

    self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CArtifactAdvanceView self.m_mainContainer 104" )
    self.m_scenelayer    : addChild( self.m_mainContainer)

    self.m_allBg = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_allBg : setControlName( "this CArtifactView self.m_allBg 43 ")
    self.m_allBg : setPreferredSize( winSize )
    self.m_scenelayer : addChild( self.m_allBg,-10 )

	----------------------------
	--活动背景  关闭按钮
	----------------------------
	self.m_background = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_background : setControlName( "this CArtifactView self.m_background 43 ")
	self.m_background : setPreferredSize( _mainSize )
	self.m_mainContainer : addChild( self.m_background )

	local function local_btnTouchCallback(eventType,obj,x,y)
		--按钮 单击回调
		return self:btnTouchCallback(eventType,obj,x,y)
	end

	self.m_closeBtn	  = CButton :createWithSpriteFrameName( "", "general_close_normal.png")
	self.m_closeBtn   :setControlName( "this CArtifactView self.m_closeBtn 53 ")
	self.m_closeBtn   :setTag( CArtifactView.TAG_CLOSE )
	self.m_closeBtn   :registerControlScriptHandler( local_btnTouchCallback, "this CArtifactView self.m_closeBtn 55 ")
	self.m_mainContainer :addChild( self.m_closeBtn )

	----------------------------
	--主界面()
	----------------------------
	local function local_pageCallBack(eventType, obj, x, y)
       return self : pageCallBack(eventType,obj,x,y)
    end

	--神器强化界面
    self.m_strengthenPage       = CTabPage : createWithSpriteFrameName("神器强化","general_label_normal.png","神器强化","general_label_click.png")
    self.m_strengthenPage       : setTag (CArtifactView.TAG_Strengthen)
    self.m_strengthenPage       : setFontSize(24)
    self.m_strengthenPage       : registerControlScriptHandler(local_pageCallBack)
    -- self.m_strengthenPage 		: setTouchesEnabled( false )
    -- self.m_strengthenPage       : setColor( CArtifactView.GOLD )
    local strengthenPageContainer = CContainer : create()
    strengthenPageContainer : setControlName( "this is CArtifactView strengthenPageContainer 73" )

    self.m_strengthenView   = CArtifactStrengthenView() --初始化
    self.m_strengthenView   : registerStrengthenMediator()
    self.m_strengthenLayer  = self.m_strengthenView:layer()
    self.m_strengthenLayer  : setPosition(-20,-600)
    strengthenPageContainer : addChild(self.m_strengthenLayer)

    --神器进阶界面
    self.m_advancePage       = CTabPage : createWithSpriteFrameName("神器进阶","general_label_normal.png","神器进阶","general_label_click.png")
    self.m_advancePage       : setTag (CArtifactView.TAG_Advance)
    self.m_advancePage       : setFontSize(24)
    self.m_advancePage       : registerControlScriptHandler(local_pageCallBack)
    local advancePageContainer = CContainer : create()
    advancePageContainer : setControlName( "this is CArtifactView advancePageContainer 87" )

    self.m_advancePageView  = CArtifactAdvanceView() --初始化
    self.m_advancePageLayer = self.m_advancePageView:layer()
    self.m_advancePageLayer : setPosition(-20,-600)
    advancePageContainer    : addChild(self.m_advancePageLayer)

    --神器兑换商店界面
    self.m_shopPage    = CTabPage : createWithSpriteFrameName("碎片兑换","general_label_normal.png","碎片兑换","general_label_click.png")
    self.m_shopPage    : setTag (CArtifactView.TAG_Shop)
    self.m_shopPage    : setFontSize(24)
    self.m_shopPage    : registerControlScriptHandler(local_pageCallBack)
    local shopPageContainer = CContainer : create()
    shopPageContainer  : setControlName( "this is CArtifactView shopPageContainer 100" )

    self.m_shopPageView  = CArtifactShopView(1) --初始化
    self.m_shopPageLayer = self.m_shopPageView:layer()
    self.m_shopPageLayer : setPosition(-22,-620)
    shopPageContainer    : addChild(self.m_shopPageLayer)

    local mainplay = _G.g_characterProperty :getMainPlay()
    local nPlayLv  = mainplay :getLv()
    if nPlayLv < 20 then
        self.m_shopPage     : setVisible( false )
    end

    --钻石兑换商店界面
    self.m_shopPage2    = CTabPage : createWithSpriteFrameName("钻石兑换","general_label_normal.png","钻石兑换","general_label_click.png")
    self.m_shopPage2    : setTag (CArtifactView.TAG_Shop2)
    self.m_shopPage2    : setFontSize(24)
    self.m_shopPage2    : registerControlScriptHandler(local_pageCallBack)
    local shopPageContainer2 = CContainer : create()
    shopPageContainer2  : setControlName( "this is CArtifactView m_shopPageLayer2 100" )

    self.m_shopPageView2  = CArtifactShopView(2) --初始化
    self.m_shopPageLayer2 = self.m_shopPageView2 : layer()
    self.m_shopPageLayer2 : setPosition(-22,-620)
    shopPageContainer2   : addChild(self.m_shopPageLayer2)

    if nPlayLv < 20 then
        self.m_shopPage2     : setVisible( false )
    end


	self.m_tab = CTab : create (eLD_Horizontal, CCSizeMake(130, 60))--按钮间距
    self.m_tab        : registerControlScriptHandler(local_pageCallBack)
    self.m_mainContainer : addChild (self.m_tab)

    self.m_tab : addTab(self.m_strengthenPage,strengthenPageContainer)
    self.m_tab : addTab(self.m_advancePage,advancePageContainer)
    self.m_tab : addTab(self.m_shopPage,shopPageContainer)
    self.m_tab : addTab(self.m_shopPage2,shopPageContainer2)

    self.m_tab : onTabChange(self.m_strengthenPage)

end


--加载资源
function CArtifactView.loadResources(self)
	--加载图片资源
	CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ArtifactResources/ArtifactResources.plist")
end

function CArtifactView.unloadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ArtifactResources/ArtifactResources.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("ArtifactResources/ArtifactResources.pvr.ccz")

    for i,v in ipairs(self.m_createResStrList) do
        local r = CCTextureCache :sharedTextureCache():textureForKey(v)
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
    end
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
    -- CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()
end

function CArtifactView.layout(self, _mainSize)
    local winSize = CCDirector:sharedDirector():getVisibleSize()

    self.m_mainContainer : setPosition(ccp( winSize.width/2 - _mainSize.width/2, 0))
    self.m_allBg         : setPosition(ccp( winSize.width*0.5, winSize.height*0.5))

	----------------------------
	--活动背景
	----------------------------
	self.m_background  : setPosition(ccp(_mainSize.width*0.5,_mainSize.height*0.5))
	local closeBtnSize = self.m_closeBtn :getContentSize()
	self.m_closeBtn	   : setPosition(ccp(_mainSize.width-closeBtnSize.width/2,_mainSize.height-closeBtnSize.height/2)) 


	----------------------------
	--主界面()
	----------------------------
	self.m_tab : setPosition(23,_mainSize.height-42)

end

function CArtifactView.showArtifactGoodsTips( self, _good, _type, _str, _fun, _pos  )
    if self.m_scenelayer ~= nil then
        local  temp       = _G.g_PopupView :createByArtifact( _good, _type, _str, _fun, _pos )
        self.m_scenelayer : addChild( temp )
    end
end

function CArtifactView.showGoodsByGoodsIdTips( self, _goodId, _type, _pos  )
    if self.m_scenelayer ~= nil then
        local  temp       = _G.g_PopupView :createByGoodsId( _goodId, _type, _pos )
        self.m_scenelayer : addChild( temp ) 
    end
end

--初始化数据成员
function CArtifactView.initParams( self )
    self.m_createResStrList = {}
    self.m_pageTag = CArtifactView.TAG_Strengthen
end

--释放成员
function CArtifactView.realeaseParams( self)

    _G.g_PopupView :reset()

    self : allunregisterMediator()

    self : unloadResources()

end

function CArtifactView.init(self, _mainSize )
	--加载资源
	self:loadResources()
	--初始化数据
    self:initParams( )
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)
end

function CArtifactView.scene(self)
	local _mainSize = CCSizeMake( 854, 640 )
	self.m_scenelayer = CCScene:create()
	self:init( _mainSize )
	return self.m_scenelayer
end


function CArtifactView.showSureBox( self, _msg )

    local surebox  = CErrorBox()
    local BoxLayer = surebox : create(_msg)
    self.m_scenelayer : addChild(BoxLayer,1000)

end

function CArtifactView.setCreateResStr( self, _str )
    for i,v in ipairs(self.m_createResStrList) do
        if v == _str then
            return
        end
    end

    table.insert( self.m_createResStrList, _str )
end


--*****************
--读取xml数据
--*****************
function CArtifactView.loadXmlData( self )

    _G.Config :load( "config/flsh_reward.xml")

end

--************************
--按钮回调
--************************
--关闭 按钮 单击回调
function CArtifactView.btnTouchCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 
			local tag = obj:getTag()
			if tag == CArtifactView.TAG_CLOSE then
				self :realeaseParams()
				CCDirector:sharedDirector():popScene()
                _G.g_CArtifactView = nil
			end
		end
	end
end



function CArtifactView.pageCallBack(self,eventType,obj,x,y)   --Page页面按钮回调
    if eventType == "TouchBegan" then
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        local  pageTag = obj : getTag()
        print("更换界面了 tag="..pageTag)
        self : allunregisterMediator()

        if pageTag == CArtifactView.TAG_Strengthen then
        	self.m_strengthenPage : setTouchesEnabled( false )
        	self.m_advancePage 	  : setTouchesEnabled( true )
        	self.m_shopPage 	  : setTouchesEnabled( true )
            self.m_shopPage2      : setTouchesEnabled( true )

            self.m_strengthenView : refreshPackageData()
            self.m_strengthenView : registerStrengthenMediator()

            self.m_strengthenView : resetStrenInfo()
        elseif pageTag == CArtifactView.TAG_Advance then
        	self.m_strengthenPage : setTouchesEnabled( true )
        	self.m_advancePage 	  : setTouchesEnabled( false )
        	self.m_shopPage 	  : setTouchesEnabled( true )
            self.m_shopPage2      : setTouchesEnabled( true )

            self.m_advancePageView: refreshPackageData()
            self.m_advancePageView: registerAdvanceMediator()
            self.m_advancePageView: resetStrenInfo()
        elseif pageTag == CArtifactView.TAG_Shop  then
        	self.m_strengthenPage : setTouchesEnabled( true )
        	self.m_advancePage 	  : setTouchesEnabled( true )
        	self.m_shopPage 	  : setTouchesEnabled( false )
            self.m_shopPage2      : setTouchesEnabled( true )
            
            self.m_shopPageView   : registerShopMediator()
            self.m_shopPageView   : sendRequestViewMessage()
        elseif pageTag == CArtifactView.TAG_Shop2  then
            self.m_strengthenPage : setTouchesEnabled( true )
            self.m_advancePage    : setTouchesEnabled( true )
            self.m_shopPage       : setTouchesEnabled( true )
            self.m_shopPage2      : setTouchesEnabled( false )
            
            self.m_shopPageView2   : registerShopMediator()
            self.m_shopPageView2   : sendRequestViewMessage()
        end
    end
end

function CArtifactView.allunregisterMediator( self )
    self.m_strengthenView  : unregisterStrengthenMediator()
    self.m_advancePageView : unregisterAdvanceMediator()
    self.m_shopPageView    : unregisterShopMediator()
    self.m_shopPageView2   : unregisterShopMediator()
end


