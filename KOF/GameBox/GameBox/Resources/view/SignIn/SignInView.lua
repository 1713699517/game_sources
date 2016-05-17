--*********************************
--2013-8-2 by 陈元杰
--每日签到(登陆礼包)主界面-CSignInView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "mediator/SignInMediator"
--require "common/Constant"

CSignInView = class(view, function(self)
	CSignInView.readsigninrewardsxml = nil
end)
--Constant:
CSignInView.TAG_CLOSE           = 201
CSignInView.TAG_SIGNINBTN_START = 500

function CSignInView.initView( self, _mainSize )
	----------------------------
	--活动背景
	----------------------------
	self.m_background = CSprite :createWithSpriteFrameName("peneral_background.jpg", CCRectMake(160,280,60,80))
    self.m_background : setControlName( "this CSignInView self.m_background 24 ")
	self.m_background : setPreferredSize( self.m_winSize )
	self.m_scenelayer : addChild( self.m_background )

	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CSignInView self.m_mainContainer 53" )
    self.m_scenelayer    : addChild( self.m_mainContainer)

	self.m_mainBg = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_mainBg : setControlName( "this CSignInView self.m_mainBg 29 ")
	self.m_mainBg : setPreferredSize( _mainSize )
	self.m_mainContainer : addChild( self.m_mainBg )

	local function local_closeBtnCallback(eventType,obj,x,y)
		return self:closeBtnCallback(eventType,obj,x,y)
	end

	----------------------------
	--关闭 充值按钮 领取奖励按钮
	----------------------------
	self.m_closeBtn	  = CButton :createWithSpriteFrameName( "", "general_close_normal.png")
	self.m_closeBtn   :setControlName( "this CSignInView self.m_closeBtn 41 ")
    self.m_closeBtn   :setTag( CSignInView.TAG_CLOSE )
    self.m_closeBtn   :registerControlScriptHandler( local_closeBtnCallback, "this CSignInView self.m_closeBtn 43 ")
    self.m_mainContainer :addChild( self.m_closeBtn )

	----------------------------
	--每日签到介绍
	----------------------------
	self.m_noticBg = CSprite :create("SignInResources/Login_package_word.png")
    self.m_noticBg : setControlName( "this CSignInView self.m_noticBg 29 ")
	self.m_mainContainer : addChild( self.m_noticBg )

	self.m_nocitLabel     = CCLabelTTF :create( "领取说明: 连续登陆相应天数可领取对应登陆礼包奖励,后续连续登陆均领取第三日奖励,中\n途间断则重新累计.", "Arial", 19)
	self.m_nocitLabel 	  : setColor(ccc4(255,255,255,255)) 
	self.m_mainContainer :addChild( self.m_nocitLabel )

	----------------------------
	--签到奖励信息
	----------------------------
	local function local_goodstTouchCallback( eventType, obj, touches )
        return self :goodstTouchCallback( eventType, obj, touches )
    end

	local function local_signInCallback( eventType, obj, x , y)
        return self :signInCallback( eventType, obj, x , y)
    end

    self.m_rewardContainer = CContainer :create()
    self.m_rewardContainer : setControlName( "this is CSignInView self.m_rewardContainer 74" )
    self.m_mainContainer      : addChild( self.m_rewardContainer)

    self.m_rewardBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_rewardBg : setControlName( "this CSignInView self.m_rewardBg 29 ")
    self.m_rewardBg : setPreferredSize( CCSizeMake( 740, 380) )
	self.m_rewardContainer : addChild( self.m_rewardBg )

    self.m_whichDayLb     = {}
    self.m_rewardLayout   = {}
    self.m_rewardGoodsIcon= {}
    self.m_signInBtn 	  = {}
    self.m_goodsIdList    = {}
    local cellSize        = CCSizeMake( 90, 90)
    local index = 1

    for i=1,self.m_signInTypeNum do
    	-- 连续登陆 的总签到个数
    	local day = self :getDayStringByNumber(i)
    	self.m_whichDayLb[i] = CCLabelTTF :create( "第"..day.."天", "Arial", 25)
    	self.m_whichDayLb[i] : setColor( ccc4(255,255,255,255) )

    	self.m_rewardLayout[i] = CHorizontalLayout:create()
    	self.m_rewardLayout[i] : setCellSize( cellSize )
		self.m_rewardLayout[i] : setCellHorizontalSpace(23)
		self.m_rewardLayout[i] : setCellVerticalSpace(30)
		self.m_rewardLayout[i] : setLineNodeSum(4)
		self.m_rewardLayout[i] : setColumnNodeSum(1)

    	for j=1,4 do
    		-- 每个连续签到奖励的物品展示
    		self.m_rewardGoodsIcon[i]    = {}
			self.m_rewardGoodsIcon[i][j] = CButton : createWithSpriteFrameName("","general_props_frame_normal.png")
			self.m_rewardGoodsIcon[i][j] : setControlName("this CSignInView self.m_rewardGoodsIcon[i][j] 100 ")
			self.m_rewardLayout[i] : addChild( self.m_rewardGoodsIcon[i][j] )
			if j <= self.m_goodsNumList[i] then
				local lv = _G.g_characterProperty :getMainPlay():getLv()
				local goodId = 0
				local count  = 0
				if j==1 then 
					goodId = tonumber(self.m_signInInfoList[i]:getAttribute("reward_1"))
					count  = tonumber(self.m_signInInfoList[i]:getAttribute("count_1"))
				elseif j==2 then
					goodId = tonumber(self.m_signInInfoList[i]:getAttribute("reward_2"))
					count  = tonumber(self.m_signInInfoList[i]:getAttribute("count_2"))*lv*2
				elseif j==3 then
					goodId = tonumber(self.m_signInInfoList[i]:getAttribute("reward_3"))
					count  = tonumber(self.m_signInInfoList[i]:getAttribute("count_3"))*lv
				elseif j==4 then
					goodId = tonumber(self.m_signInInfoList[i]:getAttribute("reward_4"))
					count  = tonumber(self.m_signInInfoList[i]:getAttribute("count_4"))
				end  
				if goodId > 0 and count > 0 then 
					local goodsIcon = CIcon : create("Icon/i"..self:getGoodsNodeByXml( goodId ):getAttribute("icon")..".jpg")
					goodsIcon : setControlName("this CSignInView goodsIcon 120 ")
					goodsIcon : setPosition( ccp(0,0) )
					self.m_rewardGoodsIcon[i][j] : setTag(index)
					self.m_rewardGoodsIcon[i][j] : setTouchesMode( kCCTouchesAllAtOnce )
        			self.m_rewardGoodsIcon[i][j] : setTouchesEnabled( true)
					self.m_rewardGoodsIcon[i][j] : registerControlScriptHandler( local_goodstTouchCallback, "this CSignInView self.m_rewardGoodsIcon[i][j] 124 ")

					local numLabel = CCLabelTTF :create( "*"..count, "Arial", 21)
					numLabel : setColor(ccc3(255,255,255)) 
					numLabel : setAnchorPoint(ccp(1,0))
					numLabel : setPosition(ccp(cellSize.width/2-7,-cellSize.height/2+5))

					self.m_rewardGoodsIcon[i][j] : addChild( goodsIcon )
					self.m_rewardGoodsIcon[i][j] : addChild( numLabel  ,20)

					self.m_goodsIdList[index] = goodId
					index = index + 1

					table.insert( self.m_createResStrList, "Icon/i"..self:getGoodsNodeByXml( goodId ):getAttribute("icon")..".jpg" )
				end 
			else

				local Icon = CSprite:createWithSpriteFrameName( "general_props_underframe.png" )
                Icon   : setControlName( "this CActivitiesView Icon 39 ")
                self.m_rewardGoodsIcon[i][j] : addChild( Icon, -10 )

			end
    	end

    	self.m_signInBtn[i] = CButton :createWithSpriteFrameName( "领取奖励", "general_button_normal.png")
    	self.m_signInBtn[i] :setControlName( "this CSignInView self.m_signInBtn[i] 138 ")
    	self.m_signInBtn[i] :setFontSize( 24 )
    	self.m_signInBtn[i] :setTag( CSignInView.TAG_SIGNINBTN_START+i )
    	self.m_signInBtn[i] :registerControlScriptHandler( local_signInCallback, "this CSignInView self.m_signInBtn[i] 141 ")

    	self.m_rewardContainer :addChild( self.m_whichDayLb[i] )
    	self.m_rewardContainer :addChild( self.m_rewardLayout[i] )
    	self.m_rewardContainer :addChild( self.m_signInBtn[i] )

    	self.m_signInBtn[i] :setTouchesEnabled(false)

    end
end

function CSignInView.loadResources(self)
    _G.Config :load( "config/sign.xml")
end

function CSignInView.unloadResources(self)
    --CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("SignInResources/SignInResources.plist")
    --CCTextureCache :sharedTextureCache():removeTextureForKey("SignInResources/SignInResources.pvr.ccz")
	local r = CCTextureCache :sharedTextureCache():textureForKey("SignInResources/Login_package_word.png")
    if r ~= nil then
        CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
        CCTextureCache :sharedTextureCache():removeTexture(r)
        r = nil
    end

    _G.g_unLoadIconSources:unLoadAllIconsByNameList( self.m_createResStrList )
    self.m_createResStrList = {}

    _G.Config :unload( "config/sign.xml")
   
end

function CSignInView.layout(self, _mainSize)
	self.m_mainContainer :setPosition(ccp((self.m_winSize.width-_mainSize.width)/2, 0))

	----------------------------
	--活动背景
	----------------------------
	self.m_background : setPosition(ccp(self.m_winSize.width*0.5,self.m_winSize.height*0.5))
	self.m_mainBg 	  : setPosition(ccp(_mainSize.width*0.5,_mainSize.height*0.5))
	local backgroundSize = self.m_background :getPreferredSize()
	local mainBgSize  = self.m_mainBg   :getPreferredSize()

	----------------------------
	--关闭按钮
	----------------------------
	local closeBtnSize  = self.m_closeBtn :getContentSize()
	self.m_closeBtn : setPosition(ccp(_mainSize.width/2+mainBgSize.width/2-closeBtnSize.width/2,_mainSize.height/2+mainBgSize.height/2-closeBtnSize.height/2)) 

	----------------------------
	--每日签到介绍
	----------------------------
	self.m_noticBg        : setPosition(ccp(_mainSize.width*0.5 ,_mainSize.height*0.87)) 
	self.m_nocitLabel 	  : setPosition(ccp(_mainSize.width*0.5 ,_mainSize.height*0.094)) 
	self.m_nocitLabel     : setHorizontalAlignment(kCCTextAlignmentLeft) --左对齐

	----------------------------
	--签到奖励信息
	----------------------------
	self.m_rewardBg			   : setPosition(ccp(_mainSize.width*0.5 ,_mainSize.height*0.47)) 
	local x = _mainSize.width*0.22
	for i=1,self.m_signInTypeNum do
		self.m_whichDayLb[i]   : setAnchorPoint(ccp(1, 0.5))
		self.m_whichDayLb[i]   : setPosition(ccp( x-23  ,_mainSize.height*0.655 - 120*(i-1)  )) 
		self.m_rewardLayout[i] : setPosition(     x     ,_mainSize.height*0.655 - 120*(i-1)) 
		self.m_signInBtn[i]    : setPosition(ccp(  _mainSize.width*0.82 ,_mainSize.height*0.655 - 120*(i-1))) 
	end
end

--初始化数据成员
function CSignInView.initParams( self)

	self.m_createResStrList = {}
	self.m_signInData    = nil -- 请求界面返回数据中的 get_info 数据库 表      [40020] 连续登陆的天数 
	self.m_signInTypeNum = 3  -- 每日签到类型的总个数
	self.m_goodsNumList  = {} -- 每日签到的奖励物品数量 
	self.m_signInInfoList= {} -- 每日签到的总数据 
	for i=1 ,self.m_signInTypeNum ,1 do
		--初始化数据
		self.m_signInInfoList[i] = self : getSignInRewards(i)
		self.m_goodsNumList[i]   = self : getGoodsNumByXmlNode( self.m_signInInfoList[i] )
	end
	--print("initParams-->",self)
    _G.pSignInMediator = CSignInMediator(self)
    controller :registerMediator(_G.pSignInMediator)--先注册后发送 否则会报错    

end

--释放成员
function CSignInView.realeaseParams( self)
    
end

function CSignInView.init(self, _mainSize)
	--加载资源
	self:loadResources()
	--初始化数据
    self:initParams()
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)

	self :sendRquestViewMessage()
end

function CSignInView.scene(self)
	self.m_winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, self.m_winSize.height )
	self.m_scenelayer = CCScene:create()
	self:init( _mainSize, _data)
	return self.m_scenelayer
end





--*****************
--根据副本Id读取副本信息
--*****************
function CSignInView.getSignInRewards( self, _day)
    local day = tostring( _day)
    
    local signInData = _G.Config.sign :selectSingleNode("signs[0]/sign[@day="..day.."]")
    
    -- print( "signInData",signInData)
    return signInData
end

function CSignInView.getGoodsNodeByXml( self, _goodsId)
    local goodsId = tostring( _goodsId)
 
    _G.Config :load( "config/goods.xml")

    print("æææææææææææææææææ--->"..goodsId)
    local node = _G.Config.goodss :selectSingleNode( "goods[@id="..goodsId.."]")

    return node
end





--*****************
--计算
--*****************
--阿拉伯数字转成中文
function CSignInView.getDayStringByNumber( self, _number)
	if type(_number) ~= "string" then 
		if _number == 1 then
			_number = "一"
		elseif _number == 2 then 
			_number = "二"
		elseif _number == 3 then 
			_number = "三"
		elseif _number == 4 then 
			_number = "四"
		elseif _number == 5 then 
			_number = "五"
		elseif _number == 6 then 
			_number = "六"
		elseif _number == 7 then 
			_number = "七"
		end
	end
	return _number
end

--
function CSignInView.getGoodsNumByXmlNode( self, _data)
	local num = 0
	if tonumber(_data:getAttribute("reward_1")) > 0 and tonumber(_data:getAttribute("count_1")) > 0 then 
		num = num + 1 
	end
	if tonumber(_data:getAttribute("reward_2")) > 0 and tonumber(_data:getAttribute("count_2")) > 0 then 
		num = num + 1 
	end
	if tonumber(_data:getAttribute("reward_3")) > 0 and tonumber(_data:getAttribute("count_3")) > 0 then 
		num = num + 1 
	end
	if tonumber(_data:getAttribute("reward_4")) > 0 and tonumber(_data:getAttribute("count_4")) > 0 then 
		num = num + 1 
	end
	return num
end


--************************
--按钮回调
--************************
--关闭 单击回调
function CSignInView.closeBtnCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
			if _G.pSignInMediator ~= nil then
				controller :unregisterMediator(_G.pSignInMediator)
				_G.pSignInMediator = nil
			end
			CCDirector:sharedDirector():popScene()
			self:unloadResources()
		end
	end
end

--物品展示 单击回调
function CSignInView.goodstTouchCallback(self, eventType, obj, touches)
	if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
                local touchPoint = touch :getLocation()
                if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                    self.touchID1     = touch :getID()
                    self.goodsId1     = obj   :getTag()
                    -- _G.pDateTime :reset()
                    -- self.touchTime = _G.pDateTime:getTotalMilliseconds()
                    break
                end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID1 == nil then
           return
        end
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do

            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID1 and self.goodsId1 == obj :getTag() then

                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then
                   	print("物品展示啦")
					local index = obj:getTag()
					local goodsId = self.m_goodsIdList[index]
					local _winSize = CCDirector:sharedDirector():getVisibleSize()
					local _mainSize = CCSizeMake( 854, _winSize.height )
                    local _position = {}
                    _position.x = touch2Point.x
                    _position.y = touch2Point.y

					local temp = _G.g_PopupView :createByGoodsId( goodsId, _G.Constant.CONST_GOODS_SITE_OTHERROLE, _position )
					self.m_scenelayer :addChild( temp)

                    self.touchID1    = nil
                    self.goodsId1    = nil
                    --self.touchTime   = nil
                end
            end
        end
        print( eventType,"END")
    end
end

--签到(领取奖励) 单击回调
function CSignInView.signInCallback(self, eventType, obj, x , y)
	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
			local tag = obj :getTag()
			print("签到啦 第"..tag-CSignInView.TAG_SIGNINBTN_START.."天")

			self.m_signInWhichDay = tag-CSignInView.TAG_SIGNINBTN_START
			self.m_signInBtn[self.m_signInWhichDay] :setTouchesEnabled(false)

			--发送签到协议
			self :sendGetReWardMessage( tag-CSignInView.TAG_SIGNINBTN_START )
		end
	end
end






--************************
--发送协议
--************************
--请求界面
function CSignInView.sendRquestViewMessage( self )
	require "common/protocol/auto/REQ_SIGN_REQUES"
	local msg = REQ_SIGN_REQUES()
	CNetwork : send( msg )
end

--领取奖励
function CSignInView.sendGetReWardMessage( self , _whichDay)
	require "common/protocol/auto/REQ_SIGN_GET_REWARDS"
	local msg = REQ_SIGN_GET_REWARDS()
	msg : setDay( tonumber(_whichDay) )
	CNetwork : send( msg )
end






--************************
--mediator控制的方法
--************************
--请求界面返回
function CSignInView.requestViewCallBackForMediator( self, _data )

	local dateCount = #_data

	for i=1,3 do
		if i<= dateCount then
			if tonumber(_data[i].is_get) == 0 then 
				self.m_signInBtn[tonumber(_data[i].day)] : setTouchesEnabled( true )
			else
				self.m_signInBtn[tonumber(_data[i].day)] : setText("已领取")
			end
		end
	end

	-- for i,v in ipairs(_data) do
	-- 	print(v.day.." <-day       canget-> "..v.is_get)
	-- 	if tonumber(v.is_get) == 0 then 
	-- 		self.m_signInBtn[tonumber(v.day)] : setTouchesEnabled( true )
	-- 	end
	-- end

end

--领取奖励 返回
function CSignInView.getRewardCallBackForMediator( self )
	self.m_signInBtn[self.m_signInWhichDay] :setTouchesEnabled(false)
	self.m_signInBtn[self.m_signInWhichDay] :setText( "已领取" )
	--CCMessageBox( "领取连续"..self.m_signInWhichDay.."天登陆奖励成功", "提示" )
	local msg = "成功领取连续"..self.m_signInWhichDay.."天登陆奖励"
	self : createMessageBox(msg)

	--[[
	self.m_canGetRewardNum = self.m_canGetRewardNum - 1
	if self.m_canGetRewardNum == 0 then 
		--没有可签到的天数 移除主场景的 每日签到Icon
		local _wayCommand = CActivityIconCommand(CActivityIconCommand.REMOVE)
			_wayCommand:setOtherData(200)
			controller:sendCommand(_wayCommand)
	end
	]]
end

function CSignInView.createMessageBox(self,_msg) --通用提示框
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_scenelayer   : addChild(BoxLayer,1000)
end

