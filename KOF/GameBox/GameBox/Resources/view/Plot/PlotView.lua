--*********************************
--2013-8-16 by 陈元杰
--神器主界面-CPlotView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"

require "view/Map/Maptable"


CPlotView = class(view, function(self)
	self.m_isLoaMap  = false
	self.m_plotIndex = 0
	self.m_monsterList = {}
end)



----------------------------
--常量
----------------------------
--按钮tag值
CPlotView.TAG_CLOSE     = 201
CPlotView.TAG_ROLE      = 310
CPlotView.TAG_NAME      = 320
CPlotView.TAG_TALKLABEL = 351

--大小
CPlotView.TalkSize      = CCSizeMake( 440 , 100 ) --对话Lbel大小

--剧情播放速度
CPlotView.SPEED_Start   = 400--开场动画速度--50  每秒多少px
CPlotView.SPEED_Talk    = 6 --对话显示速度 --没多少(1/60)秒显示一个数字

--时间
CPlotView.Time_Start       = 0.3 --开场动画后间隔的时间
CPlotView.TIME_Interval    = 0.8   --上一步剧情与下一步剧情的时间间隔
CPlotView.TIME_DelayTalk   = 0.8 --对话的时间间隔
CPlotView.TIME_DelayFinish = 1.5   --剧情结束等待时间
CPlotView.TIME_CreateRole  = 0.5 --创建角色等待时间
CPlotView.TIME_DelayMove   = 1   --等待角色移动的时间
CPlotView.TIME_DelayRemove = 1   --移除角色后等待多久自动进入下一步

--剧情播放阶段
CPlotView.TYPE_Start       = 10 --开场动画阶段
CPlotView.TYPE_StartFinish = 15 --开场动画结束阶段
CPlotView.TYPE_Talk        = 20 --对话中阶段
CPlotView.TYPE_Talk_end    = 25 --对话完阶段
CPlotView.TYPE_Move        = 30 --角色移动
CPlotView.TYPE_Remove      = 35 --移除角色阶段
CPlotView.TYPE_CreateRole  = 40 --创建角色
CPlotView.TYPE_Finish      = 50 --剧情播放阶段

--颜色
CPlotView.RED   = ccc4(255,0,0,255)
CPlotView.GOLD  = ccc4(255,215,0,255)
CPlotView.GREEN = ccc4(120,222,66,255)
CPlotView.WHITE = ccc4(255,255,255,255)




--创建对话框的名字 Label
function CPlotView.createNameLabelByName( self, _name )
	--创建名字
	if self.m_mainContainer:getChildByTag( CPlotView.TAG_NAME ) ~= nil then 
		self.m_mainContainer :removeChildByTag( CPlotView.TAG_NAME )
	end

	local name = _name or ""

	local nameLabel = CCLabelTTF :create( name,"Arial",22)
	nameLabel :setAnchorPoint( ccp( 0.5, 0 ) )
	nameLabel :setPosition( ccp( 280, 160 ) )
	nameLabel :setColor( CPlotView.WHITE )
	nameLabel :setTag( CPlotView.TAG_NAME )
	self.m_mainContainer : addChild( nameLabel )

end

--创建对话框的角色图像
function CPlotView.createRoleSprite( self, _skinId, _dir )

	-- self :removeRoleSprite()

	local _winSize = CCDirector:sharedDirector():getVisibleSize()

	local sprName = "HeadIconResources/role_body_02.png"
	if tonumber(_skinId) == -1 then
		local property = _G.g_characterProperty : getMainPlay()
		local pro = property : getPro()
		sprName = "taskDialog/taskNpcResources/so_1000"..pro..".png"
	else
		sprName = "taskDialog/taskNpcResources/so_".._skinId..".png"
	end
	self.m_preSprName = sprName

	local roleSprite = CSprite :create(sprName)
    roleSprite : setControlName( "this CPlotView roleSprite 43 ")
	self.m_mainContainer : addChild( roleSprite,100 )

	local size = roleSprite :getPreferredSize()

	if tonumber(_dir) == 6 then
		roleSprite : setPosition( ccp( size.width/2-50, size.height*0.15 ) )
	else
		roleSprite : setPosition( ccp( _winSize.width - size.width/2+50, size.height*0.15 ) )
	end

	self :removeRoleSprite()

	roleSprite :setTag( CPlotView.TAG_ROLE )

	table.insert( self.m_createResStrList, sprName )

end

--移除对话框的主角图像
function CPlotView.removeRoleSprite( self )
	if self.m_mainContainer:getChildByTag( CPlotView.TAG_ROLE ) ~= nil then 
		self.m_mainContainer :removeChildByTag( CPlotView.TAG_ROLE )
	end
end

--创建对话 Label
function CPlotView.createTalkLabel( self )

	local talkLabel = CCLabelTTF :create("","Arial",20)
	talkLabel :setDimensions( CPlotView.TalkSize )
	talkLabel :setAnchorPoint( ccp( 0, 1 ) )
	talkLabel :setPosition( ccp( 230, 135 ) )
	talkLabel :setColor( CPlotView.WHITE )
	talkLabel :setHorizontalAlignment( kCCTextAlignmentLeft )
	talkLabel :setTag( CPlotView.TAG_TALKLABEL )
	self.m_mainContainer : addChild( talkLabel )

end

--设置对话内容
-- function CPlotView.setTalkLabelString( self, _str )

-- 	if _str == nil then 
-- 		return
-- 	end

-- 	if self.m_mainContainer :getChildByTag( CPlotView.TAG_TALKLABEL ) == nil then
-- 		print("««««««««««««««««««  112121")
-- 		self :createTalkLabel()
-- 	end

-- 	print("setTalkLabelString----------->".._str)

-- 	local label = self.m_mainContainer :getChildByTag( CPlotView.TAG_TALKLABEL )
-- 	if label.setString ~= nil then
-- 		label :setString( _str )
-- 	else
-- 		print("---------------------------  nilnilnilnilnil")
-- 	end

-- end
function CPlotView.setTalkLabelString( self, _str )

	if _str == nil then
		return
	end

	-- print("setTalkLabelString----------->".._str)

	if self.m_talkLabel ~= nil then
		self.m_talkLabel:setString( _str )
	else
		print("---------------------------  nilnilnilnilnil")
	end
end


--创建手指动画
function CPlotView.createHandAction( self )
	
	print("CPlotView.createHandAction  ")

	local _winSize = CCDirector:sharedDirector():getVisibleSize()
	local handSpr  = CSprite:createWithSpriteFrameName("guide_hand.png")
	local sprSize  = handSpr:getPreferredSize()

	local act    = CCMoveBy:create(0.5, ccp( 0, 20 ))
	local _array = CCArray :create()
	_array :addObject( act )
	_array :addObject( act :reverse(), 0.5)
    --guideArrow:runAction( CCRepeat:create(CCSequence :create( _array ), -1) )
    handSpr:runAction( CCRepeatForever:create(CCSequence :create( _array )) )
    handSpr:setPosition(ccp( _winSize.width-sprSize.width/2-100, 65 ))
    handSpr:setRotation( -45 )

    if self.m_mainContainer ~= nil then
    	self.m_mainContainer :addChild( handSpr,200 )
    end
end





--æææææææææææææææææææææææææææææææææææææææ
--场景控制
--æææææææææææææææææææææææææææææææææææææææ
--创建怪物到主场景中
function CPlotView.createPlotMonster( self, _tag, _name, _pos, _dir )

	-- local characterPosX,characterPosY = _G.g_Stage :getPlay() : getLocationXY()
	local ContainerX, ContainerY = _G.g_Stage.m_lpContainer : getPosition()
	local monster = _G.g_Stage :addPlotMonster( _tag, _name, ccp( -ContainerX+_pos.x, _pos.y ),_dir )

	local list = {}
	if monster ~= nil then 
		list.id 	 = _tag
		list.monster = monster
		table.insert(self.m_monsterList,list)
	end
end

--移动角色(主角或怪物)
function CPlotView.roleMove( self, _tag, _pos )
	local ContainerX, ContainerY = _G.g_Stage.m_lpContainer : getPosition()
	local pos = ccp( -ContainerX + _pos.x, _pos.y )
	if _tag == -1 then 
		--移动主角
		_G.g_Stage :getPlay() :setMovePos( pos )
	else
		--移动Monster
		for i,v in ipairs(self.m_monsterList) do
			print("roleMove...",i,v.id,_tag)
			if tonumber(v.id) == tonumber(_tag) then 
				local monster = v.monster
				if monster ~= nil then 
					print("monster :setMovePos( pos )")
					monster :setMovePos( pos )
				else
					self :goNextAction()
				end
				return
			end
		end
		self :goNextAction()
	end
end

--角色消失(主角或怪物)
function CPlotView.roleRemove( self, _tag )
	if _tag == -1 then 
		return
	else
		local list = self.m_monsterList
		for i,v in ipairs(list) do
			if tonumber(v.id) == tonumber(_tag) then 
				table.remove( self.m_monsterList, i)
				local monster = v.monster
				if monster ~= nil then 
					_G.g_Stage :removePlotMonster( monster )
				else
					self :goNextAction()
				end
				return
			end
		end
	end
end


--æææææææææææææææææææææææææææææææææææææææ
--页面设置
--æææææææææææææææææææææææææææææææææææææææ
--开场动画
function CPlotView.initBgView( self )
	--隐藏主场景部分View 只剩下主角和场景
	_G.g_Stage :visibleForPlot( false )

	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( " this is CPlotView self.m_mainContainer 164" )
    self.m_scenelayer    : addChild( self.m_mainContainer )

	----------------------------
	--剧情背景
	----------------------------
	self.m_upBackground = CSprite :createWithSpriteFrameName("movie_talk_underframe_up.png",CCRectMake(290,0,20,105))
    self.m_upBackground : setControlName( "this CPlotView self.m_upBackground 43 ")
    self.m_upBackground : setPreferredSize( CCSizeMake(self.m_winSize.width,105) )
	self.m_mainContainer : addChild( self.m_upBackground )

	self.m_downBackground = CSprite :createWithSpriteFrameName("movie_talk_underframe_down.png",CCRectMake(382,0,20,201))
    self.m_downBackground : setControlName( "this CPlotView self.m_downBackground 43 ")
    self.m_downBackground : setPreferredSize( CCSizeMake(self.m_winSize.width,201) )
	self.m_mainContainer  : addChild( self.m_downBackground )

	-- local ContainerX, ContainerY = _G.g_Stage.m_lpContainer : getPosition()
	-- self.m_mainContainer  : setPosition(ccp( -ContainerX + self.m_winSize.width*0.5-self.m_winSize.width*0.5, 0 ))

	self.m_upBackground   : setPosition(ccp( self.m_winSize.width*0.5, self.m_winSize.height + 53 ))
	self.m_downBackground : setPosition(ccp( self.m_winSize.width*0.5, -101 ))

	-- self :createTalkLabel()
	self.m_talkLabel = CCLabelTTF :create("","Arial",20)
	self.m_talkLabel :setDimensions( CPlotView.TalkSize )
	self.m_talkLabel :setAnchorPoint( ccp( 0, 1 ) )
	self.m_talkLabel :setPosition( ccp( 230, 135 ) )
	self.m_talkLabel :setColor( CPlotView.WHITE )
	self.m_talkLabel :setHorizontalAlignment( kCCTextAlignmentLeft )
	self.m_talkLabel :setTag( CPlotView.TAG_TALKLABEL )
	self.m_mainContainer : addChild( self.m_talkLabel )

	local _showtime = 0.6

	local function onCallBack()
        -- marqueeContainer : removeFromParentAndCleanup(true)
        -- marqueeContainer = nil
        self:setTime(0)
        self:createHandAction();
        -- self :goNextAction()
    end
    local _actionUp = CCArray:create()
    _actionUp:addObject(CCMoveTo:create( _showtime, ccp( self.m_winSize.width*0.5, self.m_winSize.height - 53) ))
    -- _actionUp:addObject(CCCallFunc:create(onCallBack))
    self.m_upBackground : runAction( CCSequence:create(_actionUp) )

    local _actionDown = CCArray:create()
    _actionDown:addObject(CCMoveTo:create( _showtime, ccp( self.m_winSize.width*0.5, 101) ))
    _actionDown:addObject(CCCallFunc:create(onCallBack))
    self.m_downBackground : runAction( CCSequence:create(_actionDown) )

	-- self :initBgActionData()
end

--计算开场动画数据
function CPlotView.initBgActionData( self )
	self.m_downHei = self.m_downBackground :getPreferredSize().height
	self.m_upHei   = self.m_upBackground :getPreferredSize().height
	self.m_useTime = self.m_downHei/2/CPlotView.SPEED_Start

	if self.m_downHei < self.m_upHei then
		self.m_useTime = self.m_upHei/2/CPlotView.SPEED_Start
	end
	CCLOG("CPlotView---Text--->  initBgActionData--->  self.m_useTime="..self.m_useTime)
    self :setTime(0)

end

--对话
function CPlotView.initTalkView( self )
	--
	local data   = self.m_plotData:children():get(0,"items"):children():get(self.m_plotIndex-1,"item")
	local roleId = tonumber(data:getAttribute("id"))
	local dir    = tonumber(data:getAttribute("dir"))
 	local name   = self :getNameByMonsterId( data:getAttribute("id") )

 	local function local_createRoleSprite()
 		self :createRoleSprite(roleId,dir)

	 	--保存当前阶段
		self.m_poltType = CPlotView.TYPE_Talk
		--保存这段话的内容
		self.m_talkInfo = {}
		self.m_talkInfo.info   = data:getAttribute("msg")
		self.m_talkInfo.nowIdx = 0
		self.m_talkInfo.maxIdx = self :getCharCountByUTF8( self.m_talkInfo.info )--#self.m_talkInfo.info
		self.m_talkInfo.cdTime = 0
		self.m_talkInfo.isAutoGoOn = tonumber(data:getAttribute("hand"))

		self :setTalkLabelString("")
		self :setTime( 0 )
 	end

 	--创建名称
	self :createNameLabelByName( name )
	--创建角色图片
	-- self:removeRoleSprite()
	-- self.m_mainContainer :performSelector(0.4,local_createRoleSprite)
	self :createRoleSprite(roleId,dir)
	--保存当前阶段
	self.m_poltType = CPlotView.TYPE_Talk
	--保存这段话的内容
	self.m_talkInfo = {}
	self.m_talkInfo.info   = data:getAttribute("msg")
	self.m_talkInfo.nowIdx = 0
	self.m_talkInfo.maxIdx = self :getCharCountByUTF8( self.m_talkInfo.info )--#self.m_talkInfo.info
	self.m_talkInfo.cdTime = 0
	self.m_talkInfo.isAutoGoOn = tonumber(data:getAttribute("hand"))

	self :setTalkLabelString("")
	self :setTime( 0 )

	print("initTalkView   42342")
end




--进入下一步动作
function CPlotView.goNextAction( self )

	--停止时间
	self :setTime( nil )

	self.m_plotIndex = self.m_plotIndex + 1 --下一步Index

	local itemChildList = self.m_plotData :children() :get(0,"items") :children()
	local item 			= itemChildList :get(self.m_plotIndex-1,"item")--self.m_plotData.item[self.m_plotIndex] 
	if item:isEmpty() then 
		--下一步为空 
		self.m_poltType = CPlotView.TYPE_Finish
		if itemChildList:get(self.m_plotIndex-2,"item"):isEmpty() then
			--上一步也为空 自动退出
			self :setTime( 0 )
		elseif tonumber(itemChildList:get(self.m_plotIndex-2,"item"):getAttribute("hand")) == 0 then 
			--上一步为自动 则自动退出      否则手动
			self :setTime( 0 )
		end
		return
	end

	print("text   ææææææææææææææææ    111")

	local data = item
	local act  = tonumber(data:getAttribute("act"))

	if act == _G.Constant.CONST_DRAMA_ACT_APPEAR then
		--添加人物
		if tonumber(data:getAttribute("id")) == -1 then 
			--主角 不需添加
			self :goNextAction()
			return
		end

		local pos = ccp( tonumber(data:getAttribute("x")), tonumber(data:getAttribute("y")) )
		self :createPlotMonster( data:getAttribute("id"), data:getAttribute("name"), pos, data:getAttribute("dir") )
		self.m_poltType = CPlotView.TYPE_CreateRole
		self :setTime(0)
	elseif act == _G.Constant.CONST_DRAMA_ACT_DIALOGUE then
		--对话
		self:initTalkView()
	elseif act == _G.Constant.CONST_DRAMA_ACT_MOVE then 
		--移动
		self.m_poltType = CPlotView.TYPE_Move

		local pos = ccp( tonumber(data:getAttribute("x")), tonumber(data:getAttribute("y")) )
		print("---------  data:getAttribute(x)="..data:getAttribute("x").."      data:getAttribute(y)="..data:getAttribute("y"))
		self:roleMove( tonumber(data:getAttribute("id")), pos ) 
		self:setTime(0)
	elseif act == _G.Constant.CONST_DRAMA_ACT_DISAPPEAR then 
		--人物消失
		self.m_poltType = CPlotView.TYPE_Remove
		self:roleRemove( tonumber(data:getAttribute("id")) )
		self:setTime(0)
	else
		--其他效果暂时没做
		self :goNextAction()
		return
	end

end

--获取对话角色的名字
function CPlotView.getNameByMonsterId( self, _id )

	if tonumber(_id) == -1 then 
		return _G.g_Stage : getPlay() : getName()
	end

	local nodeChild = self.m_plotData:children():get(0,"items"):children()

	for i=0,nodeChild:getCount("item")-1 do
		local node = nodeChild:get(i,"item")
		if tonumber(_id) == tonumber( node:getAttribute("id") ) then
			return node:getAttribute( "name" )
		end
	end

	-- for i,v in ipairs(self.m_plotData.item) do
	-- 	if tonumber(v.id) == tonumber(_id) then
	-- 		return v.name
	-- 	end
	-- end
	return nil
end

--获取string的字符个数
function CPlotView.getCharCountByUTF8( self, str )
    local len = #str;
    local left = len;
    local cnt = 0;
    local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
    while left ~= 0 do
        local tmp=string.byte(str,-left);
        local i=#arr;
        while arr[i] do
            if tmp>=arr[i] then left=left-i;break;end
            i=i-1;
        end
        cnt=cnt+1;
    end
    return cnt;
end

--æææææææææææææææææææææææææææææææææææææææ
--时间控制 
--æææææææææææææææææææææææææææææææææææææææ
function CPlotView.registerEnterFrameCallBack(self)
    print( "CPlotView.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        self :updataResetTime( _duration)
    end
    self.m_scenelayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CPlotView.updataResetTime( self, _duration)
    if self.m_nowTime == nil or self.m_nowTime < 0 then
        return
    end

    print("updataResetTime  ",self.m_poltType,self.m_nowTime)

    self.m_nowTime = self.m_nowTime + _duration

    if self.m_poltType == CPlotView.TYPE_Start then 
    	--剧情播放开场阶段
    	if self.m_nowTime > CPlotView.Time_Start then 
    		self :goNextAction()
	    end
    elseif self.m_poltType == CPlotView.TYPE_Talk then 
    	if self.m_nowTime > CPlotView.TIME_DelayTalk then
	    	self :resetTalkInfo( _duration )
	    end
    elseif self.m_poltType == CPlotView.TYPE_Talk_end then 
    	if self.m_nowTime > CPlotView.TIME_Interval then
    		-- self :removeRoleSprite()
    		self :goNextAction()
    	end
    elseif self.m_poltType == CPlotView.TYPE_CreateRole then 
    	if self.m_nowTime >= CPlotView.TIME_CreateRole then 
    		self:goNextAction()
    	end 
    elseif self.m_poltType == CPlotView.TYPE_Move then 
    	if self.m_nowTime >= CPlotView.TIME_DelayMove then
    		self :goNextAction()
    	end 
    elseif self.m_poltType == CPlotView.TYPE_Remove then 
    	if self.m_nowTime >= CPlotView.TIME_DelayRemove then 
    		self :goNextAction()
    	end
    elseif self.m_poltType == CPlotView.TYPE_Finish then
    	if self.m_nowTime > CPlotView.TIME_DelayFinish then 
    		self :resetPlotView()
    	end
    end
    
end

--设置时间
function CPlotView.setTime( self, _time)
    self.m_nowTime  = _time
end

--对话内容控制
function CPlotView.resetTalkInfo( self, _duration )
	if self.m_talkInfo.maxIdx > self.m_talkInfo.nowIdx then 
		--对话内容未显示完整 继续添加内容
		self.m_talkInfo.cdTime = self.m_talkInfo.cdTime + _duration
    	if self.m_talkInfo.cdTime >= CPlotView.SPEED_Talk/60 then 
    		--根据时间间隔 添加内容
			self.m_talkInfo.cdTime = 0
			self.m_talkInfo.nowIdx = self.m_talkInfo.nowIdx + 1
    		local talkNow = string.sub(self.m_talkInfo.info,1,self.m_talkInfo.nowIdx*3)
    		self :setTalkLabelString( talkNow )
	    end
    elseif self.m_talkInfo.isAutoGoOn == 0 then
    	--对话内容显示完整 自动进入下一步动作
    	self.m_poltType = CPlotView.TYPE_Talk_end
    	self :setTime( 0 )

    	-- self :removeRoleSprite()
    else
    	--对话内容显示完整 手动点击进入下一步动作
    	self :setTime( nil )
    	self.m_poltType = CPlotView.TYPE_Talk_end

    	-- self :removeRoleSprite()
    end
end




--加载资源
function CPlotView.loadResources(self)
	--lua加载图片资源  .plist
	CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("PlotResources/PlotResources.plist")
end

function CPlotView.unloadResources( self )

	CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("PlotResources/PlotResources.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("PlotResources/PlotResources.pvr.ccz")

	_G.g_unLoadIconSources:unLoadAllIconsByNameList( self.m_createResStrList )
	self.m_createResStrList = {}
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()

end

--初始化数据成员
function CPlotView.initParams( self, _plotData )
	--注册AI回调
    self :registerEnterFrameCallBack()

    --剧情数据
    self.m_plotData = _plotData

    --当前剧情进行阶段
    self.m_poltType = CPlotView.TYPE_Start 

    self.m_createResStrList = {}
end

function CPlotView.init( self, _plotData )
	--加载资源
	self:loadResources()
	--初始化数据
    self:initParams( _plotData )
    --开场动画
	self:initBgView( )
end

function CPlotView.createPlot( self, _plotData )

	local function local_fullScreenTouchCallBack( eventType, obj, x , y )
		return self :fullScreenTouchCallBack( eventType, obj, x , y )
	end

    self.m_winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName( " this is CPlotView self.m_scenelayer 164" )
    self.m_scenelayer : setTouchesEnabled( true )
    self.m_scenelayer : setFullScreenTouchEnabled( true )
    self.m_scenelayer : setTouchesPriority( -200 )
    self.m_scenelayer : registerControlScriptHandler(local_fullScreenTouchCallBack,"this is CPlotView self.m_scenelayer 462")
    self :init( _plotData )

    return self.m_scenelayer

end


--释放成员
function CPlotView.realeaseParams( self)
	self.m_plotIndex 	 = 0  
	self.m_monsterList = {}
end

function CPlotView.resetPlotView( self )
	if self.m_scenelayer ~= nil then 
		self.m_scenelayer : removeFromParentAndCleanup( true )
		self.m_scenelayer = nil
	end
	
	--恢复主场景部分View 
	_G.g_Stage :visibleForPlot( true )

	--移除创建的怪物(monster)
	for i,v in ipairs(self.m_monsterList) do
		local monster = v.monster
		if monster ~= nil then 
			_G.g_Stage :removePlotMonster( monster )
		end
	end

	--初始化参数
	self :realeaseParams()

	--调用播放剧情后的方法
	_G.pCPlotManager:finishPlot(self.m_plotData:getAttribute("id"))

	self:unloadResources()
end




--æææææææææææææææææææææææææææææææææææææææ
--按钮回调
--æææææææææææææææææææææææææææææææææææææææ
--全屏回调
function CPlotView.fullScreenTouchCallBack(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then

		print("------------", self.m_poltType)
		if self.m_poltType == CPlotView.TYPE_Start then
			--开场动画 
			return
		end

		self :setTime( nil )

		--剧情播放阶段
		if self.m_poltType == CPlotView.TYPE_Talk then
			--对话中 点击显示全部内容
			-- self :removeRoleSprite()
			
			print("TYPE_Talk")
			self.m_poltType = CPlotView.TYPE_Talk_end
			local talkNow = string.sub(self.m_talkInfo.info,1,self.m_talkInfo.maxIdx*3)
    		self :setTalkLabelString( talkNow )
    		self :setTime(0)
		elseif self.m_poltType == CPlotView.TYPE_Talk_end then
			--对话完 点击进入下一步动作
			print("TYPE_Talk_end")
			self :goNextAction()
		elseif self.m_poltType == CPlotView.TYPE_Remove then
			--移除角色 点击进入下一步
			print("TYPE_Remove")
			self :goNextAction()
		elseif self.m_poltType == CPlotView.TYPE_CreateRole then 
			self :goNextAction()
		elseif self.m_poltType == CPlotView.TYPE_Finish then
			--剧情播放完毕 清除View
			print("TYPE_Finish")
			self :resetPlotView()
		end

	end
end



