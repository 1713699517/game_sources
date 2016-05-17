--[[
 --CFactionActivePanelView
 --社团活动主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "view/FactionPanelLayer/FactionLuckyCatView"

CFactionActivePanelView = class(view, function( self)
    print("CFactionActivePanelView:社团活动主界面")
    self.m_closedButton          = nil   --关闭按钮
    self.m_tagLayout             = nil   --4种Tag按钮的水平布局
    self.m_activePanelViewContainer = nil  --酒吧面板的容器层
end)
--Constant:
CFactionActivePanelView.TAG_LABEL_TIME   = 249
CFactionActivePanelView.TAG_ROLE_ICON    = 250  --_itembackgroundSize.height/20~255

CFactionActivePanelView.FONT_SIZE        = 23

CFactionActivePanelView.ITEM_HEIGHT      = 800
CFactionActivePanelView.PER_PAGE_COUNT   = 4

--加载资源
function CFactionActivePanelView.loadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("WorldBossResources/WorldBossResources.plist")
end
--释放资源
function CFactionActivePanelView.unLoadResource( self)
end
--初始化数据成员
function CFactionActivePanelView.initParams( self, layer)
    print("CFactionActivePanelView.initParams")
    local mainplay          = _G.g_characterProperty :getMainPlay()
    self.m_rolelv           = mainplay :getLv()        --玩家等级
    self.m_rolepartnercount = mainplay :getCount()  -- 伙伴数量
    self.m_rolerenown       = mainplay :getRenown() -- 玩家声望
    self.m_roleclanpost     = mainplay :getClanPost() -- 社团职位

    self.m_clanlv           = _G.g_GameDataProxy:getClanLv()

    require "mediator/WorldBossMediator"
    --self.m_mediator = CWorldBossMediator( self)
    --controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
end
--释放成员
function CFactionActivePanelView.realeaseParams( self)
end

--布局成员
function CFactionActivePanelView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团活动主界面")
        --背景部分
        local backgroundSize         = CCSizeMake( winSize.height/3*4, winSize.height)
        local barbackgroundupSize    = CCSizeMake( backgroundSize.width-30, backgroundSize.height*0.87)

        self.m_activeListContainer :setPosition( ccp( winSize.width/2-backgroundSize.width/2+27, 30))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团活动主界面")

    end
end

--主界面初始化
function CFactionActivePanelView.init(self, winSize, layer)
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

function CFactionActivePanelView.scene(self, _myInfo)
    print("create scene")
    self.m_myinfo = _myInfo
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionActivePanelView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionActivePanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionActivePanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionActivePanelView.requestService ( self)
    print(" -- (手动) -- [33300]请求社团活动面板 -- 社团 ")
    require "common/protocol/auto/REQ_CLAN_ASK_CLAN_ACTIVE"
    local msg = REQ_CLAN_ASK_CLAN_ACTIVE()
    _G.CNetwork :send( msg)
end

--read XML
function CFactionActivePanelView.getActiveXmlById( self, _id)
    print( "CFactionActivePanelView.getActiveXmlById:")
    local active_id = tostring( _id)
    _G.Config:load("config/active.xml")
    local partner_node = _G.Config.actives : selectSingleNode("active[@active_id="..active_id.."]")
    if partner_node : isEmpty() == false then
        return partner_node
    end
    return nil
end

function CFactionActivePanelView.getCopyIdByClanLv( self, _lv)
    print("CFactionActivePanelView.getCopyIdByClanLv")
    _G.Config:load("config/clan_level.xml")
    local node = _G.Config.clan_levels : selectSingleNode("clan_level[@lv="..tostring(_lv).."]")
    print("copy_id:",node : getAttribute("copy_id"))
    return node : getAttribute("copy_id")
end

--初始化排行榜界面
function CFactionActivePanelView.initView(self, layer)
    print("CFactionActivePanelView.initView")
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    --副本界面容器
    self.m_activePanelViewContainer = CContainer :create()
    self.m_activePanelViewContainer : setControlName("this is CFactionActivePanelView self.m_activePanelViewContainer 94 ")
    layer :addChild( self.m_activePanelViewContainer)
    --创建背景
    --创建各种Button
    --创建角色相关信息Label
    self.m_activeListContainer = CContainer :create()
    self.m_activePanelViewContainer :addChild( self.m_activeListContainer, 1)
    --
    --self :setLocalList()
end

function CFactionActivePanelView.getPageAndLastCount( self, _allcount, _PER_PAGE_COUNT)

    local pageCount     = math.floor( _allcount/_PER_PAGE_COUNT)+1         --页数
    if math.mod( _allcount,_PER_PAGE_COUNT) == 0 and _allcount ~= 0 then
        pageCount = pageCount -1
    end
    local lastPageCount = math.mod( _allcount-1,_PER_PAGE_COUNT)+1         --最后一页个数
    print("bbbbbbbbbbbbbbb", pageCount, lastPageCount)
    return pageCount,lastPageCount
end
--显示排行榜玩家
function CFactionActivePanelView.showAllActive( self)
    if self.m_activeListContainer ~= nil then
        self.m_activeListContainer :removeAllChildrenWithCleanup( true)
    end
    local function CallBack( eventType, obj, npage, y)
        return self :clickCellCallBack( eventType, obj, npage, y)
    end
    self.m_pageCount, self.m_lastPageCount = self :getPageAndLastCount( self.m_activecount, CFactionActivePanelView.PER_PAGE_COUNT)
    self.m_curentPageCount = self.m_pageCount -1
    local winSize          = CCDirector :sharedDirector() :getVisibleSize()
    local backgroundSize   = CCSizeMake( winSize.height/3*4, winSize.height)

    local m_bgCell  = CCSizeMake( (backgroundSize.width-100)/4,winSize.height*0.87-50)
    local viewSize  = CCSizeMake( backgroundSize.width-50, winSize.height*0.87-20)

    self.m_pScrollView = CPageScrollView :create( eLD_Horizontal, viewSize)
    self.m_pScrollView :setControlName("this is CFactionActivePanelView self.m_pScrollView 179 ")
    self.m_pScrollView :registerControlScriptHandler( CallBack)
    self.m_pScrollView : setTouchesPriority(1)
    self.m_activeListContainer :addChild( self.m_pScrollView )

    local activecount       = 0
    self.m_activeList       = {}
    for k=1,self.m_pageCount do
        local pageContainer = nil
        pageContainer = CContainer :create()
        pageContainer :setControlName("this is CFactionActivePanelView pageContainer 186 "..tostring(k))

        local layout = CHorizontalLayout :create()
        layout :setPosition(-viewSize.width/2, viewSize.height/2-m_bgCell.height/2)
        pageContainer :addChild(layout)
        layout :setVerticalDirection(false)
        layout :setCellHorizontalSpace( 15)
        layout :setLineNodeSum( 4)
        layout :setCellSize(m_bgCell)
        --layout :setHorizontalDirection(true)
        local tempnum = CFactionActivePanelView.PER_PAGE_COUNT
        if k == self.m_pageCount then
            tempnum = self.m_lastPageCount
        end
        for i =1 , tempnum do
            activecount = activecount + 1
            local _activeid = tostring(self.m_activelist[activecount].active_id)
            self.m_activeList[ _activeid] = self :createActiveItem( self.m_activelist[activecount], m_bgCell)
            layout :addChild( self.m_activeList[_activeid])
        end
        self.m_pScrollView :addPage( pageContainer, false)
    end
    self.m_pScrollView :setPage( 0, false)
end

function CFactionActivePanelView.getTimeString( self, _times)
    return os.date("%H",_times)..":"..os.date("%M",_times)
end
--创建社团列表单项
function CFactionActivePanelView.createActiveItem( self, _activeinfo , _cellsize)
    local itemContainer      = CContainer :create()
    itemContainer :setControlName( "this is CFactionActivePanelView.createActiveItem itemContainer ")
    local _activeid             = _activeinfo.active_id --活动id
    local _activestate          = _activeinfo.state
    local _itembackground       = self :createSprite( "worldBoss_boss_frame.png", "_itembackground")
    local _itemactiveSprite     = self :createSprite( "clan_picture_0"..(_activeid%3+1)..".png", "_itemactiveSprite")
    local _itemactivewordSprite = self :createSprite( "clan_word_0"..(_activeid%3+1)..".png", "_itemactiveSprite")
    local _itemwordbackground   = self :createSprite( "clan_acitivet_undrframe.png", "_itemwordbackground")
    local _itemclickSprite      = self :createSprite( "worldBoss_boss_click.png", "_itemclickSprite")
    local _itemconditionLabel   = self :createLabel( "(社团".._activeinfo.limite_clanlv.."级开启)", ccc3( 255, 255, 0))
    local _itemtimeLabel        = self :createLabel( "参与次数: ".._activeinfo.times.."/".._activeinfo.all_times)
    local _itemroletimesLabel   = self :createLabel( "参与人数: 单人")

    _itembackground :setTag( CFactionActivePanelView.TAG_ROLE_ICON)
    _itemclickSprite :setTag( CFactionActivePanelView.TAG_ROLE_ICON+2)
    _itemtimeLabel :setTag( CFactionActivePanelView.TAG_LABEL_TIME)

    _itemclickSprite :setVisible( false)

    local _itemstate         = nil
    local _itemstateString   = ""
    local _itemstateCallBack = nil
    --创建相应的Button
    if _activestate == 0 then
        _itemstateString = "未开始"
        if _activeinfo.active_id == 1002 then --社团BOSS 社长，副社长开启
            if self.m_roleclanpost == _G.Constant.CONST_CLAN_POST_SECOND or self.m_roleclanpost == _G.Constant.CONST_CLAN_POST_MASTER then
                if _activeinfo.times < _activeinfo.all_times then
                    local function CallBack( eventType, obj, x, y)
                        return self :clickStartCallBack( eventType, obj, x, y)
                    end
                    _itemstateString   = "开启活动"
                    _itemstateCallBack = CallBack
                end
            end
        end            
    elseif _activestate == 1 then
        local function CallBack( eventType, obj, x, y)
            return self :clickIntobattleCallBack( eventType, obj, x, y)
        end
        _itemstateString   = "挑战"
        if _activeinfo.active_id == 1001 then --招财猫
            _itemstateString   = "互动"
        end        
        _itemstateCallBack = CallBack
    elseif _activestate == 2 then
        _itemstateString = "已结束"
    else
        _itemstateString = "未知状态"
    end
    _itemstate     = self :createButton( _itemstateString, "general_button_normal.png", _itemstateCallBack, _activeinfo.active_id, "_itemstate")

    local _itembackgroundSize     = _itembackground :getPreferredSize()
    local _itemactiveSpriteSize   = _itemactiveSprite :getPreferredSize()
    local _itemwordbackgroundSize = _itemwordbackground :getPreferredSize()

    _itembackground :setPosition( ccp( 0, _cellsize.height/2-_itembackgroundSize.height/2-10))
    _itemclickSprite :setPosition( ccp( 0, _cellsize.height/2-_itembackgroundSize.height/2-10))
    _itemactivewordSprite :setPosition( ccp( 0, _cellsize.height/2-_itemwordbackgroundSize.height/2-15))
    _itemwordbackground :setPosition( ccp( 0, _cellsize.height/2-_itemwordbackgroundSize.height/2-15))
    _itemactiveSprite :setPosition( ccp( -1, _cellsize.height/2-_itemactiveSpriteSize.height/2-57))
    _itemstate :setPosition( ccp( 0, -_cellsize.height/2))
    _itemconditionLabel :setPosition( ccp( 0, -_itembackgroundSize.height/2+120))
    _itemtimeLabel :setPosition( ccp( 0, -_itembackgroundSize.height/2+60))
    _itemroletimesLabel :setPosition( ccp( 0, -_itembackgroundSize.height/2+90))

    itemContainer :addChild( _itemactiveSprite)
    itemContainer :addChild( _itembackground)
    itemContainer :addChild( _itemwordbackground)
    itemContainer :addChild( _itemactivewordSprite)
    itemContainer :addChild( _itemclickSprite)
    itemContainer :addChild( _itemtimeLabel)
    itemContainer :addChild( _itemconditionLabel)
    itemContainer :addChild( _itemroletimesLabel)
    itemContainer :addChild( _itemstate)
    return itemContainer
end

--创建按钮Button
function CFactionActivePanelView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionActivePanelView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CFactionActivePanelView ".._controlname)
    _itembutton :setFontSize( CFactionActivePanelView.FONT_SIZE)
    _itembutton :setTag( _tag)
    if _func == nil then
        _itembutton :setTouchesEnabled( false)
    else
        _itembutton :registerControlScriptHandler( _func, "this CFactionActivePanelView ".._controlname.."CallBack")
    end
    return _itembutton
end

--创建图片Sprite
function CFactionActivePanelView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CFactionActivePanelView createSprite _background".._controlname)
    return _background
end

--创建Label ，可带颜色
function CFactionActivePanelView.createLabel( self, _string, _color)
    print("CFactionActivePanelView.createLabel:".._string)
    if _string == nil then
        _string = "没有字符"
    end
    local _itemlabel = CCLabelTTF :create( _string, "Arial", CFactionActivePanelView.FONT_SIZE)
    if _color ~= nil then
        _itemlabel :setColor( _color)
    end
    return _itemlabel
end
-----------------------------------------------------
--mediator更新本地list数据
----------------------------------------------------
--更新本地list数据
function CFactionActivePanelView.setLocalList( self, _activecount, _activelist)
    print("CFactionActivePanelView.setLocalList")
    local function sortActive( active1, active2)
        if active1.active_id < active2.active_id then
            return true
        end
        return false
    end
    self.m_activecount = _activecount
    self.m_activelist  = _activelist
    table.sort( self.m_activelist, sortActive)
    self :showAllActive()
end

function CFactionActivePanelView.setStamina( self, _stamina)
    print( "FFFFFF更新帮贡:".._stamina)
    self.m_stamina = _stamina
    --self.m_roleinfoLabel :setString( "个人贡献:"..self.m_stamina)
end

function CFactionActivePanelView.setLuckyCatInfo( self, _activeid, _times, _alltimes)
    self.m_activeList[ tostring( _activeid)] :getChildByTag( CFactionActivePanelView.TAG_LABEL_TIME) :setString( "参与次数: ".._times.."/".._alltimes)
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--单击回调
function CFactionActivePanelView.clickCellCallBack(self,eventType, obj, x, y)
    print( "eventType",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "PageScrolled" then
        local currentPage = x
        print( "eventType",eventType, "当前页：",currentPage, "过去页：",self.m_curentPageCount)
        self.m_curentPageCount = currentPage
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CFactionActivePanelView.TAG_CLOSED then
            print("关闭")
        end
    end
end

--进入战斗
function CFactionActivePanelView.clickStartCallBack(self,eventType, obj, x, y)
    print( "eventType",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("-- (手动) -- [54220]请求开启社团BOSS -- 社团BOSS "..obj: getTag())
        require "common/protocol/auto/REQ_CLAN_BOSS_START_BOSS"
        local msg = REQ_CLAN_BOSS_START_BOSS()
        _G.CNetwork :send( msg)
    end
end

--进入战斗
function CFactionActivePanelView.clickIntobattleCallBack(self,eventType, obj, x, y)
    print( "eventType",eventType)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("进入战斗: "..obj: getTag())
        self :enterActiveById( obj :getTag())
    end
end

function CFactionActivePanelView.enterActiveById( self, _activeid)
    if _activeid == 1001 then  --招财猫
        local pFactionLuckyCatView = CFactionLuckyCatView()
        CCDirector :sharedDirector() :pushScene( CCTransitionShrinkGrow:create(0.5,pFactionLuckyCatView :scene( _activeid)))
    elseif _activeid == 1002 then --BOSS
        local tempCommand = CStageREQCommand(_G.Protocol["REQ_SCENE_ENTER_FLY"])
        print("CONST_CLAN_BOSS_SCENE",_G.Constant.CONST_CLAN_BOSS_SCENE)
        tempCommand : setOtherData({ mapID = _G.Constant.CONST_CLAN_BOSS_SCENE })
        _G.controller: sendCommand(tempCommand)
    elseif _activeid == 1003 then  --副本
        require "common/protocol/auto/REQ_COPY_CREAT"
        print( "clan_level: "..self.m_clanlv)
        local msg = REQ_COPY_CREAT()
        msg : setCopyId( self :getCopyIdByClanLv( self.m_clanlv))
        _G.CNetwork : send(msg)
    else
        print("没有相应的活动")
    end
end



    -- if _activeinfo.active_id == 1002 then --社团BOSS
    --     if self.m_roleclanpost == _G.Constant.CONST_CLAN_POST_SECOND or self.m_roleclanpost == _G.Constant.CONST_CLAN_POST_MASTER then
    --         if _activeinfo.times < _activeinfo.all_times and _activestate == 0 then
    --             --开启
    --             local function CallBack( eventType, obj, x, y)
    --                 return self :clickStartCallBack( eventType, obj, x, y)
    --             end
    --             _itemstate     = self :createButton( "开启活动", "general_button_normal.png", CallBack, _activeinfo.active_id, "_itemstate")
    --         elseif _activeinfo.times < _activeinfo.all_times and _activestate == 1 then
    --             --挑战
    --             local function CallBack( eventType, obj, x, y)
    --                 return self :clickIntobattleCallBack( eventType, obj, x, y)
    --             end
    --             _itemstate     = self :createButton( "挑战", "general_button_normal.png", CallBack, _activeinfo.active_id, "_itemstate")
    --         else
    --             --结束
    --             _itemstate     = self :createButton( "已结束", "general_button_normal.png", nil, _activeinfo.active_id, "_itemstate")
    --         end
    --     else
    --         if _activestate == 1 then --可以挑战
    --             local function CallBack( eventType, obj, x, y)
    --                 return self :clickIntobattleCallBack( eventType, obj, x, y)
    --             end
    --             _itemstate     = self :createButton( "挑战", "general_button_normal.png", CallBack, _activeinfo.active_id, "_itemstate")
    --             --_itemclickSprite :setVisible( true)
    --         elseif _activestate == 0 then --为开始
    --             _itemstate     = self :createButton( "未开始", "general_button_normal.png", nil, _activeinfo.active_id, "_itemstate")
    --         elseif _activestate == 2 then --已结束
    --             _itemstate     = self :createButton( "已结束", "general_button_normal.png", nil, _activeinfo.active_id, "_itemstate")
    --         else
    --             _itemstate     = self :createButton( "未知状态", "general_button_normal.png", nil, _activeinfo.active_id, "_itemstate")
    --         end
    --     end
    -- else
    --     if _activestate == 1 then --可以挑战
    --         local function CallBack( eventType, obj, x, y)
    --             return self :clickIntobattleCallBack( eventType, obj, x, y)
    --         end
    --         _itemstate     = self :createButton( "挑战", "general_button_normal.png", CallBack, _activeinfo.active_id, "_itemstate")
    --         --_itemclickSprite :setVisible( true)
    --     elseif _activestate == 0 then --为开始
    --         _itemstate     = self :createButton( "未开始", "general_button_normal.png", nil, _activeinfo.active_id, "_itemstate")
    --     elseif _activestate == 2 then --已结束
    --         _itemstate     = self :createButton( "已结束", "general_button_normal.png", nil, _activeinfo.active_id, "_itemstate")
    --     else
    --         _itemstate     = self :createButton( "未知状态", "general_button_normal.png", nil, _activeinfo.active_id, "_itemstate")
    --     end
    -- end
