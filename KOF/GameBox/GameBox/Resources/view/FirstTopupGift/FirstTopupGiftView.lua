--*********************************
--2013-8-2 by 陈元杰
--首充礼包主界面-FirstTopupGiftView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "mediator/FirstTopupGiftMediator"
require "view/LuckyLayer/PopBox"
--require "common/Constant"

CFirstTopupGiftView = class(view, function(self)
	CFirstTopupGiftView.readgiftxml = nil
end)
--Constant:
CFirstTopupGiftView.TAG_TOPUP     = 201
CFirstTopupGiftView.TAG_GETREWARD = 202
CFirstTopupGiftView.TAG_CLOSE     = 203

function CFirstTopupGiftView.initView( self, _mainSize )
	----------------------------
	--活动背景
	----------------------------
	self.m_background = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_background : setControlName( "this CFirstTopupGiftView self.m_background 26 ")
	self.m_background : setPreferredSize( self.m_winSize )
	self.m_scenelayer : addChild( self.m_background )

	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CFirstTopupGiftView self.m_mainContainer 53" )
    self.m_scenelayer    : addChild( self.m_mainContainer)

	self.m_mainBg = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_mainBg : setControlName( "this CFirstTopupGiftView self.m_mainBg 31 ")
	self.m_mainBg : setPreferredSize( _mainSize )
	self.m_mainContainer : addChild( self.m_mainBg )

	self.m_meiNvimg = CSprite :createWithSpriteFrameName("firstrecharge_woman.png")
    self.m_meiNvimg : setControlName( "this CFirstTopupGiftView self.m_meiNvimg 36 ")
	self.m_mainContainer : addChild( self.m_meiNvimg )


	local function local_btnTouchCallback(eventType,obj,x,y)
		return self:btnTouchCallback(eventType,obj,x,y)
	end

	----------------------------
	--关闭 充值按钮 领取奖励按钮
	----------------------------
	self.m_closeBtn		= CButton :createWithSpriteFrameName( "", "general_close_normal.png")
	self.m_topUpBtn 	= CButton :createWithSpriteFrameName( "", "shop_button_recharge_normal.png")
    self : Create_effects_button(self.m_topUpBtn) --充值按钮特效添加
	self.m_getRewardBtn = CButton :createWithSpriteFrameName( "领取奖励", "general_button_normal.png")

	self.m_closeBtn 	:setControlName( "this CFirstTopupGiftView self.m_closeBtn 51 ")
	self.m_topUpBtn 	:setControlName( "this CFirstTopupGiftView self.m_topUpBtn 52 ")
	self.m_getRewardBtn :setControlName( "this CFirstTopupGiftView self.m_getRewardBtn 53 ")

    self.m_getRewardBtn :setFontSize( 24)
    self.m_getRewardBtn :setColor( ccc4( 255,255,255,255 ) )
    self.m_closeBtn 	:setTag( CFirstTopupGiftView.TAG_CLOSE )
    self.m_topUpBtn 	:setTag( CFirstTopupGiftView.TAG_TOPUP )
    self.m_getRewardBtn :setTag( CFirstTopupGiftView.TAG_GETREWARD )
    self.m_closeBtn 	:registerControlScriptHandler( local_btnTouchCallback, "this CFirstTopupGiftView self.m_closeBtn 61 ")
    self.m_topUpBtn 	:registerControlScriptHandler( local_btnTouchCallback, "this CFirstTopupGiftView self.m_topUpBtn 62 ")
    self.m_getRewardBtn :registerControlScriptHandler( local_btnTouchCallback, "this CFirstTopupGiftView self.m_getRewardBtn 63 ")

    if tonumber(self.m_subId) == 0 then 
    	self.m_getRewardBtn : setTouchesEnabled( false )
    end

    self.m_mainContainer :addChild( self.m_closeBtn )
    self.m_mainContainer :addChild( self.m_topUpBtn )
    self.m_mainContainer :addChild( self.m_getRewardBtn )

	----------------------------
	--首充活动介绍
	----------------------------
	self.m_noticImg = CSprite :createWithSpriteFrameName("firstecharge_word.png")
    self.m_noticImg : setControlName( "this CFirstTopupGiftView self.m_noticImg 36 ")
	self.m_mainContainer : addChild( self.m_noticImg )

	----------------------------
	--奖励信息块
	----------------------------
	self.m_rewardContainer = CContainer :create()
    self.m_rewardContainer : setControlName( "this is CFirstTopupGiftView self.m_rewardContainer 88" )
    self.m_mainContainer      : addChild( self.m_rewardContainer)

    local rewardBgSize= CCSizeMake( 504, 188)
    self.m_rewardBg   = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_rewardBg   : setControlName( "this CFirstTopupGiftView self.m_rewardBg 93 ")
	self.m_rewardBg   : setPreferredSize( rewardBgSize )
	self.m_rewardContainer : addChild( self.m_rewardBg )

	self.m_rewardTitle = CCLabelTTF :create( "奖励内容", "Arial", 23)
	self.m_rewardTitle : setFontSize( 25 )
	self.m_rewardTitle : setColor( ccc4( 255,255,255,255 ) )
    self.m_rewardContainer  : addChild( self.m_rewardTitle )

    self.m_rewardLayout = CHorizontalLayout:create()
	self.m_rewardLayout :setCellSize(CCSizeMake( 90,90))
	self.m_rewardLayout :setCellHorizontalSpace(35)
	self.m_rewardLayout :setCellVerticalSpace(1)
	self.m_rewardLayout :setLineNodeSum(4)
	self.m_rewardLayout :setColumnNodeSum(1)
	self.m_rewardContainer :addChild( self.m_rewardLayout )

	local function local_goodstTouchCallback( eventType, obj, touches)
        return self :goodstTouchCallback( eventType, obj, touches)
    end

    local gifiInfo_children = self.m_giftInfo:children()

	for i=1,4,1 do
		self.m_rewardGoodsIcon    = {}
		self.m_rewardGoodsIcon[i] = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
		self.m_rewardGoodsIcon[i] : setControlName("this CFirstTopupGiftView self.m_rewardGoodsIcon[i] 116 ")
		self.m_rewardLayout 	  : addChild( self.m_rewardGoodsIcon[i] )

		local itemChildren = gifiInfo_children:get( 0,"virtues" ):children()
		if i <= itemChildren:getCount("virtue") then 
			local goodsId    = tonumber( itemChildren:get( i-1,"virtue" ):getAttribute("id") )
			local goodsCount = tonumber( itemChildren:get( i-1,"virtue" ):getAttribute("count") )
			self.m_rewardGoodsIcon[i] : setTouchesMode( kCCTouchesAllAtOnce )
			self.m_rewardGoodsIcon[i] : registerControlScriptHandler( local_goodstTouchCallback, "this CFirstTopupGiftView self.m_rewardGoodsIcon[i] 117 ")
			self.m_rewardGoodsIcon[i] : setTag(goodsId)
			-- local icon = CIcon :createWithSpriteFrameName("firstecharge_woman_icon.png")

			local count     = "*"..tostring( goodsCount )
			local goodsNode = self :getGoodsNode( goodsId )
			local icon = CIcon :create("Icon/i"..goodsNode:getAttribute("icon")..".jpg")
			self.m_rewardGoodsIcon[i] : addChild( icon,0 )

			table.insert( self.m_createResStrList, "Icon/i"..goodsNode:getAttribute("icon")..".jpg" )

			local btnSize    = self.m_rewardGoodsIcon[i]:getPreferredSize()
            local countLabel = CCLabelTTF :create( count,"Arial",18 )
            countLabel :setAnchorPoint( ccp(1,0) )
            countLabel :setPosition( ccp( btnSize.width/2-5, -btnSize.height/2+5 ) )
            self.m_rewardGoodsIcon[i] :addChild( countLabel , 10 )
        else

        	local Icon = CSprite:createWithSpriteFrameName( "general_props_underframe.png" )
            Icon   : setControlName( "this CFirstTopupGiftView Icon 39 ")
            self.m_rewardGoodsIcon[i] : addChild( Icon, -10 )
		end
	end

end

function CFirstTopupGiftView.Create_effects_button( self,obj)
    
    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end
    if obj ~= nil then
        local effectsCCBI = CMovieClip:create( "CharacterMovieClip/effects_button.ccbi" )
        effectsCCBI       : setControlName( "this CCBI Create_effects_activity CCBI")
        effectsCCBI       : registerControlScriptHandler( animationCallFunc)
        obj               : addChild(effectsCCBI,1000)
    end
end

function CFirstTopupGiftView.loadResources(self)

	CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("firstTopupGiftResources/FirstGiftResources.plist");
	CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("Shop/ShopReSources.plist")
    
end

function CFirstTopupGiftView.unloadResources(self)

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("firstTopupGiftResources/FirstGiftResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("Shop/ShopReSources.plist")

    CCTextureCache :sharedTextureCache():removeTextureForKey("firstTopupGiftResources/FirstGiftResources.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("Shop/ShopReSources.pvr.ccz")
 
    _G.Config :unload( "config/sales_sub.xml")

    _G.g_unLoadIconSources:unLoadAllIconsByNameList( self.m_createResStrList )
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()

end

function CFirstTopupGiftView.layout(self, _mainSize)
	----------------------------
	--活动背景
	----------------------------
	self.m_mainContainer : setPosition(ccp( self.m_winSize.width/2-_mainSize.width/2, 0 ))
	self.m_background    : setPosition(ccp(self.m_winSize.width*0.5,self.m_winSize.height*0.5))
	self.m_mainBg 	  	 : setPosition(ccp(_mainSize.width*0.5,_mainSize.height*0.5))
	self.m_meiNvimg   	 : setPosition(ccp(_mainSize.width-158,263))

	----------------------------
	--关闭 充值按钮 领取奖励按钮
	----------------------------
	local closeBtnSize  = self.m_closeBtn :getContentSize()
	self.m_closeBtn 	: setPosition(ccp(_mainSize.width-closeBtnSize.width/2,_mainSize.height-closeBtnSize.height/2)) 
	self.m_topUpBtn 	: setPosition(ccp( 310, 330)) 
	self.m_getRewardBtn : setPosition(ccp( 310, 50 )) 

	----------------------------
	--首充活动介绍
	----------------------------
	self.m_noticImg : setPosition(ccp( 315, 500))

	----------------------------
	--奖励信息块
	----------------------------
	local rewardBgSize     = self.m_rewardBg :getPreferredSize()
	self.m_rewardTitle 	   : setAnchorPoint( ccp( 0,0.5 ) )
	self.m_rewardContainer : setPosition(ccp( 0  , 0  ))
	self.m_rewardBg        : setPosition(ccp( 315, 190))
	self.m_rewardTitle 	   : setPosition(ccp( 81 , 250))
	self.m_rewardLayout    : setPosition(     81 , 170)

end

--初始化数据成员
function CFirstTopupGiftView.initParams( self, _id, _subId)
	print("initParams-->",self)
    _G.pFirstTopupGiftMediator = CFirstTopupGiftMediator(self)
    controller :registerMediator(_G.pFirstTopupGiftMediator)--先注册后发送 否则会报错    
 	
 	self.m_giftId   = _id
 	self.m_subId    = _subId
 	self.m_giftInfo = self : getGiftXml(_id)

 	self.m_createResStrList = {}

 	self : sendRuquestMessage()
end

--释放成员
function CFirstTopupGiftView.realeaseParams( self)
    
end

function CFirstTopupGiftView.init(self, _mainSize, _id, _subId)
	--加载资源
	self:loadResources()
	--初始化数据
    self:initParams(_id, _subId)
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)
end

function CFirstTopupGiftView.scene(self, _id , _subId)
	self.m_winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, self.m_winSize.height )
	self.m_scenelayer = CCScene:create()
	self:init( _mainSize , _id, _subId)
	return self.m_scenelayer
end


--*****************
--读取首充礼包数据
--*****************
function CFirstTopupGiftView.getGiftXml( self, _activityId)

	_G.Config :load( "config/sales_sub.xml")

    local giftData = _G.Config.sales_sub :selectSingleNode( "sales_subs[0]/sales_sub[@id="..tostring(_activityId).."]")

    -- for k,v in pairs(giftData:children():get(0,"virtues")virtue) do
    --     print("物品id  ",k,v.id)
    -- end

    return giftData
end

function CFirstTopupGiftView.getGoodsNode( self, _goodsID )

	_G.Config :load( "config/goods.xml")

	local goodsData = _G.Config.goodss :selectSingleNode( "goods[@id="..tostring(_goodsID).."]")

	return goodsData
end


--************************
--按钮回调
--************************
--关闭 充值 领取奖励 单击回调
function CFirstTopupGiftView.btnTouchCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 
			local tag = obj:getTag()
			if tag == CFirstTopupGiftView.TAG_CLOSE then
				if _G.pFirstTopupGiftMediator ~= nil then
					controller :unregisterMediator(_G.pFirstTopupGiftMediator)
					_G.pFirstTopupGiftMediator = nil
				end
				CCDirector:sharedDirector():popScene()
				self:unloadResources()
			elseif tag == CFirstTopupGiftView.TAG_TOPUP then
				--充值
				print("充值啦")
                --[[
				local function topUpYesCallBack( )
		            self : gotoTopUpView()
		        end
		        
		        --确认框
		        self.PopBox = CPopBox() --初始化
                self.m_topUpPopBoxLayer = self.PopBox : create(topUpYesCallBack,"是否进行充值?",0)
                self.m_topUpPopBoxLayer : setPosition(-20,0)
                self.m_scenelayer       : addChild(self.m_topUpPopBoxLayer)
                --]]
                self : gotoTopUpView()
                
			elseif tag == CFirstTopupGiftView.TAG_GETREWARD then
				--领取奖励
				print("领取奖励啦")
				self : sendGetReWardMessage()
				self.m_getRewardBtn : setTouchesEnabled( false )
			end
		end
		
	end
end

--物品展示 单击回调
function CFirstTopupGiftView.goodstTouchCallback(self, eventType, obj, touches)
	if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.goodsId     = obj :getTag()
                break
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
           return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID and self.goodsId == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

                	local goodsId = obj:getTag()

                	local _position = {}
                    _position.x = touch2Point.x
                    _position.y = touch2Point.y

                    local  temp   = _G.g_PopupView :createByGoodsId( goodsId, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position)
				    self.m_scenelayer :addChild( temp) 

                	self.touchID   = nil
                	self.goodsId   = nil
                end
            end
        end
	end
end


--************************
--确认框 按钮回调
--************************
--确认充值
function CFirstTopupGiftView.gotoTopUpView( self )
	-- print("跳转到充值界面啦")
	-- require "view/GMWin/DevelopTool"
 --    local tool = CDevelopTool : scene();
 --    CCDirector : sharedDirector () : pushScene(tool);
 	--local _rechargeScene = CRechargeScene:create()
 	--CCDirector:sharedDirector():pushScene(_rechargeScene)
    
    if _G.pFirstTopupGiftMediator ~= nil then
        controller :unregisterMediator(_G.pFirstTopupGiftMediator)
        _G.pFirstTopupGiftMediator = nil
    end
    CCDirector:sharedDirector():popScene()
    self:unloadResources()

    local command = CPayCheckCommand( CPayCheckCommand.ASK )
    controller :sendCommand( command )
end

--取消充值
--[[
function CFirstTopupGiftView.topUpCancelView( self )
	print("取消充值")
	if _G.pFirstTopupGiftMediator ~= nil then
		controller :unregisterMediator(_G.pFirstTopupGiftMediator)
		_G.pFirstTopupGiftMediator = nil
	end
	CCDirector:sharedDirector():popScene()
end
]]


--************************
--发送协议
--************************
--请求是否可以领取
function CFirstTopupGiftView.sendRuquestMessage( self )
	require "common/protocol/auto/REQ_CARD_SALES_ASK"
	local msg = REQ_CARD_SALES_ASK()
	CNetwork : send( msg )
end

--领取奖励
function CFirstTopupGiftView.sendGetReWardMessage( self )
	require "common/protocol/auto/REQ_CARD_SALES_GET"
	local msg = REQ_CARD_SALES_GET()
	msg : setId( tonumber(_G.Constant.CONST_RECHARGE_SALES_FIRST_PREPAID) )
	msg : setIdStep( self.m_subId )
	CNetwork : send( msg )
end







--************************
--mediator控制的方法
--************************
--可领取 返回
function CFirstTopupGiftView.canGetCallBackForMediator( self, _subId )
	self.m_getRewardBtn : setTouchesEnabled( true )
	self.m_subId = _subId
end

--领取奖励 返回
function CFirstTopupGiftView.getRewardCallBackForMediator( self )
	----领取成功 移除首充礼包 Icon

	self.m_getRewardBtn : setTouchesEnabled( false )

	local _wayCommand = CActivityIconCommand(CActivityIconCommand.REMOVE)
	_wayCommand : setOtherData( tonumber(_G.Constant.CONST_RECHARGE_SALES_FIRST_PREPAID) )
	controller:sendCommand(_wayCommand)
end

function CFirstTopupGiftView.createMessageBox(self,_msg) --通用提示框
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_mainContainer   : addChild(BoxLayer,1000)
end
