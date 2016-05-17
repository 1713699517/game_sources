--[[
 --CChallengePanelView
 --逐鹿台主界面
 --]]


require "view/view"
require "mediator/mediator"
require "controller/command"

require "mediator/ChallengePanelMediator"
require "view/ChallengePanelLayer/TopListPanelView"
require "view/ChallengePanelLayer/StartView"

require "common/protocol/auto/REQ_ARENA_DAY_REWARD"
require "common/protocol/auto/REQ_ARENA_CLEAN"
require "common/protocol/auto/REQ_ARENA_BUY_YES"
require "common/protocol/auto/REQ_ARENA_BUY"




CChallengePanelView = class(view, function( self)
    print("CChallengePanelView:逐鹿台主界面")
end)
--Constant:
CChallengePanelView.TAG_RECEIVEAWARDS     = 201
CChallengePanelView.TAG_WORKHARDPANEL     = 202
CChallengePanelView.TAG_CHALLENGETOP      = 203
CChallengePanelView.TAG_RESETTIME         = 204
CChallengePanelView.TAG_BUYTIMES          = 205
CChallengePanelView.TAG_CLOSED            = 206

CChallengePanelView.TAG_ROLELIST          = 1500

CChallengePanelView.FONT_SIZE             = 20
CChallengePanelView.FONT_SIZE_BUTTON      = 24

CChallengePanelView.COLOR_YERROW          = ccc4( 255,255,0,255 )

CChallengePanelView.SIZE_MAIN             = CCSizeMake( 854,640 )

--加载资源
function CChallengePanelView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ChallengeResources/ChallengeResources.plist")
end
--释放资源
function CChallengePanelView.unloadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ChallengeResources/ChallengeResources.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("ChallengeResources/ChallengeResources.pvr.ccz")

    for i,v in ipairs(self.m_createResStrList) do
        local r = CCTextureCache :sharedTextureCache():textureForKey(v)
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
    end
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end
--初始化数据成员
function CChallengePanelView.initParams( self, layer)
    print("CChallengePanelView.initParams")
    self.m_mediator = CChallengePanelMediator( self)
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
    self :registerEnterFrameCallBack()

    self.m_createResStrList = {}
end

function CChallengePanelView.cleanUpMediator( self )
    if self.m_mediator ~= nil then
        _G.controller :unregisterMediator( self.m_mediator )
    end
end

--释放成员
function CChallengePanelView.realeaseParams( self)
end

--布局成员
function CChallengePanelView.layout( self, winSize)

    local mainSize = CChallengePanelView.SIZE_MAIN

    self.m_background    :setPosition( ccp( winSize.width/2, winSize.height/2 ) )
    self.m_mainContainer :setPosition( ccp( winSize.width/2 - mainSize.width/2, 0 ) )

    local challengepanelbackgroundfirst     = self.m_challengePanelViewContainer :getChildByTag( 100)
    local challengepanelbackgroundrightdown = self.m_challengePanelViewContainer :getChildByTag( 101)
    local challengepanelbackgroundup        = self.m_challengePanelViewContainer :getChildByTag( 102)
    local challengepanelbackgroundleftdown  = self.m_challengePanelViewContainer :getChildByTag( 103)
    local buttonSize                        = self.m_receiveAwardsButton :getPreferredSize()
    local closeSize                         = self.m_closedButton: getPreferredSize()

    challengepanelbackgroundfirst :setPreferredSize( mainSize )
    challengepanelbackgroundrightdown :setPreferredSize( CCSizeMake( 355, 260))  --0.96  0.86
    challengepanelbackgroundup :setPreferredSize( CCSizeMake( 824, 287))
    challengepanelbackgroundleftdown :setPreferredSize( CCSizeMake( 465, 260))

    challengepanelbackgroundfirst     :setPosition( ccp( mainSize.width/2, mainSize.height/2))
    challengepanelbackgroundrightdown :setPosition( ccp( 661, 145))
    challengepanelbackgroundup        :setPosition( ccp( mainSize.width/2, 423))
    challengepanelbackgroundleftdown  :setPosition( ccp( 247, 145))

    local cellSize = CCSizeMake( mainSize.width*0.2, CChallengePanelView.FONT_SIZE+12)
    self.m_myInfoLayout :getCellVerticalSpace(20)
    self.m_myInfoLayout :setLineNodeSum(1)
    self.m_myInfoLayout :setCellSize( cellSize)
    self.m_myInfoLayout :setPosition( 0, 220)

    local rolecellSize = CCSizeMake( 180, 247 )
    self.m_roleLayout :setVerticalDirection(false)
    self.m_roleLayout :setCellHorizontalSpace( 18)
    self.m_roleLayout :setLineNodeSum(4)
    self.m_roleLayout :setCellSize( rolecellSize)

    self.m_roleLayout :setPosition(  40, 423 )
    self.m_topRankingLabel :setPosition( ccp( 30, 600))
    self.m_awardsInfoLabel :setPosition( ccp( 190, 600))
    self.m_receiveAwardsLabel :setPosition( ccp( 665, 600 ))
    self.m_receiveAwardsButton :setPosition( ccp( 665, 600 ))
    self.m_workHardButton :setPosition( ccp ( 350, 182))
    self.m_challengeTopButton :setPosition( ccp( 350,103))
    self.m_resetChallengeTimeLabel :setPosition( ccp( 666, 240))
    self.m_resetChallengeTimeButton :setPosition( ccp( 666, 187))
    self.m_buyChallengeTimesNoticLabel :setPosition( ccp( 666, 113 ) )
    self.m_buyChallengeTimesLabel :setPosition( ccp( 727, 113 ))
    self.m_buyChallengeTimesButton :setPosition( ccp( 666, 57))
    self.m_closedButton: setPosition( ccp( mainSize.width-closeSize.width/2, mainSize.height-closeSize.height/2))
end

--主界面初始化
function CChallengePanelView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --请求服务端消息
    self.requestService(self)
    --布局成员
    self.layout(self, winSize)

    --初始化指引
    _G.pCGuideManager:initGuide( self.m_guideButton , _G.Constant.CONST_FUNC_OPEN_LISTS )

end

function CChallengePanelView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CChallengePanelView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)

    local function local_onEnter(eventType, obj, x, y)
        return self:onEnter(eventType, obj, x, y)
    end
    self.m_scenelayer : registerControlScriptHandler(local_onEnter,"CChallengePanelView scene self.m_scenelayer 136")

    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CChallengePanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CChallengePanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

function CChallengePanelView.onEnter( self,eventType, obj, x, y )
    if eventType == "Enter" then
        --初始化指引
        print("CChallengePanelView.onEnter  ")
        -- _G.pCGuideManager:initGuide( self.m_scenelayer , _G.Constant.CONST_FUNC_OPEN_ROLE)
    elseif eventType == "Exit" then
        _G.pCGuideManager:exitView( _G.Constant.CONST_FUNC_OPEN_MONEYTREE )
    end
end

--请求服务端消息
function CChallengePanelView.requestService ( self)
    require "common/protocol/auto/REQ_ARENA_JOIN"
    local msg = REQ_ARENA_JOIN()
    _G.CNetwork :send( msg)
end

function CChallengePanelView.registerEnterFrameCallBack(self)
    print( "CChallengePanelView.registerEnterFrameCallBack")
    local function onEnterFrame( _duration )
        --_G.pDateTime : reset()
        --local nowTime = _G.pDateTime : getTotalMilliseconds() --毫秒数
        self :updataReceiveAwardsTime( _duration)
        self :updataResetChallengeTime( _duration)
    end
    self.m_scenelayer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CChallengePanelView.updataReceiveAwardsTime( self, _duration)
    if self.m_receiveawardstime == nil or self.m_receiveawardstime <= 0 then
        return
    end
    self.m_receiveawardstime = self.m_receiveawardstime - _duration
    if self.m_receiveawardstime <= 0 then
        self.m_receiveAwardsButton :setVisible( true)
        self.m_receiveAwardsLabel :setString( "")
    else
        self.m_receiveAwardsButton :setVisible( false)
        local fomarttime = self :turnTime( self.m_receiveawardstime)
        self.m_receiveAwardsLabel :setString( "领取时间 : "..fomarttime)
    end
end

function CChallengePanelView.updataResetChallengeTime( self, _duration)
    if self.m_resetchallengetime == nil or self.m_resetchallengetime <= 0 then
        return
    end
    self.m_resetchallengetime = self.m_resetchallengetime - _duration
    self : updateCDTime()
end

function CChallengePanelView.updateCDTime( self )
    local fomarttime = self :turnTime( self.m_resetchallengetime)
    self.m_resetChallengeTimeLabel :setString(  "冷却时间 : "..fomarttime)
end


--创建单个玩家
function CChallengePanelView.createRole( self, _player)
    local _rolebutton    = CButton :createWithSpriteFrameName( "","general_underframe_normal.png")
    local _rolespriteBG  = CSprite :createWithSpriteFrameName( "general_role_head_frame_normal.png")
    local _rolesprite    = CSprite :create( "HeadIconResources/role_head_0".._player.pro..".jpg")
    local _rolenameBG    = CSprite :createWithSpriteFrameName( "arena_name_frame.png")
    local _rolerankBG    = CSprite :createWithSpriteFrameName( "arena_pmzl.png")
    local _roleLVlabel   = CCLabelTTF :create( _player.lv, "Arial", CChallengePanelView.FONT_SIZE)
    local _rolenamelabel = CCLabelTTF :create( _player.name, "Arial", CChallengePanelView.FONT_SIZE)
    local _roleranklabel = CCLabelTTF :create( _player.ranking, "Arial", CChallengePanelView.FONT_SIZE)
    local _rolePowerlabel= CCLabelTTF :create( _player.power, "Arial", CChallengePanelView.FONT_SIZE)
    local rolebuttonSize = CCSizeMake( 180, 247)

    table.insert(self.m_createResStrList,"HeadIconResources/role_head_0".._player.pro..".jpg" )

    local function CallBack( eventType, obj, x, y)
        return self :clickRoleCallBack( eventType, obj, x, y)
    end
    _rolesprite :setControlName( "this CChallengePanelView _rolesprite ")
    _rolebutton :setControlName( "this CChallengePanelView _rolebutton ")

    _rolebutton :setPreferredSize( rolebuttonSize)
    _rolebutton :setTag( _player.uid)
    _rolebutton :registerControlScriptHandler( CallBack, "this CChallengePanelView _rolebutton CallBack")

    _roleranklabel  :setColor( CChallengePanelView.COLOR_YERROW )
    _rolePowerlabel :setColor( CChallengePanelView.COLOR_YERROW )

    _roleranklabel  :setAnchorPoint( ccp( 0,0.5 ) )
    _rolePowerlabel :setAnchorPoint( ccp( 0,0.5 ) )

    _rolenameBG    :setPosition( ccp( 0, 105))
    _rolerankBG    :setPosition( ccp( 0, -75))
    _roleLVlabel   :setPosition( ccp( -59, 104))
    _rolenamelabel :setPosition( ccp( 19, 104))
    _roleranklabel :setPosition( ccp( -7, -60))
    _rolePowerlabel:setPosition( ccp( -7, -91))
    _rolespriteBG  :setPosition( ccp( 0, 20))
    _rolesprite    :setPosition( ccp( 0, 20))

    _rolebutton :addChild( _rolesprite,5)
    _rolebutton :addChild( _rolespriteBG,5)
    _rolebutton :addChild( _rolenameBG,5)
    _rolebutton :addChild( _rolerankBG,5)
    _rolebutton :addChild( _roleLVlabel,5)
    _rolebutton :addChild( _rolenamelabel,5)
    _rolebutton :addChild( _roleranklabel,5)
    _rolebutton :addChild( _rolePowerlabel,5)
    return _rolebutton
end

--创建按钮Button
function CChallengePanelView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CChallengePanelView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CChallengePanelView ".._controlname)
    m_button :setFontSize( CChallengePanelView.FONT_SIZE_BUTTON )
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CChallengePanelView ".._controlname.."CallBack")
    return m_button
end

--创建玩家自己的信息
function CChallengePanelView.createMyInfo( self)
    --玩家自己的信息
    self.m_myNameLabel                = CCLabelTTF :create( "玩家名字", "Arial", CChallengePanelView.FONT_SIZE)
    self.m_myPowerLabel               = CCLabelTTF :create( "战力 : ", "Arial", CChallengePanelView.FONT_SIZE)
    self.m_myRankLabel                = CCLabelTTF :create( "排名 : ", "Arial", CChallengePanelView.FONT_SIZE)
    self.m_myConsecutiveVictoryLabel  = CCLabelTTF :create( "连胜 : ", "Arial", CChallengePanelView.FONT_SIZE)
    self.m_myPrestigeLabel            = CCLabelTTF :create( "声望 : ", "Arial", CChallengePanelView.FONT_SIZE)

    self.m_myPowerLabel              :setColor( CChallengePanelView.COLOR_YERROW )
    self.m_myRankLabel               :setColor( CChallengePanelView.COLOR_YERROW )
    self.m_myConsecutiveVictoryLabel :setColor( CChallengePanelView.COLOR_YERROW )
    self.m_myPrestigeLabel           :setColor( CChallengePanelView.COLOR_YERROW )

    self.m_myPowerLabel :setAnchorPoint( ccp( 0, 1))
    self.m_myNameLabel  :setAnchorPoint( ccp( 0, 1))
    self.m_myRankLabel  :setAnchorPoint( ccp( 0, 1))
    self.m_myConsecutiveVictoryLabel :setAnchorPoint( ccp( 0, 1))
    self.m_myPrestigeLabel :setAnchorPoint( ccp( 0, 1))

    self.m_myInfoLayout     = CHorizontalLayout :create()
    local cellSize = CCSizeMake( 200, 30)
    self.m_myInfoLayout :setVerticalDirection(false)
    self.m_myInfoLayout :setCellHorizontalSpace( 10)
    self.m_myInfoLayout :setLineNodeSum(1)
    self.m_myInfoLayout :setCellSize( cellSize)

    self.m_myInfoLayout :addChild( self.m_myNameLabel)
    self.m_myInfoLayout :addChild( self.m_myPowerLabel)
    self.m_myInfoLayout :addChild( self.m_myRankLabel)
    self.m_myInfoLayout :addChild( self.m_myConsecutiveVictoryLabel)
    self.m_myInfoLayout :addChild( self.m_myPrestigeLabel)
    --self.m_challengePanelViewContainer :addChild( self.m_myInfoLayout)
    return self.m_myInfoLayout
end




--初始化背包界面
function CChallengePanelView.initView(self, layer)
    print("CChallengePanelView.initView")
    --副本界面容器

    local winSize  = CCDirector :sharedDirector() :getVisibleSize()
    self.m_background = CSprite :createWithSpriteFrameName("peneral_background.jpg")
    self.m_background : setControlName( "this CFirstTopupGiftView self.m_background 26 ")
    self.m_background : setPreferredSize( winSize )
    layer : addChild( self.m_background )

    self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CChallengePanelView self.m_mainContainer 104" )
    layer : addChild( self.m_mainContainer)

    self.m_challengePanelViewContainer = CContainer :create()
    self.m_challengePanelViewContainer : setControlName("this is CChallengePanelView self.m_challengePanelViewContainer 94 ")
    self.m_mainContainer :addChild( self.m_challengePanelViewContainer)

    self.m_guideButton = CButton :createWithSpriteFrameName( "", "transparent.png")
    self.m_guideButton : setControlName( "this CChallengePanelView self.m_guideButton 345 " )
    -- self.m_guideButton :registerControlScriptHandler( CallBack, "this CChallengePanelView self.m_guideButton 147")
    layer : addChild(self.m_guideButton, 2000)

    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local challengepanelbackgroundfirst    = CSprite :createWithSpriteFrameName( "general_first_underframe.png")     --背景Img
    local challengepanelbackgroundright    = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img  右
    local challengepanelbackgroundleftup   = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img  左上
    local challengepanelbackgroundleftdown = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img  左下
    challengepanelbackgroundfirst : setControlName( "this CChallengePanelView challengepanelbackgroundfirst 124 ")
    challengepanelbackgroundright : setControlName( "this CChallengePanelView challengepanelbackgroundright 125 ")
    challengepanelbackgroundleftup : setControlName( "this CChallengePanelView challengepanelbackgroundleftup 125 ")
    challengepanelbackgroundleftdown : setControlName( "this CChallengePanelView challengepanelbackgroundleftdown 125 ")

    --创建各种Button
    self.m_receiveAwardsButton         = self :createButton( "领取", "general_button_normal.png", CallBack, CChallengePanelView.TAG_RECEIVEAWARDS, "self.m_receiveAwardsButton")    --领取奖励
    self.m_workHardButton              = self :createButton( "抓苦工", "general_button_normal.png", CallBack, CChallengePanelView.TAG_WORKHARDPANEL, "self.m_workHardButton")      --抓苦工
    self.m_challengeTopButton          = self :createButton( "KO榜", "general_button_normal.png", CallBack, CChallengePanelView.TAG_CHALLENGETOP, "self.m_challengeTopButton")  --竞技排行
    self.m_resetChallengeTimeButton    = self :createButton( "清除CD", "general_button_normal.png", CallBack, CChallengePanelView.TAG_RESETTIME, "self.m_resetChallengeTimeButton") --清除CD
    self.m_buyChallengeTimesButton     = self :createButton( "购买次数", "general_button_normal.png", CallBack, CChallengePanelView.TAG_BUYTIMES, "self.m_buyChallengeTimesButton") --购买次数
    self.m_closedButton                = self :createButton( "", "general_close_normal.png", CallBack, CChallengePanelView.TAG_CLOSED, "self.m_closedButton")                            --关闭X

    self.m_topRankingLabel             = CCLabelTTF :create( "", "Arial", CChallengePanelView.FONT_SIZE)
    self.m_awardsInfoLabel             = CCLabelTTF :create( "", "Arial", CChallengePanelView.FONT_SIZE)
    self.m_receiveAwardsLabel          = CCLabelTTF :create( "", "Arial", CChallengePanelView.FONT_SIZE)
    self.m_resetChallengeTimeLabel     = CCLabelTTF :create( "", "Arial", CChallengePanelView.FONT_SIZE)
    self.m_buyChallengeTimesNoticLabel = CCLabelTTF :create( "今日还可以挑战     次", "Arial", CChallengePanelView.FONT_SIZE)
    self.m_buyChallengeTimesLabel      = CCLabelTTF :create( "", "Arial", CChallengePanelView.FONT_SIZE)
    self.m_topRankingLabel :setAnchorPoint( ccp( 0,0.5))
    self.m_awardsInfoLabel :setAnchorPoint( ccp( 0,0.5))

    self.m_receiveAwardsLabel      :setColor( CChallengePanelView.COLOR_YERROW )
    self.m_resetChallengeTimeLabel :setColor( CChallengePanelView.COLOR_YERROW )
    self.m_buyChallengeTimesLabel  :setColor( CChallengePanelView.COLOR_YERROW )

    --玩家自己的信息
    self.m_challengePanelViewContainer :addChild( self :createMyInfo())
    --添加玩家列表布局
    self.m_roleLayout     = CHorizontalLayout :create()

    self.m_challengePanelViewContainer :addChild( self.m_roleLayout)
    self.m_challengePanelViewContainer :addChild( challengepanelbackgroundfirst, -1, 100)
    self.m_challengePanelViewContainer :addChild( challengepanelbackgroundright, -1, 101)
    self.m_challengePanelViewContainer :addChild( challengepanelbackgroundleftup, -1, 102)
    self.m_challengePanelViewContainer :addChild( challengepanelbackgroundleftdown, -1, 103)
    self.m_challengePanelViewContainer :addChild( self.m_topRankingLabel)
    self.m_challengePanelViewContainer :addChild( self.m_awardsInfoLabel)
    self.m_challengePanelViewContainer :addChild( self.m_receiveAwardsLabel)
    self.m_challengePanelViewContainer :addChild( self.m_receiveAwardsButton)
    -- self.m_challengePanelViewContainer :addChild( self.m_workHardButton)
    self.m_challengePanelViewContainer :addChild( self.m_challengeTopButton)
    self.m_challengePanelViewContainer :addChild( self.m_resetChallengeTimeLabel)
    self.m_challengePanelViewContainer :addChild( self.m_resetChallengeTimeButton)
    self.m_challengePanelViewContainer :addChild( self.m_buyChallengeTimesNoticLabel)
    self.m_challengePanelViewContainer :addChild( self.m_buyChallengeTimesLabel)
    self.m_challengePanelViewContainer :addChild( self.m_buyChallengeTimesButton)
    self.m_challengePanelViewContainer :addChild( self.m_closedButton, 2)

end

--更新本地list数据
------------------------------------------------------------
function CChallengePanelView.setAwards( self, _gold, _renown)

    self.m_awardgold = _gold
    self.m_awardrenown = _renown
    local tempstring = "奖励美刀 : "..tostring( self.m_awardgold).."    奖励声望 : "..tostring( self.m_awardrenown)
    print("999999999999999:"..tempstring)
    self.m_awardsInfoLabel :setString( tempstring)
end

--领取奖励倒计时
function CChallengePanelView.setReceiveAwardsTime( self, _time, _isreceive)
    self.m_receiveawardstime = _time
    if self.m_receiveawardstime <= 0 then
        self.m_receiveawardstime = 0
    end
    if _isreceive == false then
        self.m_receiveAwardsButton :setVisible( false)
        local fomarttime = self :turnTime( self.m_receiveawardstime)
        self.m_receiveAwardsLabel :setString( "领取时间 : "..fomarttime)
    elseif _isreceive == true then
        self.m_receiveAwardsButton :setVisible( true)
        self.m_receiveAwardsLabel :setString( "")
    end
    --self.m_receiveawardstime = 12
end
function CChallengePanelView.setArenaLv( self, _arenalv)
     -- body
end
--冷却CD时间
function CChallengePanelView.setTime( self, _time)
    self.m_resetchallengetime = _time
    self : updateCDTime()
end
--可挑战人数量
function CChallengePanelView.setCount( self, _count)
    self.m_playercount = _count
end
function CChallengePanelView.setChallengeplayerlist( self, _myinfo, _playerlist, _myRenown)
    self.m_challengeplayerlist = _playerlist
    self.m_myinfo = _myinfo
    if self.m_roleLayout ~= nil then
        self.m_roleLayout :removeAllChildrenWithCleanup( true)
    end
    for k,v in pairs(self.m_challengeplayerlist) do
        if k > 4 then
            break
        end
        self.m_roleLayout :addChild( self :createRole( v))
    end
    local mainplay = _G.g_characterProperty :getMainPlay()
    local myrenown = mainplay :getRenown()      --玩家声望
    local myPower  = mainplay :getPowerful()
    print( self.m_myinfo.name, self.m_myinfo.ranking, myrenown, self.m_myinfo.win_count)
    self.m_myNameLabel :setString( self.m_myinfo.name)
    self.m_myPowerLabel : setString( "战力 : "..self.m_myinfo.power)
    self.m_myRankLabel :setString( "排名 : "..self.m_myinfo.ranking)
    self.m_myConsecutiveVictoryLabel :setString( "连胜 : "..self.m_myinfo.win_count)

    self.m_myRenown = _myRenown
    self:setNewRenown()

    if self.m_myinfo.ranking > 1000 then
        self.m_topRankingLabel :setString( "排名 : 1000名外")
    else
        self.m_topRankingLabel :setString( "排名 : "..self.m_myinfo.ranking)
    end


    self : setSurplus( self.m_myinfo.surplus )
end

--购买次数 设置
function CChallengePanelView.setSurplus( self, _count )
    self.m_myinfo.surplus = _count
    self.m_surplus = _count
    self.m_buyChallengeTimesLabel :setString(self.m_surplus)
end

--{时间拆分为 00:00:00}
function CChallengePanelView.turnTime( self, _time)
    _time = _time < 0 and 0 or _time
    local hor  = math.floor( _time/(60*60))
    hor = hor < 0 and 0 or hor
    local min  = math.floor( _time/60-hor*60)
    min = min < 0 and 0 or min
    local sec  = math.floor( _time-hor*60*60-min*60)
    sec = sec < 0 and 0 or sec
    hor = self :toTimeString( hor)
    min = self :toTimeString( min )
    sec = self :toTimeString( sec )
    return hor..":"..min..":"..sec
end
--{时间转字符串}
function CChallengePanelView.toTimeString( self, _num )
    _num = _num <=0 and "00" or _num
    if type(_num) ~= "string" then
        _num = _num >=10 and tostring(_num) or ("0"..tostring(_num))
    end
    return _num
end
function CChallengePanelView.setLocalList( self)
    print("CChallengePanelView.setLocalList")

end

function CChallengePanelView.getRoleByUid( self, _uid)
    for k,v in pairs( self.m_challengeplayerlist) do
        print("XXXXXX:",k,_uid,v.uid,v.name)
        if v.uid == _uid then
            return v
        end
    end
    return false
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack

function CChallengePanelView.clickRoleCallBack( self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then

            if self.m_touchBtnImg ~= nil then
                self.m_touchBtnImg : removeFromParentAndCleanup( true )
                self.m_touchBtnImg = nil
            end

            local rolebuttonSize = CCSizeMake( 180, 247)
            self.m_touchBtnImg   = CButton :createWithSpriteFrameName( "","general_underframe_click.png")
            self.m_touchBtnImg   : setPreferredSize( rolebuttonSize )
            obj :addChild( self.m_touchBtnImg , 2)

            if self.m_resetchallengetime <= 0 and self.m_surplus>0 then
                self :openStartScene( obj : getTag())
            else
                local msgString = ""
                if self.m_resetchallengetime > 0 then
                    --CCLOG( "冷却CD时间未到，不能挑战")
                    msgString = "冷却CD时间未到，不能挑战!"
                elseif self.m_surplus < 1 then
                    --CCLOG( "没有挑战次数了，不能挑战")
                    msgString = "没有挑战次数了，不能挑战!"
                end
                local box = CErrorBox()
                local BoxLayer = box : create( msgString )
                local scene = CCDirector : sharedDirector() : getRunningScene()
                scene:addChild( BoxLayer, 10000 )
            end

            _G.pCGuideManager:sendStepFinish()
        end
    end
end
--单击回调
function CChallengePanelView.clickCellCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) == true then
            if obj : getTag() == CChallengePanelView.TAG_CLOSED then
                self : closeCallBack()
            elseif obj : getTag() == CChallengePanelView.TAG_RECEIVEAWARDS then
                self :receiveAwardCallBack()
            elseif obj : getTag() == CChallengePanelView.TAG_RESETTIME then
                self : resetCDTimeCallBack()
            elseif obj : getTag() == CChallengePanelView.TAG_BUYTIMES then
                self : buyTimesCallBack()
            elseif obj : getTag() == CChallengePanelView.TAG_WORKHARDPANEL then
                self : workHardpanelCallBack()
            elseif obj : getTag() == CChallengePanelView.TAG_CHALLENGETOP then
                self : challengeTopCallBack()
            end
        end
    end
end

function CChallengePanelView.openStartScene( self, _uid)    
    local role = self :getRoleByUid( _uid)
    --通过VS界面进入挑战界面
    if role~= false then
        print("通过VS界面进入挑战界面")
        CCDirector :sharedDirector() :pushScene( _G.g_StartView :scene( role ))
    end
    --直接进入挑战界面
    -- -- CCLOG(" 挑战玩家:"..role.name )
    -- local comm = CStageREQCommand(_G.Protocol["REQ_ARENA_BATTLE"])
    -- comm : setOtherData( {uid=obj :getTag(),rank=role.ranking})
    -- controller : sendCommand( comm )
end

function CChallengePanelView.setNewRenown( self, _getRenown )

    if _getRenown ~= nil then
        self.m_myRenown = self.m_myRenown + tonumber( _getRenown )
    end

    self.m_myPrestigeLabel :setString( "声望 : "..self.m_myRenown)

end

function CChallengePanelView.closeCallBack( self )
    if self ~= nil then
        controller :unregisterMediator( self.m_mediator)--注销mediator
        CCDirector :sharedDirector() :popScene( )
        self:unloadResource()
    else
        CCLOG("objSelf = nil"..self)
    end
end

--领取奖励
function CChallengePanelView.receiveAwardCallBack( self )
    if self.m_receiveawardstime <= 0 then
        --add:请求领取奖励
        local msg = REQ_ARENA_DAY_REWARD()
        _G.CNetwork :send( msg)
        self.m_receiveAwardsButton :setVisible( false)
    else
        CCLOG( "领取奖励时间未到，不能领取")
    end
end

--清除CD时间
function CChallengePanelView.resetCDTimeCallBack( self )
    if self.m_resetchallengetime > 0 then
        local rmb = math.ceil(self.m_resetchallengetime / 60 ) * _G.Constant.CONST_ARENA_FAST_RMB
        local box = CPopBox()
        local function localCallback( )
            local msg = REQ_ARENA_CLEAN()
            _G.CNetwork :send( msg)
        end
        local container = box : create(localCallback,"清除CD需要消耗"..rmb.."钻石" )
        self.m_scenelayer : addChild( container )
    else
        CCLOG( "冷却CD时间为0，不用清除")
    end
end

--购买挑战次数
function CChallengePanelView.buyTimesCallBack( self )
    msg = REQ_ARENA_BUY()
    _G.CNetwork :send( msg)
end

function CChallengePanelView.workHardpanelCallBack( self )
    CCLOG(" 进入苦工系统")
end

--竞技排行
function CChallengePanelView.challengeTopCallBack( self )
    local tempTopListView = CTopListPanelView()
    local act = CCTransitionShrinkGrow:create(0.5,tempTopListView :scene( self.m_myinfo))
    CCDirector :sharedDirector() :pushScene( act)
    --CCDirector :sharedDirector() :pushScene( CCTransitionShrinkGrow:create(0.5,tempTopListView :scene( self.m_myinfo)))
end

--显示购买次数金额
function CChallengePanelView.buyCountMediatorCallBack( self, _count )
    local rmb = _G.Constant.CONST_ARENA_BUY_RMB * _count
    if type(rmb) ~= "number"then
        CCMessageBox("buyCountMediatorCallBack,","ERROR")
        return
    end
    local box = CPopBox()
    local function localCallback( )
        local msg = REQ_ARENA_BUY_YES()
        _G.CNetwork :send( msg)
    end
    local container = box : create(localCallback,"购买次数需要消耗"..rmb.."钻石" )
    self.m_scenelayer : addChild( container )
end