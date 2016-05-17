require "view/view"
require "common/Constant"


CFunOpenView = class(view,function ( self )

end)



CFunOpenView.TAG_CLOSE = 101
CFunOpenView.Priority  = -200020


function CFunOpenView.initView( self, _mainSize )

	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CFunOpenView self.m_mainContainer 39 ")
    self.m_viewContainer : addChild( self.m_mainContainer )

    local bgSize = CCSizeMake( 650, 450 )

    self.m_background = CSprite :createWithSpriteFrameName("general_thirdly_underframe.png")
    self.m_background : setControlName( "this CFunOpenView self.m_background 39 ")
	self.m_background : setPreferredSize( bgSize )
	self.m_mainContainer : addChild( self.m_background )

	local function local_closeBtnCallback(eventType,obj,x,y)
		return self:closeBtnCallback(eventType,obj,x,y)
	end


    ----------------------------
	--主界面
	----------------------------
	local lineSize  = CCSizeMake( 640, 4 )
	self.m_lineImg1 = CSprite :createWithSpriteFrameName("guide_openFun_line.png")
    self.m_lineImg1 : setControlName( "this CFunOpenView self.m_lineImg1 39 ")
    self.m_lineImg1 : setPreferredSize( lineSize )
	self.m_mainContainer : addChild( self.m_lineImg1 )

	self.m_lineImg2 = CSprite :createWithSpriteFrameName("guide_openFun_line.png")
    self.m_lineImg2 : setControlName( "this CFunOpenView self.m_lineImg2 39 ")
    self.m_lineImg2 : setPreferredSize( lineSize )
	self.m_mainContainer : addChild( self.m_lineImg2 )

	self.m_knowBtn = CButton :createWithSpriteFrameName( "知道了", "general_button_normal.png")
	self.m_knowBtn : setControlName( "this CFunOpenView self.m_knowBtn 70 ")
	self.m_knowBtn : setFontSize( 24 )
    self.m_knowBtn : setTag( CFunOpenView.TAG_CLOSE )
    self.m_knowBtn : setTouchesPriority( CFunOpenView.Priority - 1 )
    self.m_knowBtn : registerControlScriptHandler( local_closeBtnCallback, "this CFunOpenView self.m_knowBtn 72 ")
    self.m_mainContainer : addChild( self.m_knowBtn )

    self.m_titleLabel = CCLabelTTF:create("提示","Arial", 34)
    self.m_titleLabel : setColor( ccc4(255,255,0,255) )
    self.m_mainContainer : addChild( self.m_titleLabel )


    ----------------------------
	--功能提示
	----------------------------
	local describe = _G.g_CFunOpenManager:getNewStrOnLineChuange(self.m_funOpenNode:getAttribute("describe"))

    self.m_infoLabel = CCLabelTTF:create( describe,"Arial", 25)
    self.m_infoLabel : setColor( ccc4(255,255,255,255) )
    self.m_infoLabel : setHorizontalAlignment( kCCTextAlignmentLeft )
    self.m_mainContainer : addChild( self.m_infoLabel )

    self.m_funOpenRect = CSprite :createWithSpriteFrameName("guide_openFun_frame_02.png",CCRectMake(100,90,10,10))
    self.m_funOpenRect : setControlName( "this CFunOpenView self.m_funOpenRect 39 ")
    self.m_funOpenRect : setPreferredSize( CCSizeMake( 270, 210 ) )
	self.m_mainContainer : addChild( self.m_funOpenRect )

	self.m_arrowImg = CSprite :createWithSpriteFrameName("guide_openFun_arrow_right.png")
    self.m_arrowImg : setControlName( "this CFunOpenView self.m_arrowImg 39 ")
	self.m_mainContainer : addChild( self.m_arrowImg )

	local funNameLb = CCLabelTTF:create(self.m_funOpenNode:getAttribute("guide_name"),"Arial", 30)
    funNameLb : setColor( ccc4(0,0,0,255) )
    funNameLb : setPosition( ccp( -20,0 ) )
    self.m_arrowImg : addChild( funNameLb )

    self.m_funIcon1 = nil
    self.m_funIcon2 = nil
    self.m_funIcon3 = nil
    if self.m_funOpenNode:getAttribute("picture_one") ~= "0" and self.m_funOpenNode:getAttribute("picture_one") ~= nil then
    	self.m_funIcon1 = CSprite :createWithSpriteFrameName(self.m_funOpenNode:getAttribute("picture_one")..".png")
	    self.m_funIcon1 : setControlName( "this CFunOpenView self.m_funIcon1 39 ")
	    self.m_funIcon1 : setGray( true )

	    local iConSize  = self.m_funIcon1:getPreferredSize()
	    self.m_funIcon1 : setPosition( ccp( -iConSize.width-8, 0 ) )

		self.m_funOpenRect : addChild( self.m_funIcon1, -100 )


    end

    if self.m_funOpenNode:getAttribute("picture_two") ~= "0" and self.m_funOpenNode:getAttribute("picture_two") ~= nil then
    	self.m_funIcon2 = CSprite :createWithSpriteFrameName(self.m_funOpenNode:getAttribute("picture_two")..".png")
	    self.m_funIcon2 : setControlName( "this CFunOpenView self.m_funIcon2 39 ")

	    local iConSize  = self.m_funIcon2:getPreferredSize()
	    self.m_funIcon2 : setPosition( ccp( 0, 0 ) )

		self.m_funOpenRect : addChild( self.m_funIcon2, -100 )
    end

    if self.m_funOpenNode:getAttribute("picture_three") ~= "0" and self.m_funOpenNode:getAttribute("picture_three") ~= nil then
    	self.m_funIcon3 = CSprite :createWithSpriteFrameName(self.m_funOpenNode:getAttribute("picture_three")..".png")
	    self.m_funIcon3 : setControlName( "this CFunOpenView self.m_funIcon3 39 ")
	    self.m_funIcon3 : setGray( true )

	    local iConSize  = self.m_funIcon3:getPreferredSize()
	    self.m_funIcon3 : setPosition( ccp( iConSize.width+8, 0 ) )

		self.m_funOpenRect : addChild( self.m_funIcon3, -100 )
    end



end



function CFunOpenView.layout(self, _mainSize)

	local _winSize = CCDirector:sharedDirector():getVisibleSize()
	self.m_mainContainer : setPosition( ccp( _winSize.width/2-_mainSize.width/2, 15 ) )
	self.m_background : setPosition( ccp( _mainSize.width/2, _mainSize.height/2 ) )


	----------------------------
	--主界面
	----------------------------
	self.m_lineImg1 : setPosition( ccp( _mainSize.width/2, 487 ) )
	self.m_lineImg2 : setPosition( ccp( _mainSize.width/2, 175 ) )
	self.m_knowBtn  : setPosition( ccp( _mainSize.width/2, 137 ) )
	self.m_titleLabel : setPosition( ccp( _mainSize.width/2, 514 ) )

	----------------------------
	--功能提示
	----------------------------
	local mainBgSize = self.m_background  : getPreferredSize()
	local rectSize   = self.m_funOpenRect : getPreferredSize()
	local arrowSize  = self.m_arrowImg    : getPreferredSize()
	local dir = tonumber(self.m_funOpenNode:getAttribute("type"))
	local info_Y = 0
	local icon_Y = 0
	if dir == 1 then
		--系统功能
		self.m_infoLabel : setAnchorPoint( ccp( 0,1 ) )

		info_Y = 476
		icon_Y = 283
	else
		--活动功能
		self.m_infoLabel : setAnchorPoint( ccp( 0,0 ) )

		info_Y = 190
		icon_Y = 385
	end

	self.m_infoLabel   : setPosition( ccp( _mainSize.width/2-mainBgSize.width/2 + 22, info_Y ) )
	self.m_funOpenRect : setPosition( ccp( _mainSize.width/2+rectSize.width/2+5, icon_Y ) )
	self.m_arrowImg    : setPosition( ccp( _mainSize.width/2-arrowSize.width/2+25, icon_Y ) )
end

function CFunOpenView.contanierCallBack( self, eventType, obj, x, y )
	if eventType == "Exit" then
		self.m_viewContainer = nil
	end
end

function CFunOpenView.create(self,_node)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )

	if _node == nil then
		return
	end

	local function local_CallBack( eventType, obj, x, y )
		return self:contanierCallBack( eventType, obj, x, y )
	end

	self.m_viewContainer = CContainer :create()
    self.m_viewContainer : setControlName( "this CFunOpenView self.m_viewContainer 39 ")
    self.m_viewContainer : setFullScreenTouchEnabled(true)
    self.m_viewContainer : setTouchesEnabled(true)
    self.m_viewContainer : setTouchesPriority( CFunOpenView.Priority )

    self:init(_mainSize,_node)

	return self.m_viewContainer
end

function CFunOpenView.init(self, _mainSize, _node)

	--初始化数据
	self:initParment(_node)
	--加载资源
	self:loadResources()
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)

end

function CFunOpenView.initParment( self, _node )
	self.m_funOpenNode 	   = _node
	self.m_creteResStrList = {}
end

function CFunOpenView.loadResources( self )
	print("CFunOpenView--加载图片资源")

	CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("GuideResources/GuideOpenFunResources.plist")
end

function CFunOpenView.unloadResources( self )
	print("CFunOpenView--释放图片资源")

	CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("GuideResources/GuideOpenFunResources.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("GuideResources/GuideOpenFunResources.pvr.ccz")
end

function CFunOpenView.closeView( self )
	_G.g_CFunOpenManager : resetFunOpenView()
	if self.m_viewContainer ~= nil then
		self.m_viewContainer : removeFromParentAndCleanup( true )
		self.m_viewContainer = nil
	end

	-- self:unloadResources()
end




--************************
--按钮回调
--************************
--关闭 单击回调
function CFunOpenView.closeBtnCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
			self:closeView()

			_G.pCGuideManager:registGuide(  _G.Constant.CONST_NEW_GUIDE_FUN_NOTIC , tonumber( self.m_funOpenNode:getAttribute("id") ) ) 
		end
	end
end








