--日常任务
require "view/view"
--require "view/FriendUI/PopTips"
require "view/LuckyLayer/PopBox"
require "common/protocol/auto/REQ_DAILY_TASK_DROP"
require "common/protocol/auto/REQ_DAILY_TASK_REWARD"
require "common/protocol/auto/REQ_DAILY_TASK_VIP_REFRESH"

require "controller/DailyTaskCommand"
require "mediator/DailyTaskMediator"

CDailyTaskUI = class( view, function( self)
    print("日常任务界面", _G.pCDailyTaskProxy :getInited() )
     if _G.pCDailyTaskProxy :getInited() == false then
         return
     end
                     
     local mainProperty = _G.g_characterProperty : getMainPlay()
     if mainProperty== nil then
         CCMessageBox( "mainProperty为nil", mainProperty)
         return true
     end
     self.m_vipLv = tonumber( mainProperty :getVipLv())  --获取当前vip等级
     self.m_lv = tonumber( mainProperty :getLv())
     self.m_winSize = CCSizeMake( 540.0, 331.0)
end)

function CDailyTaskUI.container( self )
    local mainplay = _G.g_characterProperty :getMainPlay()
    local nPlayLv  = mainplay :getLv()
    if nPlayLv < _G.Constant.CONST_TASK_DAILY_ENTER_LV or _G.pCDailyTaskProxy :getInited() == false then
        --CCMessageBox("人物等级不足".._G.Constant.CONST_TASK_DAILY_ENTER_LV..",无法进入", "目前等级"..nPlayLv)
        return 
    end
    
	local winSize		= CCDirector:sharedDirector():getVisibleSize()
    local l_container	= CContainer :create()
	self :init( winSize, l_container)
	if self.m_pContainer :getParent() ~= nil then
		self.m_pContainer :removeFromParentAndCleanup(false)
	end
	l_container :addChild(self.m_pContainer)
	return l_container
end

function CDailyTaskUI.init( self, _winSize, _layer )
    local mainProperty = _G.g_characterProperty : getMainPlay()
    if mainProperty== nil then
        CCMessageBox( "mainProperty为nil", mainProperty)
        return true
    end
    self.m_vipLv = tonumber( mainProperty :getVipLv())  --获取当前vip等级
    print("当前vip登记-->", self.m_vipLv)
    if self.m_pContainer~=nil then
        self.m_pContainer :removeFromParentAndCleanup( true)
        self.m_pContainer = nil
    end
    self.m_pContainer   = CContainer :create()
    
	self :loadResources()                           --初始化参数
	self :initBgAndCloseBtn( _winSize, _layer )               --初始化背景及关闭按钮
    self :initLocalData()
    self :addMediator()
    
    --0 进行中 接受任务状态   1 领取任务界面(完成一次任务和完成一轮任务都需要有奖励)   2 刷新界面状态
    print("m_nState==", self.m_nState)
    if self.m_nState==0 then
        self :initLabelView()
        self :addTrackBtn()
                
    elseif self.m_nState==1 then    
        self :initLabelView() 
        self :addReceiveBtn()

    elseif self.m_nState==2 then                
        self :addUpdateDailyView()
        
    elseif self.m_nState == 3 then
        self :noticeEndView()   --提示已经结束
    end
	self :layout( _winSize)
end


function CDailyTaskUI.noticeEndView( self )
    CCLOG("当前vip等级的日常任务已经全部完成")
    self :deleteAll()
end
function CDailyTaskUI.addMediator( self )
	self :removeMediator()
    
    _G.pDailyTaskMediator = CDailyTaskMediator( self)
    controller :registerMediator( _G.pDailyTaskMediator)
end

function CDailyTaskUI.removeMediator( self)
    if _G.pDailyTaskMediator then
        controller :unregisterMediator( _G.pDailyTaskMediator)
        _G.pDailyTaskMediator = nil
    end
end

function CDailyTaskUI.loadResources( self )
end

function CDailyTaskUI.unloadResources( self )
    _G.Config : unload( "config/task_daily.xml" )
end

function CDailyTaskUI.initBgAndCloseBtn( self, _winSize, _layer )
	local function closeCallBack( eventType, obj, x, y )
    	return self :onCloseCallBack( eventType, obj, x, y)
    end
    
    --背景  540.0, 331.0
    self.m_pBackground 	= CSprite :createWithSpriteFrameName("general_thirdly_underframe.png")
    self.m_pBackground  :setControlName("this CDailyTaskUI. self.m_pBackground 41")
    self.m_pContainer 	:addChild( self.m_pBackground, -100 )
    self.m_pContainer   :setTouchesPriority( -30 )
    
    self.m_pBackground  :setTouchesPriority( self.m_pContainer :getTouchesPriority() -2)
    self.m_pBackground  :setTouchesEnabled (true )
    self.m_pBackground : setFullScreenTouchEnabled(true)
    
    --关闭按钮--
    self.m_pCloseBtn 	= CButton :createWithSpriteFrameName("","general_close_normal.png")
    self.m_pCloseBtn    :setControlName("this CDailyTaskUI. self.m_pCloseBtn 47")
    self.m_pCloseBtn 	:registerControlScriptHandler( closeCallBack, "this CDailyTaskUI. self.m_pCloseBtn 237" )
    self.m_pContainer	:addChild( self.m_pCloseBtn, -99)
    self.m_pCloseBtn 	:setTouchesPriority( self.m_pContainer :getTouchesPriority() -2)
    
    --self.m_pDialyTaskLabel  = CCLabelTTF :create( "日常任务", "Arial", 30)
    --self.m_pContainer       :addChild( self.m_pDialyTaskLabel, -99)
    
    self.m_pSprDailyTask = CSprite :create("taskInfo/dailytask_word_rcrw.png")
    self.m_pBackground  :addChild( self.m_pSprDailyTask, 10)

    --内容背景   499   157
    self.m_pContentBg  = CSprite :createWithSpriteFrameName( "general_second_underframe.png")
    self.m_pContentBgSize = CCSizeMake( self.m_winSize.width * 0.924074, self.m_winSize.height * 0.474320)
    self.m_pBackground : addChild( self.m_pContentBg, 10)
    --local winX          = _winSize.width
    --local winY          = _winSize.height
    
    self.m_pBackground  :setPreferredSize( CCSizeMake( self.m_winSize.width,  self.m_winSize.height))
    self.m_pContentBg   :setPreferredSize( self.m_pContentBgSize)
    
end

function CDailyTaskUI.initLocalData( self )
	-- body
    
    self.m_szTaskName   = ""
    self.m_szTaskContent= ""
    self.m_szCurrent    = ""
    self.m_szReward     = ""
    
    self.m_nState = 0   -- 默认追踪任务界面
    if _G.pCDailyTaskProxy~=nil then
    
        if _G.pCDailyTaskProxy :getInited()==true then
            self.m_dailyTaskData = _G.pCDailyTaskProxy :getDailyTaskData()
            if self.m_dailyTaskData==nil then
                CCMessageBox("数据为空", self.m_dailyTaskData)
                return 
            end
            
            self :setExpView()
            
            self.m_nState = tonumber( self.m_dailyTaskData.state )
            print("信息打印", self.m_dailyTaskData.node, self.m_dailyTaskData.state, self.m_dailyTaskData.left, self.m_dailyTaskData.value, self.m_dailyTaskData.count, self.m_nTurn)
            
            --local dailyNode = _G.Config.task_dailys : selectNode( "task_daily", "node", tostring( self.m_dailyTaskData.node ) )
            local dailyNode = nil
            local __node = _G.pCDailyTaskProxy :getDailyTaskInfo( self.m_dailyTaskData.node )
            print("日常--数据--读取", __node)
            if __node ~= nil and __node :isEmpty() == false then
                dailyNode = {}
                dailyNode.value     = __node :getAttribute( "value" )
                dailyNode.desc      = __node :getAttribute( "desc" )
                dailyNode.exp       = __node :getAttribute( "exp" )
                dailyNode.copys_id  = __node :getAttribute( "copys_id" )
                dailyNode.type      = __node :getAttribute( "type" )
                
                -- exp * lv * ( 1 + 0.2 * ( self.m_nTurn - 1 ) )
                local expMath = tonumber( dailyNode.exp ) * self.m_lv * ( 1 + 0.2 * ( self.m_nTurn - 1 ) )
                print("expMath ==", dailyNode.exp, self.m_lv, self.m_nTurn, expMath )
                dailyNode.exp   = tostring( math.modf( expMath ) )
            end
            
            --print("dailyNode.desc", dailyNode.desc, dailyNode.value)
            local nCurrent      = 10-tonumber(self.m_dailyTaskData.left)
            if nCurrent <0 or nCurrent>10 then
                nCurrent=10
            end
            --------
            --------
            self.m_nPosY = 0
            if nCurrent==10 then
                --待读取奖励纪录  需要策划给数据 --完成
                self.m_szCurrent = "这一轮日常任务已经完成，恭喜你获得[体力药水]"
                self.m_nPosY  =  50
                return
            end
            
            if dailyNode==nil then
                print("self.m_dailyTaskData.node", self.m_dailyTaskData.node)
                --CCMessageBox("日常任务读表出错", dailyNode)
                return
            end
            
            
            self.m_isColorRedOrGreen    = false    --false:红色   true:绿色
            if tonumber( self.m_dailyTaskData.value) >= tonumber( dailyNode.value) then
                self.m_isColorRedOrGreen = true
            end
            
            --当前任务 需要完成的所有次数
            self.m_nAllCount = dailyNode.value or ""
            
            self.m_szTaskName   = "当前任务进度("..tostring( self.m_dailyTaskData.value).."/".. dailyNode.value ..")"
            self.m_szTaskContent= "任务:"..dailyNode.desc
            self.m_szCurrent    = "本轮日常任务数("..nCurrent.."/10)"
            self.m_szReward     = "奖励:经验"..dailyNode.exp
            if dailyNode then
                if dailyNode.copys_id=="0" then
                    self.m_copyId       = nil
                else
                    self.m_copyId       = dailyNode.copys_id
                end
                
                self.type           = tonumber(dailyNode.type)
                
            end
        end
    end
    print("日常数据打印", self.m_szTaskName, self.m_szTaskContent, self.m_szCurrent, self.m_szReward, self.m_copyId, self.type, _G.pCDailyTaskProxy, self.m_dailyTaskData, _G.pCDailyTaskProxy :getInited())
end

function CDailyTaskUI.initLabelView( self)
    self.m_labelLayer = CContainer :create()
    self.m_pContainer :addChild( self.m_labelLayer)
	-- body
    local szFontName = "Arial"
    local nFontSize  = 20
    print("CDailyTaskUI.initLabelView", self.m_labelLayer)
    self.m_pTaskNameLabel       = CCLabelTTF :create( self.m_szTaskName, szFontName, nFontSize)
    self.m_pTaskContentLabel    = CCLabelTTF :create( self.m_szTaskContent, szFontName, nFontSize)
    self.m_pCurrentlabel        = CCLabelTTF :create( self.m_szCurrent, szFontName, nFontSize)
    self.m_pTaskRewardLabel     = CCLabelTTF :create( self.m_szReward, szFontName, nFontSize)
    
    local color3 = ccc3( 255, 0, 0)
    if self.m_isColorRedOrGreen ~= nil and self.m_isColorRedOrGreen == true then
        color3 = ccc3( 94, 208, 18)
    end
    self.m_pTaskNameLabel   :setColor( color3)           --red
    self.m_pTaskRewardLabel :setColor( ccc3( 255, 255, 0))         --yellow
    
    --self.m_pDialyTaskLabel      :setAnchorPoint( ccp( 0.0, 0.5))
    self.m_pTaskNameLabel       :setAnchorPoint( ccp( 0.0, 0.5))
    self.m_pTaskContentLabel    :setAnchorPoint( ccp( 0.0, 0.5))
    self.m_pCurrentlabel        :setAnchorPoint( ccp( 0.0, 0.5))
    self.m_pTaskRewardLabel     :setAnchorPoint( ccp( 0.0, 0.5))
    
    self.m_labelLayer       :addChild( self.m_pTaskNameLabel, -98)
    self.m_labelLayer       :addChild( self.m_pTaskContentLabel, -98)
    self.m_labelLayer       :addChild( self.m_pCurrentlabel, -98)
    self.m_labelLayer       :addChild( self.m_pTaskRewardLabel, -98)
end

function CDailyTaskUI.addTrackBtn( self)
    self.twoBtnLayer = CContainer :create()
    self.m_pContainer :addChild(self.twoBtnLayer)
    
    local function btnCallback( eventType, obj, x, y)
        return self :onBtnCallback( eventType, obj, x, y)
    end
    
    local szSprName = "general_button_normal.png"
    local nBtnFontSize = 22
    --任务追踪按钮
    self.btnTrack   = CButton :createWithSpriteFrameName( "任务追踪", tostring( szSprName) )
    self.btnTrack    :setControlName("this CDailyTaskUI. self.btnTrack 98")
    self.btnTrack    :setFontSize( nBtnFontSize)
    self.TAG_TRACK   = 101
    self.btnTrack    :setTag( self.TAG_TRACK)
    self.btnTrack    :setTouchesPriority( self.m_pContainer :getTouchesPriority() -2)
    self.btnTrack    :registerControlScriptHandler( btnCallback, "this CDailyTaskUI. self.btnTrack  102" )
    self.twoBtnLayer      :addChild( self.btnTrack, -99)
    
    --放弃任务按钮
    self.btnGiveUp   = CButton :createWithSpriteFrameName( "放弃任务", tostring( szSprName) )
    self.btnGiveUp    :setControlName("this CDailyTaskUI. self.btnTrack 198")
    self.btnGiveUp    :setFontSize( nBtnFontSize)
    self.TAG_GIVEUP   = 201
    self.btnGiveUp    :setTag( self.TAG_GIVEUP)
    self.btnGiveUp    :setTouchesPriority( self.m_pContainer :getTouchesPriority() -2)
    self.btnGiveUp    :registerControlScriptHandler( btnCallback, "this CDailyTaskUI. self.btnTrack  102" )
    self.twoBtnLayer      :addChild( self.btnGiveUp, -99)
    
    
    local pos_Y         = 9
    local _winSize      = CCDirector :sharedDirector() :getVisibleSize()
    local winX          = _winSize.width
    local winY          = _winSize.height
    local btnSize       = self.btnTrack :getPreferredSize()
    local sizeBg        = self.m_pBackground :getPreferredSize()
    
    local nXXX = 0
    if self.m_vipLv ~=nil and self.m_vipLv >= _G.Constant.CONST_TASK_DAILY_FINISH_OPEN then    --如果大于4则显示 按钮
        --一键完成按钮
        self.btnOne   = CButton :createWithSpriteFrameName( "一键完成", tostring( szSprName) )
        self.btnOne    :setControlName("this CDailyTaskUI. self.btnOne 298")
        self.btnOne    :setFontSize( nBtnFontSize)
        self.TAG_ONE   = 301
        self.btnOne    :setTag( self.TAG_ONE )
        self.btnOne    :setTouchesPriority( self.m_pContainer :getTouchesPriority() -2)
        self.btnOne    :registerControlScriptHandler( btnCallback, "this CDailyTaskUI. self.btnOne  202" )
        self.twoBtnLayer      :addChild( self.btnOne, -99)
        self.btnOne           :setPosition( winX/2+btnSize.width*2.8 - 170, winY/2-sizeBg.height/2 +btnSize.height*0.7 + pos_Y)
        nXXX = 70
    end
    
    self.btnTrack         :setPosition( winX/2-btnSize.width*0.8 - nXXX, winY/2-sizeBg.height/2 +btnSize.height*0.7 + pos_Y)
    self.btnGiveUp        :setPosition( winX/2+btnSize.width*0.8 - 1.357143 *nXXX, winY/2-sizeBg.height/2 +btnSize.height*0.7 + pos_Y)
end

function CDailyTaskUI.removeLayer( self)
    if self.oneBtnLayer then
        self.oneBtnLayer :removeFromParentAndCleanup( true)
        self.oneBtnLayer = nil
    end
    if self.twoBtnLayer then
        self.twoBtnLayer :removeFromParentAndCleanup( true)
        self.twoBtnLayer = nil
    end
    if self.m_labelLayer~= nil then
        self.m_labelLayer :removeFromParentAndCleanup(true)
        self.m_labelLayer = nil
    end
    if self.updataLayer~=nil then
        self.updataLayer :removeFromParentAndCleanup( true)
        self.updataLayer = nil
    end

end

--更新界面
function CDailyTaskUI.addUpdateDailyView( self)
    print("self.m_dailyTaskData==", self.m_dailyTaskData)
    if self.m_dailyTaskData==nil then
        return
    end
    self.updataLayer = CContainer :create()
    self.m_pContainer :addChild( self.updataLayer)
    local nFontSize = 20
    local szFontName = "Arial"
    
    self.pUpdateLabelUp     = CCLabelTTF :create( "本日日常任务已经完成， 点击刷新可重置", szFontName, nFontSize)
    
    local function btnCallback( eventType, obj, x, y)
        return self :onBtnCallback( eventType, obj, x, y)
    end
    --刷新按钮
    local szBtn        = "刷新"
    self.btnUpdate     = CButton :createWithSpriteFrameName( szBtn, "general_button_normal.png")
    self.btnUpdate    :setControlName("this CDailyTaskUI. self.btnUpdate 218")
    self.btnUpdate    :setTouchesPriority( self.m_pContainer :getTouchesPriority() -2)
    self.btnUpdate    :setFontSize( 22)
    self.TAG_UPDATE   = 401
    self.btnUpdate    :setTag( self.TAG_UPDATE)
    self.btnUpdate    :registerControlScriptHandler( btnCallback, "this CDailyTaskUI. self.btnUpdate  221" )
    
    local nCanReset = self.m_dailyTaskData.count or 0
    local szUpdateLabel  = "(重置需花费".."999".."钻石，今日还可以重置"..self.m_dailyTaskData.count.."次)"
       
    if self.m_vipLv >=1 and self.m_vipLv <= 14 then
        if self.m_dailyTaskData.count == 0 then
            szUpdateLabel = "今天已经没有重置次数"
            self.pUpdateLabelUp :setString("")
            self.btnUpdate :setText("确定")
            --self.btnUpdate  :setTouchesEnabled( false)
        else
            self.m_nCost = _G.Constant.CONST_TASK_DAILY_REFALSH_RMB_USE
            if self.m_vipLv > 7 and self.m_dailyTaskData.count==1 then
                self.m_nCost = 2 * _G.Constant.CONST_TASK_DAILY_REFALSH_RMB_USE
            end
            
            szUpdateLabel = "重置需花费"..self.m_nCost.."钻石，今日还可以重置"..nCanReset.."次"
        end
        szBtn         = "刷新"
    end
    
    --如果不是vip
    if self.m_vipLv <= 0 then
        szUpdateLabel = "提升VIP等级可重置日常任务"
    end

    
    self.btnUpdate          :setText(szBtn)
    self.pUpdateLabelRed    = CCLabelTTF :create( szUpdateLabel, szFontName, nFontSize)
    self.pUpdateLabelRed   :setColor( ccc3( 255, 0, 0))
    
    
    
    self.updataLayer :addChild( self.btnUpdate, -99)
    self.updataLayer :addChild( self.pUpdateLabelUp)
    self.updataLayer :addChild( self.pUpdateLabelRed) 
end

function CDailyTaskUI.addReceiveBtn( self)
    self.oneBtnLayer = CContainer :create()
    self.m_pContainer :addChild( self.oneBtnLayer)
    
    local function btnCallback( eventType, obj, x, y)
        return self :onBtnCallback( eventType, obj, x, y)
    end
    --领取任务按钮
    self.btnReceive   = CButton :createWithSpriteFrameName( "领取奖励", "general_button_normal.png")
    self.btnReceive    :setFontSize( 22)
    self.btnReceive    :setTouchesPriority( self.m_pContainer :getTouchesPriority() -2)
    self.btnReceive    :setControlName("this CDailyTaskUI. self.btnTrack 98")
    self.TAG_RECEIVE   = 301
    self.btnReceive    :setTag( self.TAG_RECEIVE)
    self.btnReceive    :registerControlScriptHandler( btnCallback, "this CDailyTaskUI. self.btnTrack  102" )
    self.oneBtnLayer   :addChild( self.btnReceive, -99)
    
    local pos_Y         = 9
    local _winSize      = CCDirector :sharedDirector() :getVisibleSize()
    local winX          = _winSize.width
    local winY          = _winSize.height
    local sizeBg        = self.m_pBackground :getPreferredSize()
    local btnSize       = self.btnReceive :getPreferredSize()
    self.btnReceive     :setPosition( winX/2, winY/2-sizeBg.height/2 +btnSize.height*0.7 + pos_Y )
end

function CDailyTaskUI.layout( self, _winSize )
	-- body
    local sizeCloseBtn  = self.m_pCloseBtn :getPreferredSize()
    local winX          = _winSize.width
    local winY          = _winSize.height
    local sizeBg        = self.m_pBackground :getPreferredSize()
    print("CDailyTaskUI sizeBg大小", sizeBg.width, sizeBg.height)
    
    if winY == 640 then

        local pos_X = 10
        local pos_Y = 9

        self.m_pCloseBtn        :setPosition(ccp( winX/2+sizeBg.width/2-sizeCloseBtn.width/2-pos_X, winY/2+sizeBg.height/2-sizeCloseBtn.height/2-pos_Y))
        self.m_pBackground      :setPosition(ccp( winX/2, winY/2))
        
        --self.m_pDialyTaskLabel      :setPosition( winX/2, winY/2+sizeBg.height/2-sizeCloseBtn.height/2-20)
        self.m_pSprDailyTask :setPosition( ccp( 0, self.m_winSize.height * 0.3600))
        if self.m_labelLayer then
            if self.m_nPosY == nil then
                self.m_nPosY = 0
            end
            local nDistanceX = winX/2-sizeBg.width/2 + 40
            local nDistanceY = 45
            self.m_pTaskNameLabel       :setPosition( nDistanceX, winY/2+sizeBg.height*0.1001)
            self.m_pTaskContentLabel    :setPosition( nDistanceX, winY/2+sizeBg.height*0.1722)
            self.m_pCurrentlabel        :setPosition( nDistanceX, winY/2-nDistanceY + self.m_nPosY)
            self.m_pTaskRewardLabel     :setPosition( winX/2+sizeBg.width*0.1033, winY/2-nDistanceY)--sizeBg.height*0.1911)
        end
        
        if self.updataLayer then
            self.pUpdateLabelUp     :setPosition( winX/2, winY/2+sizeBg.height*0.1301)
            self.pUpdateLabelRed    :setPosition( winX/2, winY/2-sizeBg.height*0.1301)
            local btnSize       = self.btnUpdate :getPreferredSize()
            self.btnUpdate     :setPosition( winX/2, winY/2-sizeBg.height/2 +btnSize.height*0.7 + pos_Y)    
        end
        
        print("位置确认", self.m_labelLayer, self.updataLayer)
    elseif winY==768 then
        
	end
end




function CDailyTaskUI.onCloseCallBack( self, eventType, obj, x, y )
	if eventType == "TouchBegan" then
		return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        self :deleteAll()
		return true
	end
end

function CDailyTaskUI.deleteAll( self)
    self :removeMediator()
    CCLOG("关闭日常任务界面")
    self :removeLayer()
    if self.m_pContainer ~= nil then
        self.m_pContainer :removeFromParentAndCleanup( true)
        self.m_pContainer = nil
    end
    
    if _G.pDailyView ~= nil then
        _G.pDailyView :removeFromParentAndCleanup( true)
        _G.pDailyView = nil
    end

    self:unloadResources()
end

function CDailyTaskUI.popTipsByTag( self, _func, _szLabel, _num)
    if self.m_popTips ~= nil then
        if self.m_popTips :getIsChecked() == 1 then
            _func()
            return true
        end
    end
    
    self.m_popTips = CPopBox()
    --local popDelTips = self.m_popTips :create( dropCallBack, "是否放弃当前任务", 1)
    local popDelTips = self.m_popTips :create( _func, tostring( _szLabel), _num)
    self.m_pContainer :addChild( popDelTips)
end

function CDailyTaskUI.onBtnCallback( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
		return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
        
    elseif eventType == "TouchEnded" then
        print("按钮点击 tag()==", obj :getTag())
        
        if obj :getText() == "确定" then
            self :deleteAll()
            return true
        end
        
        if obj :getTag() == self.TAG_TRACK then             --任务追踪
            self :clickTrackBtn()
            
        elseif obj :getTag() == self.TAG_GIVEUP then        --放弃任务
            local function dropCallBack( )
                local dropMsg =REQ_DAILY_TASK_DROP()
                CNetwork :send( dropMsg)
            end
        
            print("self.m_dailyTaskData.left", self.m_dailyTaskData.left)
            if self.m_dailyTaskData.left <0 or self.m_dailyTaskData.left >10 then
                --CCMessageBox("该轮日常任务已完", self.m_dailyTaskData.left)
                local msg = "该轮日常任务已完"
                self : createMessageBox(msg)
                return true
            end
            --local l_popTips = CPopTips()
            self :popTipsByTag( dropCallBack, "是否放弃当前任务", 1)
    
        elseif obj :getTag() == self.TAG_RECEIVE then
            if self.m_nState == 1 then
                --local function receiveCallback( )
                local recMsg = REQ_DAILY_TASK_REWARD()
                CNetwork :send( recMsg)
                --[[end
                
                local l_popTips = CPopTips()
                local popDelTips = l_popTips :create( receiveCallback, "该轮日常任务已经完成，恭喜获得奖励", 0)
                self.m_pContainer :addChild( popDelTips)
                 --]]
            else
                print("任务进行中")
        
            end
        elseif obj :getTag() == self.TAG_UPDATE then                        --刷新界面
            print("刷新")
            self :clickUpdate()
        
        elseif obj :getTag() == self.TAG_ONE then
            CCLOG( "一键完成日常任务" )
            self :REQ_DAILY_TASK_KEY()
        end
		return true
	end
end

function CDailyTaskUI.REQ_DAILY_TASK_KEY( self )
    CCLOG("<><><><><><><><><>>REQ_DAILY_TASK_KEY-->\n")
    require "common/protocol/auto/REQ_DAILY_TASK_KEY"
    local msg = REQ_DAILY_TASK_KEY()
    CNetwork :send( msg )
    CCLOG( "49207请求 REQ_DAILY_TASK_KEY")
end

function CDailyTaskUI.clickTrackBtn( self)
    if self.type==nil then
        --CCMessageBox("日常任务类型为空", self.type)
        CCLOG("日常任务类型为空"..self.type)
        return
    end
    local roleProperty = _G.g_characterProperty : getMainPlay()
    
    _G.pCDailyTaskProxy : setStartData( true )
    print("self.type", self.type, self.m_copyId)
    self :deleteAll()
    --print("来不来")
    if self.type==_G.Constant.CONST_TASK_DAILY_STRENGTH_EQUIP then      --强化装备
        --CCMessageBox("强化装备", "")
        require "view/EquipInfoView/EquipInfoView"
        _G.g_CEquipInfoView = CEquipInfoView()
        CCDirector : sharedDirector () : pushScene( _G.g_CEquipInfoView :scene())
    elseif self.type==_G.Constant.CONST_TASK_DAILY_REFRESH_COPY then    --刷副本
        print("dsffsfsdfdsf" )
        if self.m_copyId then
            print("要去的副本id=", self.m_copyId)
            --设置要去的副本类型
            
            if roleProperty then
                --得到副本所在章节id
                local sceneCopysNode = _G.pCDailyTaskProxy :getSceneCopys( self.m_copyId)
                --print("sceneCopysNodesceneCopysNode", sceneCopysNode, sceneCopysNode :isEmpty() )
                if sceneCopysNode ~= nil and sceneCopysNode :isEmpty() == true  then
                    CCLOG("空空空 "..self.m_copyId)
                    return
                end
                print("sceneCopysNode.belong_id", sceneCopysNode :getAttribute("belong_id") )
                roleProperty :setTaskInfo( _G.Constant.CONST_TASK_TRACE_DAILY_TASK, self.m_copyId, tonumber( sceneCopysNode :getAttribute("belong_id") or "0"), self.m_dailyTaskData.value or "", self.m_nAllCount or "")
            end
            --去当前场景的传送门
            local NowSenceId = _G.g_Stage : getScenesID()
            print("去当前任务的传送门", NowSenceId)
            _G.g_CTaskNewDataProxy  :gotoDoorsPos( NowSenceId , 1)
        end
    elseif self.type==_G.Constant.CONST_TASK_DAILY_DOUQI then           --领悟斗气
        --CCMessageBox("去斗气", "")
        CCLOG("斗气")
        _G.pCVindictivePanelView = CVindictivePanelView()
        CCDirector :sharedDirector() :pushScene( _G.pCVindictivePanelView :scene())
        
    elseif tonumber( self.type ) == _G.Constant.CONST_TASK_DAILY_LINK_COPYS then    --连击副本 
        CCLOG( "连击次数" )
    
        if roleProperty ~= nil then
            roleProperty :setTaskInfo()     --清空数据
        end
        --打开副本界面
        require "view/DuplicateLayer/DuplicateSelectPanelView"
         --副本界面
        local tempview = CDuplicateSelectPanelView()
        CCDirector :sharedDirector() :pushScene( tempview :scene())
    end
end

function CDailyTaskUI.clickUpdate( self)
    print("玩家vip等级＝＝", self.m_vipLv, self.m_dailyTaskData.count)
    if self.m_dailyTaskData.count <=0 or self.m_vipLv<=0 then
        --进入推荐充值界面
        --CCMessageBox("您不是vip，请充值成为vip")
        if self.m_nState == 2 then
            local function goChargeCallback( )
                --[[
                self :deleteAll()
                require "view/GMWin/DevelopTool"
                local tool = CDevelopTool : scene();
                CCDirector : sharedDirector () : pushScene(tool);
                 --]]
                local command = CPayCheckCommand( CPayCheckCommand.ASK )
                controller :sendCommand( command )
            end
        
            if self.m_popTips == nil then
                self.m_popTips = CPopBox()
            end
            --local l_popTips = CPopBox()
            local popDelTips = self.m_popTips :create( goChargeCallback, "VIP等级不足，请充值VIP", 0)
            self.m_pContainer :addChild( popDelTips)
        end
        return  true
    end

    --获取钻石
    local mainProperty = _G.g_characterProperty : getMainPlay()
    local nDiamond     = mainProperty :getRmb() +mainProperty :getBindRmb()

    if nDiamond >= self.m_nCost then
        local function goConsumeCallback( )         --消费
            local updateMsg = REQ_DAILY_TASK_VIP_REFRESH()
            CNetwork :send( updateMsg)
        end
    
        if self.m_popTips == nil then
            self.m_popTips = CPopBox()
        end
        --local l_popTips = CPopBox()
        local popDelTips = self.m_popTips  :create( goConsumeCallback, "重置需要使用"..self.m_nCost.."钻石", 0)
        self.m_pContainer :addChild( popDelTips)
    else
        local function goChargeCallback( )
            self :deleteAll()
            --[[
            require "view/GMWin/DevelopTool"
            local tool = CDevelopTool : scene();
            CCDirector : sharedDirector () : pushScene(tool);
             --]]
            local command = CPayCheckCommand( CPayCheckCommand.ASK )
            controller :sendCommand( command )
        end

        if self.m_popTips == nil then
            self.m_popTips = CPopBox()
        end
        --local l_popTips = CPopBox()
        local popDelTips = self.m_popTips  :create( goChargeCallback, "钻石不够，请充值", 0)
        self.m_pContainer :addChild( popDelTips)
    end
end

function CDailyTaskUI.setUpdate( self, _data)
    if _data==nil then
       return
    end
    self :removeLayer()
    self :initLocalData()
    
    if self.m_nState==0 then
        self :initLabelView()
        self :addTrackBtn()
        
    elseif self.m_nState==1  then
        self :initLabelView()
        self :addReceiveBtn()
        
    elseif self.m_nState==2  then
        self :addUpdateDailyView()
        
    elseif self.m_nState == 3 then
        self :noticeEndView()
    end
    
    print("CDailyTaskUI.setUpdate", _data.node, _data.value, _data.state, _data.left)
    local _winSize = CCDirector :sharedDirector() :getVisibleSize()
    self :layout( _winSize)
end

function CDailyTaskUI.createMessageBox(self,_msg)
    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create(_msg)
    self.m_pContainer : addChild(BoxLayer,1000)
end


function CDailyTaskUI.setExpView( self )
    print("日常任务turn-->", _G.pCDailyTaskProxy :getTurn() )
    self.m_nTurn = _G.pCDailyTaskProxy :getTurn()
end


