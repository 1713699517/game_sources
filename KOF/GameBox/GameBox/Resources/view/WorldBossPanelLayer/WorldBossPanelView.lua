--[[
 --CWorldBossPanelView
 --多人在线活动主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"
require "controller/CharacterUpadteCommand"

require "view/BarPanelLayer/BarPromptView"

CWorldBossPanelView = class(view, function( self)
    print("CWorldBossPanelView:多人在线活动主界面")
    self.m_closedButton          = nil   --关闭按钮
    self.m_tagLayout             = nil   --4种Tag按钮的水平布局
    self.m_activePanelViewContainer = nil  --酒吧面板的容器层
end)
--Constant:
CWorldBossPanelView.TAG_CLOSED       = 205  --关闭

CWorldBossPanelView.TAG_ROLE_ICON    = 250  --_itembackgroundSize.height/20~255

CWorldBossPanelView.FONT_SIZE        = 23

CWorldBossPanelView.ITEM_HEIGHT      = 800
CWorldBossPanelView.PER_PAGE_COUNT   = 4

--加载资源
function CWorldBossPanelView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("WorldBossResources/WorldBossResources.plist")
end
--释放资源
function CWorldBossPanelView.unloadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("BarResources/BarResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("HeadIconResources/HeadIconResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("WorldBossResources/WorldBossResources.plist")
    
    CCTextureCache :sharedTextureCache():removeTextureForKey("BarResources/BarResources.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("HeadIconResources/HeadIconResources.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("WorldBossResources/WorldBossResources.pvr.ccz")

    _G.Config :unload( "config/active.xml")

    _G.g_unLoadIconSources:unLoadCreateResByName("WorldBossResources/worldBoss_word_drhd.png")

end
--初始化数据成员
function CWorldBossPanelView.initParams( self, layer)
    print("CWorldBossPanelView.initParams")
    local mainplay          = _G.g_characterProperty :getMainPlay()
    self.m_rolelv           = mainplay :getLv()        --玩家等级
    self.m_rolepartnercount = mainplay :getCount()  -- 伙伴数量
    self.m_rolerenown       = mainplay :getRenown() -- 玩家声望

    require "mediator/WorldBossMediator"
    _G.g_worldBossPanelMediator = CWorldBossMediator( self)
    controller :registerMediator( _G.g_worldBossPanelMediator )--先注册后发送 否则会报错
end
--释放成员
function CWorldBossPanelView.realeaseParams( self)
end

--布局成员
function CWorldBossPanelView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--多人在线活动主界面")
        --背景部分
        local backgroundSize         = CCSizeMake( winSize.height/3*4, winSize.height)
        local barbackgroundupSize    = CCSizeMake( backgroundSize.width-30, backgroundSize.height*0.87)
        local backgroundfirst        = self.m_activePanelViewContainer :getChildByTag( 100)
        local backgroundsecond       = self.m_activePanelViewContainer :getChildByTag( 102)
        local barbackgroundup        = self.m_activePanelViewContainer :getChildByTag( 103)
        local closeButtonSize        = self.m_closedButton :getPreferredSize()

        backgroundfirst :setPreferredSize( CCSizeMake( winSize.width, winSize.height))
        backgroundsecond :setPreferredSize( backgroundSize)
        barbackgroundup :setPreferredSize( barbackgroundupSize)

        backgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        backgroundsecond :setPosition( ccp( winSize.width/2, winSize.height/2))
        barbackgroundup :setPosition( ccp( winSize.width/2, winSize.height*0.87/2+15))

        self.m_titleImg :setPosition( ccp( winSize.width/2, 597))

        self.m_activeListContainer :setPosition( ccp( winSize.width/2-backgroundSize.width/2+27, 30))
        self.m_closedButton: setPosition( ccp( winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--多人在线活动主界面")

    end
end

--主界面初始化
function CWorldBossPanelView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    self.loadResource( self)
    --初始化数据
    self.initParams( self,layer)
    --初始化界面
    self.initView( self, layer)
    --请求服务端消息
    self.requestService( self)
    --布局成员
    self.layout( self, winSize)
end

function CWorldBossPanelView.scene(self, _myInfo)
    print("create scene")
    self.m_myinfo = _myInfo
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CWorldBossPanelView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CWorldBossPanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CWorldBossPanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CWorldBossPanelView.requestService ( self)
    print(" -- (手动) -- [30510]请求活动数据 -- 活动面板 ")
    require "common/protocol/auto/REQ_ACTIVITY_REQUEST"
    local msg = REQ_ACTIVITY_REQUEST()
    _G.CNetwork :send( msg)
end

--read XML
function CWorldBossPanelView.getActiveXmlById( self, _id)
    print( "CWorldBossPanelView.getActiveXmlById:")
    local active_id = tostring( _id)
    _G.Config:load("config/active.xml")
    local partner_node = _G.Config.actives : selectSingleNode("active[@active_id="..active_id.."]")
    if partner_node : isEmpty() == false then
        return partner_node
    end
    return nil
end

--初始化排行榜界面
function CWorldBossPanelView.initView(self, layer)
    print("CWorldBossPanelView.initView")
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    --副本界面容器
    self.m_activePanelViewContainer = CContainer :create()
    self.m_activePanelViewContainer : setControlName("this is CWorldBossPanelView self.m_activePanelViewContainer 94 ")
    layer :addChild( self.m_activePanelViewContainer)
    --创建背景
    local backgroundfirst       = self :createSprite( "peneral_background.jpg", "backgroundfirst")
    local backgroundsecond      = self :createSprite( "general_first_underframe.png", "backgroundsecond")
    local barbackgroundup       = self :createSprite( "general_second_underframe.png", "barbackgroundup")

    self.m_titleImg = CSprite :create("WorldBossResources/worldBoss_word_drhd.png")
    self.m_titleImg : setControlName( "this CLuckyLayer self.m_titleImg 39 ")
    self.m_activePanelViewContainer  : addChild( self.m_titleImg )


    --创建各种Button
    self.m_closedButton         = self :createButton( "", "general_close_normal.png", CallBack, CWorldBossPanelView.TAG_CLOSED, "self.m_closedButton")
    --创建角色相关信息Label
    self.m_activeListContainer = CContainer :create()
    self.m_activePanelViewContainer :addChild( self.m_activeListContainer, 1)
    self.m_activePanelViewContainer :addChild( backgroundfirst, -1, 100)
    self.m_activePanelViewContainer :addChild( backgroundsecond, -1, 102)
    self.m_activePanelViewContainer :addChild( barbackgroundup, -1, 103)
    self.m_activePanelViewContainer :addChild( self.m_closedButton, 2)
    --
    --self :setLocalList()
end

function CWorldBossPanelView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)

    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end
--显示排行榜玩家
function CWorldBossPanelView.showAllActive( self)
    if self.m_activeListContainer ~= nil then
        self.m_activeListContainer :removeAllChildrenWithCleanup( true)
    end
    local function CallBack( eventType, obj, npage, y)
        return self :clickCellCallBack( eventType, obj, npage, y)
    end
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( self.m_activecount, CWorldBossPanelView.PER_PAGE_COUNT)
    self.m_curentPageCount = self.m_pageCount -1
    local winSize          = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize   = CCSizeMake( winSize.height/3*4, winSize.height)

    local m_bgCell  = CCSizeMake( (backgroundSize.width-100)/4,winSize.height*0.87-50)
    local viewSize  = CCSizeMake( backgroundSize.width-50, winSize.height*0.87-20)

    self.m_pScrollView = CPageScrollView :create( eLD_Horizontal, viewSize)
    self.m_pScrollView :setControlName("this is CWorldBossPanelView self.m_pScrollView 179 ")
    self.m_pScrollView :registerControlScriptHandler( CallBack)
    self.m_pScrollView : setTouchesPriority(1)
    self.m_activeListContainer :addChild( self.m_pScrollView )

    local activecount       = 0
    self.m_activeList       = {}
    for k=1,self.m_pageCount do
        local pageContainer = nil
        pageContainer = CContainer :create()
        pageContainer :setControlName("this is CWorldBossPanelView pageContainer 186 "..tostring(k))

        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width/2, viewSize.height/2-m_bgCell.height/2)
        pageContainer :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setCellHorizontalSpace( 15)
        layout :setLineNodeSum( 4)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)
        local tempnum = CWorldBossPanelView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        for i =1 , tempnum do
            activecount = activecount + 1
            local _activeid = tostring(self.m_activelist[activecount].active_id)
            self.m_activeList[ _activeid] = self :createBossItem( self.m_activelist[activecount], m_bgCell)
            layout :addChild( self.m_activeList[_activeid])
        end
        self.m_pScrollView :addPage( pageContainer, false)
    end
    self.m_pScrollView :setPage( 0, false)
end

function CWorldBossPanelView.getTimeString( self, _times)
    return os.date("%H",_times)..":"..os.date("%M",_times)
end
--创建社团列表单项
function CWorldBossPanelView.createBossItem( self, _activeinfo , _cellsize)
    local itemContainer      = CContainer :create()
    itemContainer :setControlName( "this is CWorldBossPanelView.createBossItem itemContainer ")
    local _activenode        = self :getActiveXmlById( _activeinfo.id)
    if _activenode == nil then
        print( "在XML中未找到相关活动信息，".._activeinfo.id)
    end
    local _activeid          = _activenode : getAttribute("active_id")  --活动id
    local _activelv          = _activenode : getAttribute("role_lv")    --需要等级
    local _activetimes       = self :getTimeString( _activeinfo.start_time).."~"..self :getTimeString( _activeinfo.end_time)
    local _activestate       = _activeinfo.state
    local _activeisnew       = _activeinfo.is_new
    local _itembackground    = self :createSprite( "worldBoss_boss_frame.png", "_itembackground")
    local _itembossSprite    = self :createSprite( "worldBoss_boss_".._activenode : getAttribute("in_host")..".png", "_itembossSprite")
    local _itemclickSprite   = self :createSprite( "worldBoss_boss_click.png", "_itemclickSprite")
    local _itemtimenameLabel = self :createLabel( "挑战时间", ccc3( 255, 255, 0))
    local _itemtimeLabel     = self :createLabel( _activetimes)
    local _itemlvLabel       = self :createLabel( "需要等级: ".._activelv, ccc3( 255, 155, 0))

    _itembackground :setTag( CWorldBossPanelView.TAG_ROLE_ICON)
    _itemclickSprite :setTag( CWorldBossPanelView.TAG_ROLE_ICON+2)

    _itemclickSprite :setVisible( false)

    local _itemstate   = nil
    --创建相应的Button
    if _activestate == _G.Constant.CONST_ACTIVITY_STATE_START then --可以挑战
        local function CallBack( eventType, obj, x, y)
            return self :clickIntobattleCallBack( eventType, obj, x, y)
        end
        _itemstate     = self :createButton( "进入战斗", "general_button_normal.png", CallBack, _activeinfo.id, "_itemstate")
        _itemclickSprite :setVisible( true)
    elseif _activestate == _G.Constant.CONST_ACTIVITY_STATE_NOT_OPEN then --为开始
        _itemstate     = self :createButton( "未开始", "general_button_normal.png", nil, _activeinfo.id, "_itemstate")
    elseif _activestate == _G.Constant.CONST_ACTIVITY_STATE_OVER then --已结束
        _itemstate     = self :createButton( "已结束", "general_button_normal.png", nil, _activeinfo.id, "_itemstate")
    elseif _activestate == _G.Constant.CONST_ACTIVITY_STATE_SIGN then --报名参加
        local function CallBack( eventType, obj, x, y)
            return self :clickSignupCallBack( eventType, obj, x, y)
        end
        _itemstate     = self :createButton( "报名参加", "general_button_normal.png", CallBack, _activeinfo.id, "_itemstate")
    else
        _itemstate     = self :createButton( "未知状态", "general_button_normal.png", nil, _activeinfo.id, "_itemstate")
    end
    local _itembackgroundSize = _itembackground :getPreferredSize()
    local _itembossSpriteSize = _itembossSprite :getPreferredSize()

    _itembackground :setPosition( ccp( 0, _cellsize.height/2-_itembackgroundSize.height/2-10))
    _itemclickSprite :setPosition( ccp( 0, _cellsize.height/2-_itembackgroundSize.height/2-10))
    _itembossSprite :setPosition( ccp( 0, _cellsize.height/2-_itembossSpriteSize.height/2-15))
    _itemstate :setPosition( ccp( 0, -_cellsize.height/2))
    _itemtimenameLabel :setPosition( ccp( 0, -_itembackgroundSize.height/2+120))
    _itemtimeLabel :setPosition( ccp( 0, -_itembackgroundSize.height/2+90))
    _itemlvLabel :setPosition( ccp( 0, -_itembackgroundSize.height/2+60))

    itemContainer :addChild( _itembossSprite)
    itemContainer :addChild( _itembackground)
    itemContainer :addChild( _itemclickSprite)
    itemContainer :addChild( _itemtimeLabel)
    itemContainer :addChild( _itemtimenameLabel)
    itemContainer :addChild( _itemlvLabel)
    itemContainer :addChild( _itemstate)
    return itemContainer
end

--创建按钮Button
function CWorldBossPanelView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CWorldBossPanelView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CWorldBossPanelView ".._controlname)
    _itembutton :setFontSize( CWorldBossPanelView.FONT_SIZE)
    _itembutton :setTag( _tag)
    if _func == nil then
        _itembutton :setTouchesEnabled( false)
    else
        _itembutton :registerControlScriptHandler( _func, "this CWorldBossPanelView ".._controlname.."CallBack")
    end
    return _itembutton
end

--创建图片Sprite
function CWorldBossPanelView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CWorldBossPanelView createSprite _background".._controlname)
    return _background
end

--创建Label ，可带颜色
function CWorldBossPanelView.createLabel( self, _string, _color)
    print("CWorldBossPanelView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CWorldBossPanelView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end
-----------------------------------------------------
--mediator更新本地list数据
----------------------------------------------------
--更新本地list数据
function CWorldBossPanelView.setLocalList( self, _activecount, _activelist)
    print("CWorldBossPanelView.setLocalList")
    self.m_activecount = _activecount
    self.m_activelist  = _activelist
    self :showAllActive()
end

function CWorldBossPanelView.setActiveStateChange( self,_active)
    print("CWorldBossPanelView.setFactionList")
    print("--改变activelist中活动状态")
    --add：
    for k,v in pairs(self.m_activelist) do
        print(k,v.id, _active.id, v.state,_active.state)
        if v.id == _active.id and v.start_time == _active.start_time then
            v.state = _active.state
            break
        end
    end
    self :showAllActive()
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--单击回调
function CWorldBossPanelView.clickCellCallBack(self,eventType, obj, x, y)
    print( "eventType",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "PageScrolled" then
        local currentPage = x
        print( "eventType",eventType, "当前页：",currentPage, "过去页：",self.m_curentPageCount)
        self.m_curentPageCount = currentPage
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CWorldBossPanelView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                controller :unregisterMediator( _G.g_worldBossPanelMediator )
                CCDirector :sharedDirector() :popScene( )
                self : unloadResources()
            else
                print("objSelf = nil", self)
            end
        end
    end
end

--进入战斗
function CWorldBossPanelView.clickIntobattleCallBack(self,eventType, obj, x, y)
    print( "eventType",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        print("进入战斗: "..obj: getTag())
        --BOSS
        local tempCommand = CStageREQCommand(_G.Protocol["REQ_SCENE_ENTER_FLY"])
        tempCommand : setOtherData({mapID = _G.Constant.CONST_BOSS_HUMAN_SENCE})
        _G.controller: sendCommand(tempCommand)
    end
end

--报名参加
function CWorldBossPanelView.clickSignupCallBack(self,eventType, obj, x, y)
    print( "eventType",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        print("报名参加: "..obj: getTag())
    end
end
