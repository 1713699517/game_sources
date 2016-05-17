--*********************************
--2013-9-12 by 陈元杰
--活跃度主界面-CActivenessView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "mediator/ActivenessMediator"


CActivenessView = class(view, function(self)

end)

--************************
--常量定义
--************************
-- button的Tag值
CActivenessView.TAG_CLOSE           = 201

-- ccColor4B 常量
CActivenessView.RED   = ccc4(255,0,0,255)
CActivenessView.GOLD  = ccc4(255,255,0,255)
CActivenessView.GREEN = ccc4(120,222,66,255)
CActivenessView.BLUE  = ccc4( 0,180,255,255 )

CActivenessView.SIZE_LIST = CCSizeMake( 820, 66 )
CActivenessView.Page_Size = 4

CActivenessView.FONT_SIZE = 20


function CActivenessView.initView( self, _mainSize )

	local _winSize = CCDirector:sharedDirector():getVisibleSize()
	
	self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CActivenessView self.m_mainContainer 39 ")
    self.m_scenceLayer   : addChild( self.m_mainContainer )

    self.m_mainBackground = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_mainBackground : setControlName( "this CActivenessView self.m_mainBackground 39 ")
	self.m_mainBackground : setPreferredSize( _winSize )
	self.m_mainContainer  : addChild( self.m_mainBackground )

	----------------------------
	--活动背景
	----------------------------
	self.m_background = CSprite :createWithSpriteFrameName("general_first_underframe.png")
    self.m_background : setControlName( "this CActivenessView self.m_background 39 ")
	self.m_background : setPreferredSize( _mainSize )
	self.m_mainContainer  : addChild( self.m_background )


	local function local_closeBtnCallback(eventType,obj,x,y)
		return self:closeBtnCallback(eventType,obj,x,y)
	end

	----------------------------
	--关闭 按钮
	----------------------------
	self.m_closeBtn	  = CButton :createWithSpriteFrameName( "", "general_close_normal.png")
	self.m_closeBtn   :setControlName( "this CActivenessView self.m_closeBtn 70 ")
    self.m_closeBtn   :setTag( CActivenessView.TAG_CLOSE )
    self.m_closeBtn   :registerControlScriptHandler( local_closeBtnCallback, "this CActivenessView self.m_closeBtn 72 ")
    self.m_mainContainer :addChild( self.m_closeBtn )


    ----------------------------
    --主界面
    ----------------------------
    self.m_hydWordImg = CSprite :createWithSpriteFrameName("active_word_hyd.png")
    self.m_hydWordImg : setControlName( "this CActivenessView self.m_hydWordImg 39 ")
    self.m_mainContainer  : addChild( self.m_hydWordImg )

    self.m_upBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_upBg : setControlName( "this CActivenessView self.m_upBg 39 ")
	self.m_upBg : setPreferredSize( CCSizeMake( CActivenessView.SIZE_LIST.width+2,336 ) )

	self.m_downBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_downBg : setControlName( "this CActivenessView self.m_downBg 39 ")
	self.m_downBg : setPreferredSize( CCSizeMake( CActivenessView.SIZE_LIST.width+2,208 ) )

	self.m_mainContainer  : addChild( self.m_upBg )
	self.m_mainContainer  : addChild( self.m_downBg )

	self.m_upContainer = CContainer :create()
    self.m_upContainer : setControlName( "this CActivenessView self.m_upContainer 39 ")
    self.m_mainContainer : addChild( self.m_upContainer )

    self.m_downContainer = CContainer :create()
    self.m_downContainer : setControlName( "this CActivenessView self.m_downContainer 39 ")
    self.m_mainContainer : addChild( self.m_downContainer )

    --活动列表Title
	self:initTitle()
    --活跃度奖励信息块
    self:initRewardView()
	

end

function CActivenessView.initTitle( self )

    print("CActivenessView.initTitle start")
	--每个栏目的位置
    self:initListPos()

	--标题兰背景
	self.m_titleImg = CSprite :createWithSpriteFrameName( "team_titlebar_underframe.png",CCRectMake( 10,0,10,59 ))
    self.m_titleImg : setControlName( "this CActivenessView.initTitle self.m_titleImg 107" )
    self.m_titleImg : setPreferredSize( CActivenessView.SIZE_LIST )

    --标题栏
    self.m_RWMBLabel = CCLabelTTF :create( "任务目标", "Arial", CActivenessView.FONT_SIZE+2 )
    self.m_RWJDLabel = CCLabelTTF :create( "任务进度", "Arial", CActivenessView.FONT_SIZE+2 )
    self.m_HYDLabel  = CCLabelTTF :create( "活跃度", "Arial", CActivenessView.FONT_SIZE+2 )
    self.m_CZLabel   = CCLabelTTF :create( "操作", "Arial", CActivenessView.FONT_SIZE+2 )

    self.m_RWMBLabel : setColor( CActivenessView.BLUE )
    self.m_RWJDLabel : setColor( CActivenessView.BLUE )
    self.m_HYDLabel  : setColor( CActivenessView.BLUE )
    self.m_CZLabel   : setColor( CActivenessView.BLUE )

    self.m_upContainer :addChild( self.m_titleImg )
    self.m_titleImg :addChild( self.m_RWMBLabel )
    self.m_titleImg :addChild( self.m_RWJDLabel )
    self.m_titleImg :addChild( self.m_HYDLabel )
    self.m_titleImg :addChild( self.m_CZLabel )
    
    print("CActivenessView.initTitle end")

end

function CActivenessView.initRewardView( self )
	
    print("CActivenessView.initRewardView start")
    
    local function local_goodsTouchCallback(eventType,obj,touches)
		return self:goodsTouchCallback(eventType,obj,touches)
	end
    local rewardList     = _G.Config.active_link_rewards :selectSingleNode("active_link_rewardss[0]"):children() --getCount("active_link_rewards")
    print("12222222222")
	-- local rewardList     = nodeListChild:get(0,"active_link_rewards")
    self.m_rewardBtnList = {}
    self.m_rewardBtnInfo = {}
    for i=1,4 do
    	local id = tonumber(rewardList:get(i-1,"active_link_rewards"):getAttribute("id"))
    	self.m_rewardBtnInfo[id] 		    = {}
    	self.m_rewardBtnInfo[id].id 		= id
    	self.m_rewardBtnInfo[id].vitality   = tonumber(rewardList:get(i-1,"active_link_rewards"):getAttribute("vitality"))
    	self.m_rewardBtnInfo[id].goodsId    = tonumber(rewardList:get(i-1,"active_link_rewards"):getAttribute("rewards_id"))
    	self.m_rewardBtnInfo[id].goodsCount = tonumber(rewardList:get(i-1,"active_link_rewards"):getAttribute("rewards_count"))
    	self.m_rewardBtnInfo[id].canGet     = false

        table.insert(self.m_iConList,self:getGoodsNodeById(self.m_rewardBtnInfo[id].goodsId):getAttribute("icon"))
    	self.m_rewardBtnList[id] = CButton : create( "","Icon/i"..self:getGoodsNodeById(self.m_rewardBtnInfo[id].goodsId):getAttribute("icon")..".jpg" )
    	self.m_rewardBtnList[id] : setControlName( "this CActivenessView self.m_rewardBtnList[id] 70 ")
	    self.m_rewardBtnList[id] : setTag( i )
	    self.m_rewardBtnList[id] : setTouchesMode( kCCTouchesAllAtOnce )
        self.m_rewardBtnList[id] : setTouchesEnabled( true)
	    self.m_rewardBtnList[id] : registerControlScriptHandler( local_goodsTouchCallback, "this CActivenessView self.m_rewardBtnList[id] 72 ")
	    self.m_downContainer :addChild( self.m_rewardBtnList[id] )

	    local btnBg = CSprite : createWithSpriteFrameName( "general_props_frame_normal.png" )
        btnBg : setControlName( "this CActivenessView btnBg 163 ")
	    self.m_rewardBtnList[id] : addChild( btnBg, 200 )
    end

    self.m_rewareTitleLb = CCLabelTTF :create( "活跃度奖励 :", "Arial", CActivenessView.FONT_SIZE )
    self.m_activenessLb1 = CCLabelTTF :create( "(0)活跃度", "Arial", CActivenessView.FONT_SIZE )
    self.m_activenessLb2 = CCLabelTTF :create( "(25)", "Arial", CActivenessView.FONT_SIZE )
    self.m_activenessLb3 = CCLabelTTF :create( "(50)", "Arial", CActivenessView.FONT_SIZE )
    self.m_activenessLb4 = CCLabelTTF :create( "(75)", "Arial", CActivenessView.FONT_SIZE )
    self.m_activenessLb5 = CCLabelTTF :create( "(100)", "Arial", CActivenessView.FONT_SIZE )
    -- self.m_activenessLb6 = CCLabelTTF :create( "(110)", "Arial", CActivenessView.FONT_SIZE )

    self.m_activenessBg = CSprite :createWithSpriteFrameName("active_exp_underframe.png",CCRectMake( 45,0,1,26 ))
    self.m_activenessBg : setControlName( "this CActivenessView self.m_activenessBg 39 ")
	self.m_activenessBg : setPreferredSize( CCSizeMake( 727, 26 ) )

	self.m_activenessLineImg = CSprite :createWithSpriteFrameName("active_strip_frame.png")


	self.m_downContainer  : addChild( self.m_rewareTitleLb )
	self.m_downContainer  : addChild( self.m_activenessLb1 )
	self.m_downContainer  : addChild( self.m_activenessLb2 )
	self.m_downContainer  : addChild( self.m_activenessLb3 )
	self.m_downContainer  : addChild( self.m_activenessLb4 )
	self.m_downContainer  : addChild( self.m_activenessLb5 )
	-- self.m_downContainer  : addChild( self.m_activenessLb6 )
	self.m_downContainer  : addChild( self.m_activenessLineImg )
	self.m_downContainer  : addChild( self.m_activenessBg )
    
    print("CActivenessView.initRewardView end")
end


function CActivenessView.loadResources(self)

    CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()

	CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("ActivenessResources/ActivenessResources.plist")

    self:loadXml()

    CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()
end

function CActivenessView.unloadResources(self)

    if self.m_canGetCCBIList ~= nil then
        for i,v in ipairs(self.m_canGetCCBIList) do
            print(" v.ccbi:removeFromParentAndCleanup( true )")
            v.ccbi:removeFromParentAndCleanup( true )
        end
    end

    self.m_canGetCCBIList = nil


    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ActivenessResources/ActivenessResources.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("ActivenessResources/ActivenessResources.pvr.ccz")


    for i,v in ipairs(self.m_iConList) do
        local r = CCTextureCache :sharedTextureCache():textureForKey("Icon/i"..tostring(v)..".jpg")
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
    end

    self:unloadXml()
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()

end

function CActivenessView.layout(self, _mainSize)

	local _winSize = CCDirector:sharedDirector():getVisibleSize()

    self.m_mainBackground :setPosition(ccp( _mainSize.width/2 , _mainSize.height/2))
	self.m_mainContainer  :setPosition(ccp( _winSize.width/2 - _mainSize.width/2 , 0))

	----------------------------
	--活动背景
	----------------------------
	local backgroundSize = self.m_background : getPreferredSize()
	self.m_background    : setPosition(ccp(_mainSize.width*0.5 ,_mainSize.height*0.5))

	----------------------------
	--关闭按钮
	----------------------------
	local closeBtnSize  = self.m_closeBtn :getContentSize()
	self.m_closeBtn : setPosition(ccp(backgroundSize.width-closeBtnSize.width/2,backgroundSize.height-closeBtnSize.height/2)) 

	----------------------------
    --主界面
    ----------------------------
    self.m_hydWordImg : setPosition(ccp( _mainSize.width/2 , 597 ))
    self.m_upBg   : setPosition(ccp( _mainSize.width/2 , 400 ))
    self.m_downBg : setPosition(ccp( _mainSize.width/2 , 122 ))

    local upBgSize 	   = self.m_upBg:getPreferredSize()
    local titleImgSize = self.m_titleImg:getPreferredSize()
    local widList 	   = self.m_listColumnWidthPos
    local height  	   = 400 + upBgSize.height/2 - titleImgSize.height/2


    self.m_titleImg  : setPosition(ccp( _mainSize.width/2 , height ))
    self.m_RWMBLabel : setPosition(ccp( widList[1] , 0 ))
	self.m_RWJDLabel : setPosition(ccp( widList[2] , 0 ))
	self.m_HYDLabel  : setPosition(ccp( widList[3] , 0 ))
	self.m_CZLabel   : setPosition(ccp( widList[4] , 0 ))

	local list = _G.Config.active_link_rewards:selectSingleNode("active_link_rewardss[0]"):children()
    self.m_rewardBtnList[tonumber(list:get(0,"active_link_rewards"):getAttribute("id"))] : setPosition(ccp( 228 , 148 ))
    self.m_rewardBtnList[tonumber(list:get(1,"active_link_rewards"):getAttribute("id"))] : setPosition(ccp( 390 , 148 ))
    self.m_rewardBtnList[tonumber(list:get(2,"active_link_rewards"):getAttribute("id"))] : setPosition(ccp( 550 , 148 ))
    self.m_rewardBtnList[tonumber(list:get(3,"active_link_rewards"):getAttribute("id"))] : setPosition(ccp( 712 , 148 ))

    self.m_rewareTitleLb : setPosition(ccp( 108 , 183 ))
    self.m_activenessLb1 : setPosition(ccp( 108 , 84 ))
    self.m_activenessLb2 : setPosition(ccp( 228 , 84 ))
    self.m_activenessLb3 : setPosition(ccp( 390 , 84 ))
    self.m_activenessLb4 : setPosition(ccp( 550 , 84 ))
    self.m_activenessLb5 : setPosition(ccp( 712 , 84 ))
    -- self.m_activenessLb6 : setPosition(ccp( 778 , 84 ))

    self.m_activenessLineImg : setPosition(ccp( _mainSize.width/2 , 67 ))
    self.m_activenessBg : setPosition(ccp( _mainSize.width/2 , 50 ))
end

function CActivenessView.initListPos( self )
	self.m_listColumnWidthPos = {}
	self.m_listColumnWidthPos[1] = -310
	self.m_listColumnWidthPos[2] = -103
	self.m_listColumnWidthPos[3] = 103
	self.m_listColumnWidthPos[4] = 333
end

function CActivenessView.createActivityItem( self, _activityInfo )

	local function local_goToCallback(eventType,obj,x,y)
		return self:goToCallback(eventType,obj,x,y)
	end

	local itemBg = CSprite :createWithSpriteFrameName( "team_list_normal.png")
    itemBg : setPreferredSize( CActivenessView.SIZE_LIST )


    -- print("CActivenessView.createActivityItem  ".._activityInfo.active_id)
    local activityNode = self:getActivityNodeById( _activityInfo.active_id )

    --标题栏
    local RWMBLabel = CCLabelTTF :create( activityNode:getAttribute("name"), "Arial", CActivenessView.FONT_SIZE )
    local RWJDLabel = CCLabelTTF :create( _activityInfo.ok_times.."/".._activityInfo.all_times, "Arial", CActivenessView.FONT_SIZE )
    local HYDLabel  = CCLabelTTF :create( "+".._activityInfo.active_vitality, "Arial", CActivenessView.FONT_SIZE )
    local FourNode

    if self.m_roleLv < tonumber(activityNode:getAttribute("lv")) then
        FourNode = CCLabelTTF :create( "未开启", "Arial", CActivenessView.FONT_SIZE )
	elseif _activityInfo.ok_times == _activityInfo.all_times then 
		FourNode = CCLabelTTF :create( "已完成", "Arial", CActivenessView.FONT_SIZE )
		FourNode : setColor( CActivenessView.GREEN )
	else
		FourNode = CButton :createWithSpriteFrameName( "前往", "general_smallbutton_normal.png" )
		FourNode : setControlName( "this CActivenessView FourNode 72 " )
    	FourNode : setFontSize( 24 )
    	FourNode : setTag( tonumber(activityNode:getAttribute("open")) )
    	FourNode : registerControlScriptHandler( local_goToCallback, "this CActivenessView FourNode 72 ")

        -- local openId = self :getActivityOpenType( activityNode:getAttribute("open") )
        -- local isOpen = self :isActivityOpen( openId )

        -- if isOpen == false then
        --     FourNode : setTouchesEnabled( false )
        -- end

	end

    itemBg :addChild( RWMBLabel )
    itemBg :addChild( RWJDLabel )
    itemBg :addChild( HYDLabel )
    itemBg :addChild( FourNode )

    local widList = self.m_listColumnWidthPos
    RWMBLabel : setPosition(ccp( widList[1] , 0 ))
	RWJDLabel : setPosition(ccp( widList[2] , 0 ))
	HYDLabel  : setPosition(ccp( widList[3] , 0 ))
	FourNode  : setPosition(ccp( widList[4] , 0 ))

	return itemBg
end

function CActivenessView.createCanGetCCBI( self, _btn )

    if _btn == nil then
        return
    end

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end

    if self.m_canGetCCBIList == nil then
        self.m_canGetCCBIList = {}
    end

    local tag = _btn:getTag()

    local list = {}
    list.idx = self.m_rewardBtnInfo[tag].id

    list.ccbi = CMovieClip:create( "CharacterMovieClip/effects_activity.ccbi" )
    list.ccbi : setControlName( "this CCBI Create_effects_activity CCBI")
    list.ccbi : registerControlScriptHandler( animationCallFunc)
    -- list.ccbi : setPosition(3,15)
    _btn:addChild( list.ccbi, 300 )

    table.insert( self.m_canGetCCBIList, list )

end

function CActivenessView.showSureBox( self, _msg )

    print("-------showSureBox  ",self.m_scenceLayer)
    --CCMessageBox( _msg, "提示" )
    -- local surebox  = CErrorBox()
    -- local BoxLayer = surebox : create(_msg)
    -- self.m_scenceLayer : addChild(BoxLayer,1000)

end


--初始化数据成员
function CActivenessView.initParams( self)
	--注册mediator
    _G.pCActivenessMediator = CActivenessMediator(self)
    controller :registerMediator(_G.pCActivenessMediator)--先注册后发送 否则会报错  

    self.m_roleLv = _G.g_characterProperty:getMainPlay():getLv()

    self.m_openFunList = {}
    if _G.pCFunctionOpenProxy :getInited() then
        self.m_openFunList = _G.pCFunctionOpenProxy :getSysId()
    end

    self.m_iConList = {}
end



--释放成员
function CActivenessView.realeaseParams( self)
	--反注册mediator
    if _G.pCActivenessMediator ~= nil then
		controller :unregisterMediator(_G.pCActivenessMediator)
		_G.pCActivenessMediator = nil
	end
    self:unloadResources()
end

function CActivenessView.init(self, _mainSize)
	--加载资源
	self:loadResources()
	--初始化数据
    self:initParams()
    --初始化界面
	self:initView(_mainSize)
	--布局成员
	self:layout(_mainSize)
	--请求界面信息
 	self :sendRquestViewMessage()
end

function CActivenessView.scene(self)
	local _winSize  = CCDirector:sharedDirector():getVisibleSize()
	local _mainSize = CCSizeMake( 854, _winSize.height )
	self.m_scenceLayer = CCScene:create()
	self:init( _mainSize, _data)
	return self.m_scenceLayer
end



function CActivenessView.isActivityOpen( self, _id )

    if _id == 100 then 
        --普通副本
        return true
    end

    for i,v in ipairs(self.m_openFunList) do
        if tonumber(v) == tonumber(_id) then 
            return true
        end
    end
    return false
end



--*****************
--xml管理
--*****************
--加载xml文件
function CActivenessView.loadXml( self )

	_G.Config:load( "config/active_link.xml")
	_G.Config:load( "config/active_link_rewards.xml")
	_G.Config:load( "config/goods.xml")

end

function CActivenessView.unloadXml( self )
    _G.Config:unload( "config/active_link.xml")
    _G.Config:unload( "config/active_link_rewards.xml")
end

function CActivenessView.getActivityNodeById( self, _id )

	local node = _G.Config.active_links :selectSingleNode( "active_link[@id="..tostring(_id).."]" )
    return node
    
end

function CActivenessView.getGoodsNodeById( self, _id )

	local node = _G.Config.goodss :selectSingleNode( "goods[@id="..tostring(_id).."]" )
    return node
    
end


--************************
--按钮回调
--************************
--关闭 单击回调
function CActivenessView.closeBtnCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
			self :realeaseParams()
			CCDirector:sharedDirector():popScene()
		end
	end
end



--物品展示 单击回调
function CActivenessView.goodsTouchCallback(self, eventType, obj, touches)
	if eventType == "TouchesBegan" then
        --删除Tips
        _G.g_PopupView :reset()
        local touchesCount = touches:count()
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.index       = obj   :getTag()
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
            if touch2:getID() == self.touchID and self.index == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

                	

                	local tag  = obj:getTag()
                	local info = self.m_rewardBtnInfo[tag]
                	print( "物品展示  goodsId="..self.m_rewardBtnInfo[tag].goodsId )
                	if info.canGet then
                		print("领取啦")
                		self:sendGetRewardMessage(info.id)
                	else
                		local index     = tonumber(obj:getTag())
	                    local goodsId   = info.goodsId
	                    local _winSize  = CCDirector:sharedDirector():getVisibleSize()
						local _mainSize = CCSizeMake( 854, _winSize.height )

                		local _position = {}
	                    _position.x = touch2Point.x -- (_winSize.width/2-_mainSize.width/2)
	                    _position.y = touch2Point.y

						local temp = _G.g_PopupView :createByGoodsId( goodsId, 10, _position)
						self.m_scenceLayer :addChild( temp )
                	end

                    self.touchID     = nil
                    self.index       = nil
                end
            end
        end
        print( eventType,"END")
    end
end


function CActivenessView.goToCallback(self, eventType, obj, x, y)
	if eventType == "TouchBegan" then
		_G.g_PopupView :reset()
		return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
	elseif eventType == "TouchEnded" then
		if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
            local tag = obj:getTag()
            self :realeaseParams()
            CCDirector:sharedDirector():popScene()

            if _G.g_CFunOpenManager ~= nil then
                _G.g_CFunOpenManager : openActivityById( tag )
            end
		end
	end
end



--************************
--发送协议
--************************
--请求界面
function CActivenessView.sendRquestViewMessage( self )
	require "common/protocol/auto/REQ_ACTIVITY_ASK_LINK_DATA"
	local msg = REQ_ACTIVITY_ASK_LINK_DATA()
	CNetwork : send( msg )
end

function CActivenessView.sendGetRewardMessage( self, _idx )
	require "common/protocol/auto/REQ_ACTIVITY_ASK_REWARDS"
	local msg = REQ_ACTIVITY_ASK_REWARDS()
	msg : setId( tonumber( _idx ) )
	CNetwork : send( msg )
end

function CActivenessView.geRewardCallBack( self, _idx )
	
	-- self:showSureBox( "领取成功" )
    for i,v in ipairs(self.m_canGetCCBIList) do
        if _idx == v.idx then
            v.ccbi:removeFromParentAndCleanup( true )
            table.remove(self.m_canGetCCBIList,i)
            break
        end
    end

    local goodsNode = self:getGoodsNodeById( self.m_rewardBtnInfo[_idx].goodsId )
	local icon = CSprite : create( "Icon/i"..goodsNode:getAttribute("icon")..".jpg" )
	self.m_rewardBtnList[_idx] : addChild( icon, 100 )
	self.m_rewardBtnInfo[_idx].canGet = false

    local iconSize = icon : getPreferredSize()
    local noticLb = CCLabelTTF :create( "已领取", "Arial", 18 )
    noticLb : setColor( ccc4( 255,225,0,255 ) )
    noticLb : setAnchorPoint( ccp( 0.5, 0 ) )
    noticLb : setPosition( ccp( 0, iconSize.height/2+3 ) )
    icon    : addChild( noticLb, 10 )

    table.insert(self.m_iConList,goodsNode:getAttribute("icon"))

    local hasCanGetReward = false
    for i,v in ipairs(self.m_rewardBtnInfo) do
        if v.canGet then
            hasCanGetReward = true
            break
        end
    end

    print("geRewardCallBack---->",hasCanGetReward)
    if not hasCanGetReward then
        print("geRewardCallBack---->  111",hasCanGetReward)
        _G.g_GameDataProxy : setIsActivenessCCBIHere( false )
        if _G.pCActivityIconView ~= nil then
            print("geRewardCallBack---->  222",hasCanGetReward)
            _G.pCActivityIconView:removeActivenessCCBI()
        end
    end

end


function CActivenessView.setRewardView( self, _vitality, _rewardCount, _rewards )
	
	print("-------setRewardView------",_vitality)
	-- _vitality = 75
	if _vitality ~= 0 then
        if _vitality > 110 then
            _vitality = 110
        end
		local width  = _vitality/110*(727-16)
		local bgSize = self.m_activenessBg : getPreferredSize()
		local activenessSpr = CSprite : createWithSpriteFrameName( "active_exp_frame.png", CCRectMake( 11,0,2,16 ) )
		activenessSpr : setPreferredSize( CCSizeMake( width,16 ) )
		activenessSpr : setPosition( -bgSize.width/2 + width/2+8, 0 )
		self.m_activenessBg : addChild( activenessSpr,10 )
	end

	local count = self:getGoodsCount(_vitality)
	for i=1,4 do
		if i>count then 
			print( "------- i->"..i,self.m_rewardBtnList[i] )
			self.m_rewardBtnList[i] : setGray()
		else
			self.m_rewardBtnList[i] : setDefault()
			local tag   = self.m_rewardBtnList[i]:getTag()
			local isGet = false
			for j,v in ipairs( _rewards ) do
				if v.id == self.m_rewardBtnInfo[tag].id then 
					isGet = true
				end
			end
			if isGet then 
				print("已领取   换图片")
                
                local goodsNode = self:getGoodsNodeById( self.m_rewardBtnInfo[tag].goodsId )
				local icon = CSprite : create( "Icon/i"..goodsNode:getAttribute("icon")..".jpg" )
	    		self.m_rewardBtnList[i] : addChild( icon, 100 )

                local iconSize = icon : getPreferredSize()
                local noticLb = CCLabelTTF :create( "已领取", "Arial", 18 )
                noticLb : setColor( ccc4( 255,225,0,255 ) )
                noticLb : setAnchorPoint( ccp( 0.5, 0 ) )
                noticLb : setPosition( ccp( 0, iconSize.height/2+3 ) )
                icon    : addChild( noticLb, 10 )

                table.insert(self.m_iConList,goodsNode:getAttribute("icon"))
			else
                self:createCanGetCCBI( self.m_rewardBtnList[i] )

				self.m_rewardBtnInfo[tag].canGet = true
			end
		end
	end



end


function CActivenessView.setActivityListView( self, _active_data )
	
	if self.m_activityContainer ~= nil then 
		self.m_activityContainer : removeFromParentAndCleanup( true )
		self.m_activityContainer = nil
	end

	self.m_activityContainer = CContainer :create()
    self.m_activityContainer : setControlName( "this CActivenessView self.m_activityContainer 39 ")
    self.m_upContainer : addChild( self.m_activityContainer )


    self.m_pScrollView     = CPageScrollView :create(eLD_Vertical,CCSizeMake( CActivenessView.SIZE_LIST.width,CActivenessView.SIZE_LIST.height*CActivenessView.Page_Size-3 ))
    self.m_activityContainer : addChild( self.m_pScrollView,100 )

    local activeData = self:DataPaiXu( _active_data )
    local totailSize = #activeData
    local pageSize   = CActivenessView.Page_Size
    local pageCount  = math.ceil(totailSize/pageSize)
    local index 	 = totailSize

    for i=1,pageCount do
    	print( "setActivityListView   i="..i )
    	local pageContainer = CContainer :create()
    	pageContainer : setControlName( "this CActivenessView pageContainer 39 ")
    	self.m_pScrollView : addPage( pageContainer, false )

    	local roleLayout = CHorizontalLayout:create()
	    roleLayout : setCellSize( CActivenessView.SIZE_LIST )
	    -- roleLayout : setCellHorizontalSpace( 28 )
	    roleLayout : setCellVerticalSpace( 0 )
	    roleLayout : setVerticalDirection( false)
	    roleLayout : setHorizontalDirection( false)
	    roleLayout : setLineNodeSum(1)
	    roleLayout : setColumnNodeSum(4)
	    roleLayout : setPosition( CActivenessView.SIZE_LIST.width/2-2,98 )---
	    pageContainer : addChild( roleLayout,10 )

	    local count = CActivenessView.Page_Size
	    if i == 1 then 
	    	count = totailSize%pageSize
	    	if count == 0 then
	    		count = pageSize
	    	end
	    end

	    for j=count,1,-1 do
	    	print(i,j)
	    	if index <= 0 then
	    		break
	    	end
	    	local item = self:createActivityItem( activeData[index-j+1] )
	    	roleLayout : addChild( item )
	    end
	    index = index - count
	    
    end

    self.m_pScrollView : setPage( pageCount-1 )
    self.m_pScrollView : setPosition( ccp( 18,237 ) )

end

--数据排序
function CActivenessView.DataPaiXu( self, _active_data )
    local finishList = {}    -- 已完成的
    local doNowList  = {}    -- 完成1次以上的
    local noDoList   = {}    -- 1次也没有完成的
    local canNotDoList = {}  -- 没有开启的

    for i,v in ipairs(_active_data) do
        -- print("CActivenessView.DataPaiXu ----    v.active_id="..v.active_id)
        local activityNode = self:getActivityNodeById( v.active_id )

        if v.ok_times == v.all_times then
            table.insert( finishList, v )
        elseif v.ok_times > 0 then
            table.insert( doNowList, v )
        elseif self.m_roleLv < tonumber(activityNode:getAttribute("lv")) then
            table.insert( canNotDoList, v )
        else
            table.insert( noDoList, v )
        end

    end
    
    local newList = {}

    for i,v in ipairs(doNowList) do
        table.insert( newList, v )
    end

    for i,v in ipairs(noDoList) do
        table.insert( newList, v )
    end

    for i,v in ipairs(canNotDoList) do
        table.insert( newList, v )
    end
    
    for i,v in ipairs(finishList) do
        table.insert( newList, v )
    end
    
    
    


    return newList

end


function CActivenessView.getGoodsCount( self, _vitality )
	local count = 0
    local active_link_rewardsList  = _G.Config.active_link_rewards :selectSingleNode( "active_link_rewardss[0]" ):children()
    local active_link_rewardsCount = active_link_rewardsList:getCount("active_link_rewards")

    for i=0,active_link_rewardsCount-1 do
        local active_link_rewards = active_link_rewardsList:get( i, "active_link_rewards" )
        local vitality = tonumber(active_link_rewards:getAttribute( "vitality" ))
        if vitality <= tonumber( _vitality ) then
            count = count + 1
        else
            return count
        end
    end
	-- if _vitality < 25 then
	-- 	count = 0
	-- elseif _vitality < 50 then
	-- 	count = 1
	-- elseif _vitality < 75 then
	-- 	count = 2
	-- elseif _vitality < 100 then
	-- 	count = 3
	-- elseif _vitality >= 100 then
	-- 	count = 4
	-- end
	return count
end


