--*********************************
--2013-8-8 by 陈元杰
--每日一箭主界面-COneArrowEveryDayView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "mediator/OneArrowEveryDayMediator"
require "view/ErrorBox/ErrorBox"
--require "common/Constant"

COneArrowEveryDayView = class(view, function(self)

end)

--************************
--常量定义
--************************
-- button的Tag值
COneArrowEveryDayView.TAG_CLOSE           = 201


-- 方向direction
COneArrowEveryDayView.LEFT  = 1
COneArrowEveryDayView.RIGHT = 2
COneArrowEveryDayView.UP    = 3
COneArrowEveryDayView.DOWN  = 4

-- ccColor3B 常量
COneArrowEveryDayView.RED   = ccc4(255,0,0,255)
COneArrowEveryDayView.GOLD  = ccc4(255,255,0,255)
COneArrowEveryDayView.GREEN = ccc4(120,222,66,255)

function COneArrowEveryDayView.initView( self, _mainSize )

	local _winSize = CCDirector:sharedDirector():getVisibleSize()

	local function local_bgTouchesCallBacl( eventType, obj, touches )
		if eventType == "TouchesBegan" then
			_G.g_PopupView:reset()
		end
	end
	
	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this COneArrowEveryDayView self.m_mainContainer 39 ")
    self.m_scenceLayer   : addChild( self.m_mainContainer )

    self.m_mainBackground = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_mainBackground : setControlName( "this COneArrowEveryDayView self.m_mainBackground 39 ")
	self.m_mainBackground : setPreferredSize( _winSize )
	self.m_mainBackground : setTouchesMode( kCCTouchesAllAtOnce )
    self.m_mainBackground : setTouchesEnabled( true)
	self.m_mainBackground : registerControlScriptHandler(local_bgTouchesCallBacl,"this COneArrowEveryDayView self.m_mainBackground 184 ")
	self.m_mainContainer  : addChild( self.m_mainBackground )

	----------------------------
	--活动背景
	----------------------------
	self.m_background = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_background : setControlName( "this COneArrowEveryDayView self.m_background 39 ")
	self.m_background : setPreferredSize( _mainSize )

	self.m_rewardBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_rewardBg : setControlName( "this COneArrowEveryDayView self.m_rewardBg 43 ")
	self.m_rewardBg : setPreferredSize( CCSizeMake( 280, 458) )

	self.m_rewardLineBg = CSprite :createWithSpriteFrameName("general_dividing_line.png",CCRectMake( 200,0,3,3 ))
    self.m_rewardLineBg : setControlName( "this COneArrowEveryDayView self.m_rewardLineBg 47 ")
	self.m_rewardLineBg : setPreferredSize( CCSizeMake( 300, 4) )

	self.m_arrowBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
	self.m_arrowBg : setPreferredSize( CCSizeMake( 535, 458) )
	self.m_arrowBg : setControlName( "this COneArrowEveryDayView self.m_arrowBg 51 ")

	self.m_downBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
	self.m_downBg : setPreferredSize( CCSizeMake( 825, 145) )
	self.m_downBg : setControlName( "this COneArrowEveryDayView self.m_downBg 51 ")

	self.m_largeRewardLine = CSprite :createWithSpriteFrameName("general_dividing_line.png")
	self.m_largeRewardLine : setControlName( "this COneArrowEveryDayView self.m_largeRewardLine 54 ")

	self.m_mainContainer : addChild( self.m_background )
	self.m_mainContainer : addChild( self.m_rewardBg )
	self.m_mainContainer : addChild( self.m_rewardLineBg )
	self.m_mainContainer : addChild( self.m_arrowBg )
	self.m_mainContainer : addChild( self.m_downBg )
	self.m_mainContainer : addChild( self.m_largeRewardLine )

	local function local_closeBtnCallback(eventType,obj,x,y)
		return self:closeBtnCallback(eventType,obj,x,y)
	end

	----------------------------
	--关闭 按钮
	----------------------------
	self.m_closeBtn	  = CButton :createWithSpriteFrameName( "", "general_close_normal.png")
	self.m_closeBtn   :setControlName( "this COneArrowEveryDayView self.m_closeBtn 70 ")
    self.m_closeBtn   :setTag( COneArrowEveryDayView.TAG_CLOSE )
    self.m_closeBtn   :registerControlScriptHandler( local_closeBtnCallback, "this COneArrowEveryDayView self.m_closeBtn 72 ")
    self.m_mainContainer :addChild( self.m_closeBtn )


    --xml节点
    local rewardNodeList  = _G.Config.arrow_daily_items :selectSingleNode("arrow_daily_itemss[0]"):children()
	local rewardNodeCount = rewardNodeList:getCount("arrow_daily_items")

	----------------------------
	--上期至尊大奖得主
	----------------------------
	self.m_maxRewardBG = CSprite :createWithSpriteFrameName( "general_equip_frame.png" )

	self.m_maxRewardImg = CSprite :createWithSpriteFrameName( "arrow_daily_word_sqzzdz.png" )
	self.m_maxNoticLabel  = CCLabelTTF :create( "上期无获得至尊大奖者", "Arial", 20)
	self.m_maxNoticLabel  : setColor( COneArrowEveryDayView.GOLD )

	self.m_maxRewardIcon = CSprite :create( "Icon/i"..rewardNodeList:get(0,"arrow_daily_items"):getAttribute("items_icon")..".jpg" )
	self.m_maxRewardIcon : setControlName( "this COneArrowEveryDayView self.m_maxRewardIcon 84 ")

	self.m_maxRewardBG   :addChild( self.m_maxRewardIcon )
	self.m_mainContainer :addChild( self.m_maxRewardBG )
	self.m_mainContainer :addChild( self.m_maxNoticLabel )
	self.m_mainContainer :addChild( self.m_maxRewardImg )

	table.insert(self.m_createResStrList,"Icon/i"..rewardNodeList:get(0,"arrow_daily_items"):getAttribute("items_icon")..".jpg")

    ----------------------------
	--获得大奖的奖励信息
	----------------------------
	-- self.m_largeTitleLb = CCLabelTTF :create( "最近获得大奖记录", "Arial", 21)
	-- self.m_largeTitleLb : setColor( COneArrowEveryDayView.GOLD )
	-- self.m_mainContainer   : addChild( self.m_largeTitleLb )

	self.m_largeRewardContainer = CContainer :create()
    self.m_largeRewardContainer : setControlName( "this is COneArrowEveryDayView self.m_largeRewardContainer 98" )
    self.m_mainContainer : addChild( self.m_largeRewardContainer)

	----------------------------
	--右边信息
	----------------------------
	self.m_nowGoldTitleImg = CSprite 	:createWithSpriteFrameName( "arrow_daily_word_dqjc.png" )
	self.m_nowGoldLabel    = CCLabelTTF :create( "9999999999", "Arial", 24)
	self.m_freeNumLable    = CCLabelTTF :create( "今天剩余参与次数 X 次", "Arial", 20)
	self.m_freeGoldLabel   = CCLabelTTF :create( "每次需 ".._G.Constant.CONST_ARROW_DAILY_MONEY_UES.." 美刀", "Arial", 20)
	self.m_buyNoticLabel   = CCLabelTTF :create( "每次需 ".._G.Constant.CONST_ARROW_DAILY_ADD_RMB_USE.." 钻石", "Arial", 20)
	self.m_buySurplusLabel = CCLabelTTF :create( "本轮剩余钻石参与次数 X次", "Arial", 20)
	
	self.m_freeNumLable    :setColor( COneArrowEveryDayView.GOLD )
	self.m_freeGoldLabel   :setColor( COneArrowEveryDayView.GOLD )
	self.m_buyNoticLabel   :setColor( COneArrowEveryDayView.RED )
	self.m_buySurplusLabel :setColor( COneArrowEveryDayView.RED )

	self.m_mainContainer : addChild( self.m_freeNumLable )
	self.m_mainContainer : addChild( self.m_freeGoldLabel )
	self.m_mainContainer : addChild( self.m_buyNoticLabel )
	self.m_mainContainer : addChild( self.m_buySurplusLabel )
	self.m_mainContainer : addChild( self.m_nowGoldTitleImg)
	self.m_mainContainer : addChild( self.m_nowGoldLabel )

	----------------------------
	--挡箭牌(射箭的图标)
	----------------------------
	local function local_shootCallback( eventType, obj, x , y)
        return self :shootCallback( eventType, obj, x , y)
    end

    self.m_arrowContainer = CContainer :create()
    self.m_arrowContainer : setControlName( "this is COneArrowEveryDayView self.m_arrowContainer 130" )
    self.m_mainContainer     : addChild( self.m_arrowContainer)

    local cellSize1 = CCSizeMake(90,90)
    self.m_arrowLayout = CHorizontalLayout:create()
	self.m_arrowLayout : setCellSize( cellSize1 )
	self.m_arrowLayout : setCellHorizontalSpace(20)
	self.m_arrowLayout : setCellVerticalSpace(20)
	self.m_arrowLayout : setLineNodeSum(4)
	self.m_arrowLayout : setColumnNodeSum(3)
	self.m_arrowLayout : setVerticalDirection(false)	 --垂直  从上至下
	self.m_arrowContainer : addChild(self.m_arrowLayout )

	print("COneArrowEveryDayView -      111")
	for i=1,12 do
		local spriteName
		if i<10 then
			spriteName = "arrow_daily_picture_0"..tostring(i)..".png"
		else
			spriteName = "arrow_daily_picture_"..tostring(i)..".png"
		end

		local Container = CContainer:create()
		Container:setControlName( "this COneArrowEveryDayView Container 631 " )
		self.m_arrowLayout : addChild(Container)

		local arrowBtn = CButton :createWithSpriteFrameName("",spriteName)
		arrowBtn : setControlName( "this COneArrowEveryDayView arrowBtn 145 ")
		arrowBtn : setTag(i)
		arrowBtn : registerControlScriptHandler(local_shootCallback,"this COneArrowEveryDayView arrowBtn 149 ")
		Container : addChild(arrowBtn)

		local icon = CSprite :createWithSpriteFrameName( "arrow_daily_click.png" )
		arrowBtn :addChild( icon, 10, 999 )
	end

	print("COneArrowEveryDayView -      111")

	----------------------------
	--可获得奖品 信息
	----------------------------
	local function local_canGetGoodsTouchCallback( eventType, obj, x , y)
        return self :canGetGoodsTouchCallback( eventType, obj, x , y)
    end

	self.m_rewardContainer = CContainer :create()
    self.m_rewardContainer : setControlName( "this is COneArrowEveryDayView self.m_rewardContainer 161" )
    self.m_mainContainer      : addChild( self.m_rewardContainer)

    self.m_rewardLabel = CCLabelTTF :create( "可获得奖品 : ", "Arial", 20)
    self.m_rewardContainer : addChild( self.m_rewardLabel )

    local cellSize2 = CCSizeMake( 90,90)
	self.m_rewardLayout = CHorizontalLayout:create()
	self.m_rewardLayout : setCellSize( cellSize2 )
	self.m_rewardLayout : setCellHorizontalSpace(25)
	self.m_rewardLayout : setCellVerticalSpace(1)
	self.m_rewardLayout : setLineNodeSum(7)
	self.m_rewardLayout : setColumnNodeSum(1)
	self.m_rewardContainer : addChild( self.m_rewardLayout )


	print("COneArrowEveryDayView -      333")
	self.m_rewardGoodsBtn = {}
	for i=1,7 do
		self.m_rewardGoodsBtn[i] = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
		self.m_rewardGoodsBtn[i] : setControlName("this COneArrowEveryDayView self.m_rewardGoodsBtn[i] 179 ")
		self.m_rewardLayout : addChild( self.m_rewardGoodsBtn[i] )

		if i < rewardNodeCount then 
			self.m_rewardGoodsBtn[i] : setTag( rewardNodeList:get(i-1,"arrow_daily_items"):getAttribute("items_id") )
			-- self.m_rewardGoodsBtn[i] : setTouchesMode( kCCTouchesAllAtOnce )
   --      	self.m_rewardGoodsBtn[i] : setTouchesEnabled( true)
			self.m_rewardGoodsBtn[i] : registerControlScriptHandler(local_canGetGoodsTouchCallback,"this COneArrowEveryDayView self.m_rewardGoodsBtn[i] 184 ")

			-- local goodsIcon = CIcon  : create("Icon/i"..tostring( rewardNodeList:get(i-1,"arrow_daily_items"):getAttribute("")items_icon )..".jpg")
			local goodsIcon = CSprite :create( "Icon/i"..rewardNodeList:get(i-1,"arrow_daily_items"):getAttribute("items_icon")..".jpg" )
			self.m_rewardGoodsBtn[i] : addChild( goodsIcon ) 

			table.insert(self.m_createResStrList,"Icon/i"..rewardNodeList:get(i-1,"arrow_daily_items"):getAttribute("items_icon")..".jpg")
			-- goodsIcon : setScale(1.2)
		end
	end

	print("COneArrowEveryDayView -      444")
end

function COneArrowEveryDayView.loadResources(self)
	CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("OneArrowEveryDayResources/OneArrowEveryDayResources.plist")
	CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
	--加载xml资源
	self :loadOneArrowEveryDayXml()
end

function COneArrowEveryDayView.unloadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("BarResources/BarResources.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("BarResources/BarResources.pvr.ccz")

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("OneArrowEveryDayResources/OneArrowEveryDayResources.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("OneArrowEveryDayResources/OneArrowEveryDayResources.pvr.ccz")

    --删除xml资源
	self :unloadOneArrowEveryDayXml()

	_G.g_unLoadIconSources:unLoadAllIconsByNameList( self.m_createResStrList )

	self.m_createResStrList = {}
    
    if self.m_touchActionCCBI ~= nil then
    	self.m_touchActionCCBI : removeFromParentAndCleanup( true )
    	self.m_touchActionCCBI = nil
    end

end

function COneArrowEveryDayView.layout(self, _mainSize)

	local _winSize = CCDirector:sharedDirector():getVisibleSize()

    self.m_mainBackground :setPosition(ccp( _mainSize.width/2 , _mainSize.height/2))
	self.m_mainContainer  :setPosition(ccp( _winSize.width/2 - _mainSize.width/2 , 0))

	----------------------------
	--活动背景
	----------------------------
	local backgroundSize = self.m_background    :getPreferredSize()

	self.m_background    : setPosition(ccp(_mainSize.width*0.5 ,_mainSize.height*0.5))
	self.m_rewardBg 	 : setPosition(ccp( 156, 395))
	self.m_rewardLineBg  : setPosition(ccp( 156, 358))
	self.m_arrowBg 		 : setPosition(ccp( 572, 395))
	self.m_downBg        : setPosition(ccp( _mainSize.width*0.5, 88))

	----------------------------
	--关闭按钮
	----------------------------
	local closeBtnSize  = self.m_closeBtn :getContentSize()
	self.m_closeBtn : setPosition(ccp(backgroundSize.width-closeBtnSize.width/2,backgroundSize.height-closeBtnSize.height/2)) 

	----------------------------
	--上期至尊大奖得主
	----------------------------
	self.m_maxNoticLabel  : setAnchorPoint(ccp(0.5,1))
	self.m_maxRewardImg   : setPosition(ccp( 156 , 600)) 
	self.m_maxNoticLabel  : setPosition(ccp( 156 , 458)) 
	self.m_maxRewardBG    : setPosition(ccp( 156 , 523)) 
	--self.m_nocitLabel     : setHorizontalAlignment(kCCTextAlignmentLeft) --左对齐

	----------------------------
	--获得大奖的奖励信息
	----------------------------
	-- self.m_largeTitleLb : setPosition(ccp( 156 ,_mainSize.height*0.56)) 

	----------------------------
	--右边信息
	----------------------------
	self.m_freeNumLable    :setAnchorPoint(ccp(0,0.5))
	self.m_freeGoldLabel   :setAnchorPoint(ccp(0,0.5))
	self.m_buyNoticLabel   :setAnchorPoint(ccp(0,0.5))
	self.m_buySurplusLabel :setAnchorPoint(ccp(0,0.5))
	self.m_nowGoldLabel    :setAnchorPoint(ccp(0,0.5))

	self.m_nowGoldTitleImg : setPosition(ccp( 477 , 600)) 
	self.m_nowGoldLabel    : setPosition(ccp( 547 , 598.5)) 

	self.m_freeNumLable    : setPosition(ccp( 317 , 230)) 
	self.m_freeGoldLabel   : setPosition(ccp( 317 , 197)) 
	self.m_buyNoticLabel   : setPosition(ccp( 580 , 197)) 
	self.m_buySurplusLabel : setPosition(ccp( 580 , 230)) 
	

	----------------------------
	--挡箭牌(射箭的图标)
	----------------------------
	self.m_arrowLayout : setPosition( 350 , 523 )

	----------------------------
	--可获得奖品 信息
	----------------------------
	self.m_rewardLabel  : setAnchorPoint(ccp(0,0.5))
	self.m_rewardLabel  : setPosition(ccp( 35, 137 )) 
	self.m_rewardLayout : setPosition( 35 , 72 )
end

--初始化数据成员
function COneArrowEveryDayView.initParams( self)
	--注册mediator
    _G.pOneArrowEveryDayMediator = COneArrowEveryDayMediator(self)
    controller :registerMediator(_G.pOneArrowEveryDayMediator)--先注册后发送 否则会报错    

    self.m_createResStrList = {}

    --是否射箭中
    self.m_shootIng  = false

    --是否初始化
    self.m_isInit    = false

    --是否重置
    self.m_resetData = false

 	--请求界面信息
 	self :sendRquestViewMessage()
end

--释放成员
function COneArrowEveryDayView.realeaseParams( self)
	--反注册mediator
    if _G.pOneArrowEveryDayMediator ~= nil then
		controller :unregisterMediator(_G.pOneArrowEveryDayMediator)
		_G.pOneArrowEveryDayMediator = nil
	end
end

function COneArrowEveryDayView.init(self, _mainSize)
	--加载资源
	self:loadResources()
	--初始化数据
    self:initParams()
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)
end

function COneArrowEveryDayView.scene(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )
	self.m_scenceLayer = CCScene:create()
	self:init( _mainSize, _data)
	return self.m_scenceLayer
end





--*****************
--xml管理
--*****************
--加载xml文件
function COneArrowEveryDayView.loadOneArrowEveryDayXml( self )
	_G.Config :load( "config/arrow_daily_items.xml")
	_G.Config :load( "config/goods.xml")
end

function COneArrowEveryDayView.unloadOneArrowEveryDayXml( self )
	_G.Config :unload( "config/arrow_daily_items.xml")
end

--根据物品Id查找<特殊物品>节点
function COneArrowEveryDayView.getGoldGoodsNodeForXml( self, _goodsId )

    local goodsNode = _G.Config.arrow_daily_items :selectSingleNode( "arrow_daily_itemss[0]/arrow_daily_items[@items_id="..tostring(_goodsId).."]" )
    
    print("=======================================")
    print("items_name:"..goodsNode:getAttribute("items_name") )
    print("items_dec:"..goodsNode:getAttribute("items_dec") )
    print("items_icon:"..goodsNode:getAttribute("items_icon") )
    print("=======================================")

    return goodsNode

end

--根据物品Id查找<普通物品>节点
function COneArrowEveryDayView.getGoodsNodeForXml( self, _goodsId )

    local goodsNode = _G.Config.goodss :selectSingleNode( "goods[@id="..tostring(_goodsId).."]" )

    return goodsNode

end


function COneArrowEveryDayView.showSureBox( self, _msg )

	local surebox  = CErrorBox()
    local BoxLayer = surebox : create(_msg)
    self.m_scenceLayer : addChild(BoxLayer,1000)

end



--************************
--按钮回调
--************************
--关闭 单击回调
function COneArrowEveryDayView.closeBtnCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
			self :realeaseParams()
			CCDirector:sharedDirector():popScene()
			self :unloadResources()
		end
	end
end

--(挡箭牌)射箭 单击回调
function COneArrowEveryDayView.shootCallback(self, eventType, obj, x , y)
	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then

			if self.m_infoLayer ~= nil then 
				self.m_infoLayer :removeFromParentAndCleanup( true )
				self.m_infoLayer = nil
			end

			print("每日一箭啦  ->",obj:getTag())
			--是否有免费次数
			if self.m_freeTimes == nil then 
				self:showSureBox("服务器正忙,请稍等!")
			else

				if self.m_shootIng == false then

					local surplusCount = _G.g_GameDataProxy :getMaxCapacity() - _G.g_GameDataProxy :getGoodsCount() --背包剩余空间
					
					if surplusCount == 0 then
	                    self:showSureBox( "背包已满,请先清理" )
	                elseif self.m_freeTimes > 0 then 
						local mainProperty = _G.g_characterProperty : getMainPlay()
						local mygold = mainProperty :getGold()
						

						if tonumber(_G.Constant.CONST_ARROW_DAILY_MONEY_UES) < tonumber(mygold) then
							self :goTouchAction( obj )
							self :sendShootMessage( obj:getTag() )
							self.m_freeTimes = self.m_freeTimes - 1
						else
							self:showSureBox("美刀不足,招财可获得美刀!")
						end
						
					elseif self.m_buyTimesSurplus > 0 then 
						--有剩余购买次数 有弹出提示框 是否购买
						local function local_buyShootTimesCallBack()
							--获取钻石
				            local mainProperty = _G.g_characterProperty : getMainPlay()
				            local nDiamond     = mainProperty :getRmb() + mainProperty :getBindRmb()
				            if nDiamond < _G.Constant.CONST_ARROW_DAILY_ADD_RMB_USE then 
				            	self:showSureBox("钻石不足，充值可获得钻石!")
				            else
				            	self :goTouchAction( obj )
				            	self :sendShootMessage( obj:getTag() )
								self.m_buyTimesSurplus = self.m_buyTimesSurplus - 1
				            end
						end 

						self.PopBox = CPopBox() --初始化
		                self.m_buyShootPopBoxLayer = self.PopBox : create(local_buyShootTimesCallBack,"花费".._G.Constant.CONST_ARROW_DAILY_ADD_RMB_USE.."钻石再来一次?",0)
		                self.m_scenceLayer : addChild(self.m_buyShootPopBoxLayer)
		            else 
		            	self:showSureBox("今天没有剩余次数了!")
					end
				-- else
				-- 	self:showSureBox("正在处理,请稍等!")
				end
			end
	    end
	end
end

--可得到奖品展示 单击回调
function COneArrowEveryDayView.canGetGoodsTouchCallback(self, eventType, obj, x , y)
	if eventType == "TouchBegan" then
		--_G.g_PopupView :reset()
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
            --弹出物品Tips             

           	if self.m_infoLayer ~= nil then 
				self.m_infoLayer :removeFromParentAndCleanup( true )
				self.m_infoLayer = nil
			end

            local _position = {}
            _position.x = x
            _position.y = y

			local nodeSpacePoint = obj:convertToNodeSpaceAR(ccp(_position.x,_position.y)) -- 计算基于锚点的窗口坐标
			local _winSize  = CCDirector:sharedDirector():getVisibleSize()
			local _mainSize = CCSizeMake( 854, _winSize.height )
			local _nWidth   = _winSize.width/2 - _mainSize.width/2
			local objSize   = obj:getPreferredSize()
			local objPos    = CCPointMake( _position.x-nodeSpacePoint.x-objSize.width/2-_nWidth, _position.y-nodeSpacePoint.y-objSize.height/2 ) -- 计算左下角坐标
			local objRect   = CCRectMake(objPos.x,objPos.y,objSize.width,objSize.height)
			local goodsId1  = obj:getTag()
			local direction = COneArrowEveryDayView.UP
			
			-- print("物品展示啦  ->".."posX="..objPos.x.."       posX="..objPos.y.."     wid="..objSize.width.."     hei="..objSize.height)
			self :createGoodsInfoLayer( goodsId1, objRect, direction )
        end
    end
end


--物品展示 单击回调
function COneArrowEveryDayView.goodsTouchCallback(self, eventType, obj, x , y)
	if eventType == "TouchBegan" then
		--_G.g_PopupView :reset()
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
            --弹出物品Tips             
            if self.m_infoLayer ~= nil then 
				self.m_infoLayer :removeFromParentAndCleanup( true )
				self.m_infoLayer = nil
			end
			print("COME   IN")
            local _position = {}
            _position.x = x
            _position.y = y
            local index     = tonumber(obj:getTag())
            local goodsId   = self.m_touchInfoList[index]
            local _winSize  = CCDirector:sharedDirector():getVisibleSize()
			local _mainSize = CCSizeMake( 854, _winSize.height )

			if goodsId > 1000 then 
				print("tips    SHOW"..goodsId)
				local temp = _G.g_PopupView :createByGoodsId( goodsId, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position )
				self.m_scenceLayer :addChild( temp)

			else
				local nodeSpacePoint = obj:convertToNodeSpaceAR(ccp(_position.x,_position.y)) -- 计算基于锚点的窗口坐标
				local _nWidth   = _winSize.width/2 - _mainSize.width/2
				local objSize   = obj:getPreferredSize()
				local objPos    = CCPointMake( _position.x-nodeSpacePoint.x-objSize.width/2 - _nWidth, _position.y-nodeSpacePoint.y-objSize.height/2 ) -- 计算左下角坐标
				local objRect   = CCRectMake(objPos.x,objPos.y,objSize.width,objSize.height)
				
				local direction = COneArrowEveryDayView.LEFT
				self :createGoodsInfoLayer( goodsId, objRect, direction )
			end
        end
    end
end

--显示物品信息时的全屏点击回调
function COneArrowEveryDayView.goodsInfoTouchCallback(self, eventType, obj, x , y)
	if eventType == "TouchBegan" then
		return true
	elseif eventType == "TouchEnded" then
		local infobg = self.m_infoLayer :getChildByTag(100)
		if infobg:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then 
			--print("1点击在背景区域内")
		else 
			--print("2点击在背景区域外,清楚物品信息")
			self.m_infoLayer :removeFromParentAndCleanup( true )
			self.m_infoLayer = nil
		end
		
	end
end

function COneArrowEveryDayView.goTouchAction( self, _obj )

	if _obj == nil or self.m_isInit == false then
		return
	end

	if _obj : getChildByTag(999) == nil then
		return
	end

	-- local btnBg = _obj : getChildByTag(999)
	-- btnBg:setVisible( false )

	local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print("animationCallFunc  Enter")
            arg0 : play( "run" )
        -- elseif eventType == "AnimationComplete" then
        -- 	arg0 : play( "run" )
            -- CCMessageBox( "AnimationComplete","提示" )
        elseif eventType == "Exit" then
            print("animationCallFunc  Exit")
        end
    end

	self.m_touchActionCCBI = CMovieClip:create( "CharacterMovieClip/effects_arrow.ccbi" )
    self.m_touchActionCCBI : setControlName( "this COneArrowEveryDayView self.m_touchActionCCBI 84")
    self.m_touchActionCCBI : registerControlScriptHandler( animationCallFunc )
    _obj : addChild( self.m_touchActionCCBI, -10 )

end

--创建物品信息 参数: _goodsId:物品ID   _rect:物品的区域    _direction:相对位置
function COneArrowEveryDayView.createGoodsInfoLayer( self, _goodsId, _rect, _direction)

	if self.m_infoLayer ~= nil then 
		self.m_infoLayer :removeFromParentAndCleanup( true )
		self.m_infoLayer = nil
	end

	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )

	local function local_goodsInfoTouchCallback( eventType, obj, x , y)
		--显示物品信息时的全屏点击回调
		return self:goodsInfoTouchCallback( eventType, obj, x , y)
	end

    self.m_infoLayer = CFloatLayer :create()
    self.m_infoLayer : setTouchesEnabled( true )
    self.m_infoLayer : setFullScreenTouchEnabled( true )
    self.m_infoLayer : registerControlScriptHandler(local_goodsInfoTouchCallback,"this is COneArrowEveryDayView self.m_infoLayer 462")

    local bgSize = CCSizeMake(_mainSize.width*0.26,_mainSize.height*0.20)
    local infoBg = CSprite :createWithSpriteFrameName("general_tips_underframe.png")
    infoBg : setControlName( "this COneArrowEveryDayView infoBg 466 ")
	infoBg : setPreferredSize( bgSize )

	self.m_infoLayer : addChild( infoBg , 0, 100 )

	local goodNode  = nil
	local goodsName = nil
	local goodsInfo = nil

	goodNode  = self :getGoldGoodsNodeForXml( _goodsId )
	goodsName = goodNode:getAttribute("items_name")
	goodsInfo = goodNode:getAttribute("items_dec")


	local goodsNameLabel = CCLabelTTF :create( goodsName, "Arial", 22)
	local goodsInfoLabel = CCLabelTTF :create( goodsInfo,  "Arial", 18 )

	goodsNameLabel : setColor( COneArrowEveryDayView.GOLD )
	goodsInfoLabel : setColor( COneArrowEveryDayView.GREEN )

	goodsNameLabel : setPosition(ccp(0,bgSize.height/2-40))
	goodsInfoLabel : setPosition(ccp(0,-15))

	self.m_infoLayer : addChild( goodsNameLabel , 1 )
	self.m_infoLayer : addChild( goodsInfoLabel , 1 )

	local pWidth   = 35
	local infoSize = goodsInfoLabel:getContentSize()
	if infoSize.width > bgSize.width-pWidth then
		bgSize = CCSizeMake( infoSize.width+pWidth, bgSize.height )
		infoBg : setPreferredSize( bgSize )
	end

	local n_pos    = 12
	local position = CCPointMake( _rect.origin.x + _rect.size.width/2, _rect.origin.y + _rect.size.height/2) -- 中点坐标  -bgSize.height*1.165 
	if COneArrowEveryDayView.UP == _direction then 
		--显示在物品的上方
		position = CCPointMake( position.x, position.y + _rect.size.height/2 + bgSize.height/2 - n_pos )
	elseif COneArrowEveryDayView.DOWN == _direction then 
		--显示在物品的下方
		position = CCPointMake( position.x, position.y - _rect.size.height/2 - bgSize.height/2 + n_pos )
	elseif COneArrowEveryDayView.LEFT == _direction then 
		--显示在物品的左边
		position = CCPointMake( position.x - _rect.size.width/2 - bgSize.width/2 + n_pos, position.y + 2 )
	elseif COneArrowEveryDayView.RIGHT == _direction then 
		--显示在物品的右边
		position = CCPointMake( position.x + _rect.size.width/2 + bgSize.width/2 - n_pos, position.y + 2 )
	end
	self.m_infoLayer : show( self.m_mainContainer, position, 1 )
end





--************************
--发送协议
--************************
--请求界面
function COneArrowEveryDayView.sendRquestViewMessage( self )
	require "common/protocol/auto/REQ_SHOOT_REQUEST"
	local msg = REQ_SHOOT_REQUEST()
	CNetwork : send( msg )
end

--(挡箭牌)射箭
function COneArrowEveryDayView.sendShootMessage( self , _index)
	_G.pOneArrowEveryDayMediator :setIsShoot( true )

	require "common/protocol/REQ_SHOOT_SHOOTED"
	local msg = REQ_SHOOT_SHOOTED()
	msg :setPosition(tonumber(_index))
	CNetwork : send( msg )

	self.m_shootIng      = true
	self.transPrizeIndex = tonumber(_index) --记住射箭的位置
end








--************************
--mediator控制的方法 -- 刷新界面
--************************
--刷新至尊奖获得者
function COneArrowEveryDayView.resetMaxRewardLabel( self, _name, _gold )
	self.m_maxNoticLabel  :setString( "恭喜 ".._name.." \n获得至尊大奖\n共计 : ".._gold.."美刀")
end

--刷新最近获得大奖记录
function COneArrowEveryDayView.resetLargeRewardConTainer( self, _data )
	if self.m_largeRewardContainer ~= nil then
		self.m_largeRewardContainer : removeAllChildrenWithCleanup( true )
	end

	local _winSize = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )


	local fontSize = 19
	local fontName = "Arial"

	for i,v in ipairs(_data) do
		print(i,v.reward)
		local goodsNode 
		local goodsName
		local goodsColor

		if v.reward < 1000 then 
			goodsNode = self :getGoldGoodsNodeForXml( v.reward )
			goodsName = goodsNode:getAttribute("items_name") 
			goodsColor = ccc3( 255,255,0 )
		else
			goodsNode = self :getGoodsNodeForXml( v.reward )
			goodsName = goodsNode:getAttribute("name") 
			goodsColor = _G.g_ColorManager:getRGB( tonumber( goodsNode:getAttribute("name_color")  ) )
			if goodsColor == nil then
				goodsColor = ccc3( 255,255,0 )
			end
		end

		local nameLabel = CCLabelTTF :create( v.uname, fontName, fontSize)
		nameLabel : setColor( ccc3(255,255,0) )
		nameLabel : setAnchorPoint( ccp( 0,0.5 ) )
		self.m_largeRewardContainer :addChild( nameLabel )

		local getLabel   = CCLabelTTF :create( " 获得 ", fontName, fontSize)
		getLabel : setAnchorPoint( ccp( 0,0.5 ) )
		self.m_largeRewardContainer :addChild( getLabel )

		local goodsNameLb = CCLabelTTF :create( goodsName, fontName, fontSize)
		goodsNameLb : setAnchorPoint( ccp( 0,0.5 ) )
		goodsNameLb : setColor( goodsColor )
		self.m_largeRewardContainer :addChild( goodsNameLb )

		local goodsCountLb = CCLabelTTF :create( "*"..v.count, fontName, fontSize)
		goodsCountLb : setAnchorPoint( ccp( 0,0.5 ) )
		if v.reward >= 1000 then
			self.m_largeRewardContainer :addChild( goodsCountLb )
		end

		local pos_X    = 30
		local nameSize = nameLabel:getContentSize()
		local getSize  = getLabel :getContentSize()
		local goodsNameSize  = goodsNameLb:getContentSize()
		local goodsCountSize = goodsCountLb:getContentSize()
		local maxWidth = nameSize.width+getSize.width+goodsNameSize.width+goodsCountSize.width
		nameLabel : setPosition( ccp( pos_X, 325 - 33*(i-1) ) )
		getLabel  : setPosition( ccp( pos_X+nameSize.width, 325 - 33*(i-1) ) )
		goodsNameLb  : setPosition( ccp( pos_X+nameSize.width+getSize.width, 325 - 33*(i-1) ) )
		goodsCountLb : setPosition( ccp( pos_X+nameSize.width+getSize.width+goodsNameSize.width, 325 - 33*(i-1) ) )

	end
end

--刷新免费次数
function COneArrowEveryDayView.resetFreeTimesLabel( self, _freeTimes )
	self.m_freeTimes = tonumber(_freeTimes)
	self.m_freeNumLable :setString( "今天剩余参与次数 "..tostring(self.m_freeTimes).." 次" )
end

--刷新 购买次数金额及剩余购买次数
function COneArrowEveryDayView.resetBuyTimesSurplusLabel( self, _buyTimesSurplus )
	self.m_buyTimesSurplus = _buyTimesSurplus
	self.m_buySurplusLabel :setString( "本轮剩余钻石参与次数 "..self.m_buyTimesSurplus.." 次" )
end

--刷新奖池金额
function COneArrowEveryDayView.resetTotalGoldLabel( self, _totalGold )
	self.m_nowGoldLabel :setString( tostring(_totalGold) )
end

--收到数据  刷新界面前做的动作
function COneArrowEveryDayView.resetArrowLayout( self, _data )

	print("COneArrowEveryDayView.resetArrowLayout  111")

	-- if #_data == 0 then
	-- 	self.m_isInit = true
	-- 	return
	-- end

	local function local_resetArrow()
		return self:resetArrowLayout2( _data )
	end

	local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print("animationCallFunc  Enter")
            arg0 : play( "run" )
        elseif eventType == "AnimationComplete" then
        	--重新显示界面

        	--清除CCBI
        	if self.m_touchActionCCBI ~= nil then
        		self.m_touchActionCCBI : removeFromParentAndCleanup( true )
        		self.m_touchActionCCBI = nil
        	end

        	local_resetArrow()
        elseif eventType == "Exit" then
            print("animationCallFunc  Exit")
        end
    end

	local function local_createEffectCCBI()

		local parent = nil

		if self.m_touchActionCCBI ~= nil then
			--清除转圈的CCHI
			parent = self.m_touchActionCCBI : getParent()
			self.m_touchActionCCBI : removeFromParentAndCleanup( true )
			self.m_touchActionCCBI = nil
		end

		if parent ~= nil then
			--创建强化(爆炸)CCBI
			local bigParent = parent : getParent()
			bigParent:removeAllChildrenWithCleanup( true )
			self.m_touchActionCCBI = CMovieClip:create( "CharacterMovieClip/effects_strengthen.ccbi" )
		    self.m_touchActionCCBI : setControlName( "this COneArrowEveryDayView self.m_touchActionCCBI 84")
		    self.m_touchActionCCBI : registerControlScriptHandler( animationCallFunc )
		    bigParent : addChild( self.m_touchActionCCBI, 100 )
		end
	end

	if self.m_isInit == false or self.m_resetData == true then
		--初始化界面  不用延迟
		self.m_isInit = true
		local_resetArrow()
		return
	end

	--射箭 -- 延迟刷新界面
	if self.m_mainContainer ~= nil then
		self.m_mainContainer : performSelector( 1.2, local_createEffectCCBI )
	end
end

--刷新挡箭牌
function COneArrowEveryDayView.resetArrowLayout2( self, _data )

	print("COneArrowEveryDayView.resetArrowLayout  222")

	if self.m_arrowLayout ~= nil then 
		self.m_arrowLayout :removeAllChildrenWithCleanup( true )
	else
		return
	end

	_G.g_PopupView :reset()

	if self.m_resetData then
		-- 重置
		-- 锁屏
		local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
	    if isdis == true then
	    	CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
	    end
	end

	local function local_shootCallback( eventType, obj, x , y)
		--(挡箭牌)射箭 回调
        return self :shootCallback( eventType, obj, x , y)
    end

    local function local_goodsTouchCallback( eventType, obj, x , y)
    	--点击物品 回调
        return self :goodsTouchCallback( eventType, obj, x , y)
    end

    self.m_touchInfoList = {}

    local shootCount = 0
    
	for i=1,12 do
		local isBeShoot = false
		local goodId    = nil
		for j,v in ipairs(_data) do
			if v.position == i then
				isBeShoot = true
				goodId    = v.award
			end 
			if self.transPrizeIndex ~= nil then
				if v.position == self.transPrizeIndex then
					if tonumber(v.award) == _G.Constant.CONST_ARROW_DAILY_SUPREME_REWARD then
						self : addEffactCCBI()
					end 
				end
			end
		end

		local Container = CContainer:create()
		Container:setControlName( "this COneArrowEveryDayView Container 631 " )
		self.m_arrowLayout : addChild(Container)

		if isBeShoot then 
			self.m_touchInfoList[i] =  goodId
			print("v.award="..goodId)

			local goodsIcon
			
			if goodId < 1000 then 
				local goodsNode = self :getGoldGoodsNodeForXml( goodId )
				goodsIcon = goodsNode:getAttribute("items_icon") 
			else
				local goodsNode = self :getGoodsNodeForXml( goodId )
				goodsIcon = goodsNode:getAttribute("icon") 
			end

			local arrowGoodsBtn = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
			arrowGoodsBtn : setControlName( "this COneArrowEveryDayView arrowGoodsBtn 631 ")
			arrowGoodsBtn : setTag( i )
			-- arrowGoodsBtn : setTouchesMode( kCCTouchesAllAtOnce )
   --      	arrowGoodsBtn : setTouchesEnabled( true)
			arrowGoodsBtn : registerControlScriptHandler(local_goodsTouchCallback,"this COneArrowEveryDayView arrowGoodsBtn 633 ")
			Container : addChild(arrowGoodsBtn)

			local goodsIcon = CIcon : create( "Icon/i"..tostring( goodsIcon )..".jpg" )

			table.insert(self.m_createResStrList,"Icon/i"..tostring( goodsIcon )..".jpg")
			arrowGoodsBtn : addChild(goodsIcon)

			shootCount = shootCount + 1

		else
			self.m_touchInfoList[i] = 0

			local parent = CSprite:createWithSpriteFrameName("transparent.png")

			local spriteName
			if i<10 then
				spriteName = "arrow_daily_picture_0"..tostring(i)..".png"
			else
				spriteName = "arrow_daily_picture_"..tostring(i)..".png"
			end
			local arrowBtn = CButton :createWithSpriteFrameName("",spriteName)
			arrowBtn : setControlName( "this COneArrowEveryDayView arrowBtn 642 ")
			arrowBtn : setTag(i)
			arrowBtn : registerControlScriptHandler(local_shootCallback,"this COneArrowEveryDayView arrowBtn 645 ")
			parent : addChild(arrowBtn)

			if self.m_resetData then
				local local_CCBI
				local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
			        if eventType == "Enter" then
			            local_CCBI : play("run")
			        end
			        if eventType == "AnimationComplete" then
			            if local_CCBI ~= nil then
		                    parent: removeChild(local_CCBI,false)
		                    local_CCBI = nil 
			            end
			            arrowBtn : setVisible( true )

			            if i == 12 then
			            	-- 解锁
			            	local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
						    if isdis == false then
						        CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
						    end
						end
			        end
			    end
				local_CCBI = CMovieClip:create( "CharacterMovieClip/effects_strengthen.ccbi" )
			    local_CCBI : setControlName( "this CCBI effects_strengthen CCBI")
			    local_CCBI : registerControlScriptHandler( animationCallFunc)
			    parent : addChild(local_CCBI,1000)

			    arrowBtn : setVisible( false )
			end

			Container : addChild(parent)

			local icon = CSprite :createWithSpriteFrameName( "arrow_daily_click.png" )
			arrowBtn :addChild( icon, 10, 999 )
		end
	end

	self.m_shootIng = false

	local function local_NextArround()
		self : sendRquestViewMessage()
	end

	if shootCount >= 12 then
		-- 需要重置
		if self.m_mainContainer ~= nil then
			self.m_resetData = true
			self.m_mainContainer : performSelector( 3,local_NextArround )
		end
	else
		-- 无需重置
		self.m_resetData = false
	end
	
end

--射箭成功 提示
function COneArrowEveryDayView.shootCallBackForMediator( self )
	print("哦耶!射中啦!!!", "你真棒!!")
	-- CCMessageBox( "哦耶!射中啦!!!", "你真棒!!" )
end


function COneArrowEveryDayView.addEffactCCBI(self)
    if self.THEccbi ~= nil then
        if self.THEccbi  : retainCount() >= 1 then
            self.m_maxRewardBG   : removeChild(self.THEccbi,false)
            self.THEccbi = nil 
        end
    end

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            arg0 : play("run")
        end
        if eventType == "AnimationComplete" then
            if self.THEccbi ~= nil then
                if self.THEccbi  : retainCount() >= 1 then
                    self.m_maxRewardBG   : removeChild(self.THEccbi,false)
                    self.THEccbi = nil 
                end
            end
        end
    end

    self.THEccbi = CMovieClip:create( "CharacterMovieClip/effects_strengthen.ccbi" )
    self.THEccbi : setControlName( "this CCBI effects_strengthen CCBI")
    self.THEccbi : registerControlScriptHandler( animationCallFunc)
    self.m_maxRewardBG  : addChild(self.THEccbi,1000)
end







