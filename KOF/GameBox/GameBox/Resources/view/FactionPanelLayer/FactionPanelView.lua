--[[
 --CFactionPanelView
 --社团面板主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "mediator/FactionMediator"

require "view/FactionPanelLayer/FactionInfomationView"
require "view/FactionPanelLayer/FactionCheckListView"
require "view/FactionPanelLayer/FactionMemberListView"
require "view/FactionPanelLayer/FactionSkillPanelView"
require "view/FactionPanelLayer/FactionActivePanelView"

CFactionPanelView = class(view, function( self)
    print("CFactionPanelView:社团面板主界面")
    self.m_factionlistButton       = nil   --社图列表按钮
    self.m_infomationButton        = nil   --社团信息按钮
    self.m_memberButton            = nil   --社团成员按钮
    self.m_activityButton          = nil   --社团活动按钮
    self.m_skillButton             = nil   --社团技能按钮
    self.m_closedButton            = nil   --关闭按钮
    self.m_tagLayout               = nil   --5种Tag按钮的水平布局
    self.m_factionPageContainer    = nil   --5个标签容器公用
    self.m_factionPanelViewContainer  = nil  --人物面板的容器层
end)

_G.pFactionPanelView = CFactionPanelView()
--Constant:
CFactionPanelView.TAG_FACTIONLIST    = 201  --社图列表
CFactionPanelView.TAG_INFOMATION     = 202  --社团信息
CFactionPanelView.TAG_MEMBERLIST     = 203  --社团成员
CFactionPanelView.TAG_ACTIVITY       = 204  --社团活动
CFactionPanelView.TAG_SKILL          = 205  --社团技能

CFactionPanelView.TAB_BUTTON_SIZE    = CCSizeMake( 130, 60)

CFactionPanelView.TAG_CLOSED         = 210  --关闭
CFactionPanelView.FONT_SIZE          = 23

--加载资源
function CFactionPanelView.loadResource( self)

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("FactionResources/FactionResources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("BarResources/BarResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("WorldBossResources/WorldBossResources.plist")

    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("CharacterPanelResources/RoleResurece.plist")

    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ImageBackpack/backpackUI.plist")

end
--释放资源
function CFactionPanelView.unloadResource( self)
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("FactionResources/FactionResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("BarResources/BarResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("WorldBossResources/WorldBossResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("CharacterPanelResources/RoleResurece.plist")
    --CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ImageBackpack/backpackUI.plist")
    
    CCTextureCache :sharedTextureCache():removeTextureForKey("FactionResources/FactionResources.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("BarResources/BarResources.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("WorldBossResources/WorldBossResources.pvr.ccz")
    CCTextureCache :sharedTextureCache():removeTextureForKey("CharacterPanelResources/RoleResurece.pvr.ccz")
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end
--初始化数据成员
function CFactionPanelView.initParams( self, layer)
    print("CFactionPanelView.initParams")
    require "mediator/TopListPanelMediator"
    --self.m_mediator = CTopListPanelMediator( self)       
    --controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
end
--释放成员
function CFactionPanelView.realeaseParams( self)
    -- if self.m_factionPageContainer ~= nil then
    --     self.m_factionPageContainer :removeAllChildrenWithCleanup( true)
    -- end
    print("关闭")
    if self ~= nil then
        if self.m_mediator ~= nil then
            controller :unregisterMediator( self.m_mediator)
            self.m_mediator = nil
        end
        self : unloadResource()
    else
        print("objSelf = nil", self)
    end
end

--布局成员
function CFactionPanelView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团面板主界面2")
        --背景部分
        local backgroundSize          = CCSizeMake( winSize.height/3*4, winSize.height)
        local backgroundfirst         = self.m_factionPanelViewContainer :getChildByTag( 99)
        local panelbackgroundfirst    = self.m_factionPanelViewContainer :getChildByTag( 100)
        local panelbackgroundsecond   = self.m_factionPanelViewContainer :getChildByTag( 101)
        local closeButtonSize         = self.m_closedButton: getPreferredSize() 

        panelbackgroundfirst :setPreferredSize( backgroundSize)
        backgroundfirst :setPreferredSize( CCSizeMake( winSize.width, winSize.height))

        backgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        panelbackgroundsecond :setPreferredSize( CCSizeMake( backgroundSize.width-30, backgroundSize.height*0.87))        
        panelbackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        panelbackgroundsecond :setPosition( ccp( winSize.width/2, winSize.height*0.87/2+15))
        --默认显示属性
        self.m_buttonTab : setSelectedTabIndex( 1)--社团信息
        --标签Button部分
        self.m_buttonTab :setPosition( ccp( winSize.width/2-backgroundSize.width/2+30, winSize.height-closeButtonSize.height/2-10))
        self.m_closedButton :setPosition( ccp( winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团面板主界面")        
    end
end

--主界面初始化
function CFactionPanelView.init(self, winSize, layer)
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
end

function CFactionPanelView.scene(self)
    print("create scene")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionPanelView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionPanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionPanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionPanelView.requestService ( self)
    require "common/protocol/auto/REQ_ARENA_KILLER"
    --local msg = REQ_ARENA_KILLER()
    --_G.CNetwork :send( msg)
end

--初始化排行榜界面
function CFactionPanelView.initView(self, layer)
    print("CFactionPanelView.initView")
    --副本界面容器
    self.m_factionPanelViewContainer = self :createContainer( "self.m_factionPanelViewContainer")
    layer :addChild( self.m_factionPanelViewContainer)
    
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local backgroundfirst        = self :createSprite( "peneral_background.jpg", "backgroundfirst")
    local panelbackgroundfirst   = self :createSprite( "general_first_underframe.png", "panelbackgroundfirst")
    local panelbackgroundsecond  = self :createSprite( "general_second_underframe.png", "panelbackgroundsecond")
    --创建各种Button
    self.m_closedButton      = self :createButton( "", "general_close_normal.png", CallBack, CFactionPanelView.TAG_CLOSED, "self.m_closedButton")    

    self.m_factionPanelViewContainer :addChild( backgroundfirst, -1, 99)
    self.m_factionPanelViewContainer :addChild( panelbackgroundfirst, -1, 100)
    self.m_factionPanelViewContainer :addChild( panelbackgroundsecond, -1, 101)
    self.m_factionPanelViewContainer :addChild( self.m_closedButton, 2)
    
    --默认属性界面
    --add:
    local tempinfoview = CFactionInfomationView()
    self.m_mediator    = CFactionInfomationMediator( tempinfoview)
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
    self.m_pageTag = CFactionPanelView.TAG_INFOMATION
    self.m_factionPageContainer = tempinfoview :layer()
    self.m_factionPanelViewContainer :addChild( self.m_factionPageContainer) 
--[[
    local mainProperty = _G.g_characterProperty : getMainPlay()
    local mypost       = mainProperty : getClanPost()
    print( "mypost",mypost)    
    if mypost == _G.Constant.CONST_CLAN_POST_SECOND or mypost == _G.Constant.CONST_CLAN_POST_MASTER then
        self.m_verifyButton :setVisible( true)
    else
        self.m_verifyButton :setVisible( false)
    end
    ]]
    ----[[--Tab
    self.m_buttonTab = CTab : create (eLD_Horizontal, CFactionPanelView.TAB_BUTTON_SIZE)--按钮间距   
    self.m_factionPanelViewContainer :addChild( self.m_buttonTab)

    local tempTabPage        = nil
    local tempPageContainer  = nil

    --社团列表
    self :addBttonTab( "社团列表", CallBack, CFactionPanelView.TAG_FACTIONLIST)
    --社团信息
    self :addBttonTab( "社团信息", CallBack, CFactionPanelView.TAG_INFOMATION)
    --社团成员
    self :addBttonTab( "社团成员", CallBack, CFactionPanelView.TAG_MEMBERLIST)
    --社团活动
    self :addBttonTab( "社团活动", CallBack, CFactionPanelView.TAG_ACTIVITY)
    --社团技能
    self :addBttonTab( "社团技能", CallBack, CFactionPanelView.TAG_SKILL)
    --]]

end

--向Tab内添加TabPage
function CFactionPanelView.addBttonTab( self, _string, _func, _tag)
    local _controlname = _string
    local tempTabPage         = self :createTabPage( _string, _func, _tag, _controlname)
    local tempPageContainer   = self :createContainer( "tempPageContainer :".._controlname)
    self.m_buttonTab : addTab( tempTabPage, tempPageContainer)
end

--创建按钮Button
function CFactionPanelView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionPanelView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CFactionPanelView ".._controlname)
    m_button :setFontSize( CFactionPanelView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CFactionPanelView ".._controlname.."CallBack")
    return m_button
end

--创建图片Sprite
function CFactionPanelView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CFactionPanelView createSprite _background".._controlname)
    return _background
end

--创建TabPage
function CFactionPanelView.createTabPage( self, _string, _func, _tag, _controlname)
    local _itemtabpage = CTabPage :createWithSpriteFrameName( _string, "general_label_normal.png", _string, "general_label_click.png")
    _itemtabpage :setFontSize( CFactionPanelView.FONT_SIZE)
    _itemtabpage :setTag( _tag)
    _itemtabpage :setControlName( _controlname)
    _itemtabpage :registerControlScriptHandler( _func, "this is CFactionPanelView.createTabPage _itemtabpage CallBack ".._controlname)
    return _itemtabpage
end
--创建CContainer
function CFactionPanelView.createContainer( self, _controlname)
    print( "CFactionPanelView.createContainer:".._controlname)
    local _itemcontainer = CContainer :create()
    _itemcontainer :setControlName( _controlname)
    return _itemcontainer
end


--更新本地list数据
function CFactionPanelView.setLocalList( self, _playercount, _playerlist)
    print("CFactionPanelView.setLocalList")
    self.m_playercount = _playercount
    self.m_playerlist  = _playerlist

    self :showAllRole()

end

--清空公共界面容器和相应的mediator
function CFactionPanelView.resetPageContainer( self)
    if self.m_factionPageContainer ~= nil then
        self.m_factionPageContainer :removeAllChildrenWithCleanup( true)
        self.m_factionPageContainer = nil
    end
    if self.m_mediator ~= nil then
        controller :unregisterMediator( self.m_mediator)
        self.m_mediator = nil
    end
    -- if _G.g_CFactionVerifyListMediator ~= nil then
    --     _G.controller : unregisterMediator( _G.g_CFactionVerifyListMediator )
    --     _G.g_CFactionVerifyListMediator = nil
    -- end
end


--创建与标签相对于的View
function CFactionPanelView.createViewByTag( self, _tag)
    self :resetPageContainer()
    --self.m_verifyButton :setVisible( false)
    local tempinfoview = nil
    if _tag == CFactionPanelView.TAG_SKILL then
        print(" 社团技能界面")
        self.m_pageTag = CFactionPanelView.TAG_SKILL
        tempinfoview                = CFactionSkillPanelView()
        self.m_mediator             = CFactionSkillMediator( tempinfoview)
        self.m_factionPageContainer = tempinfoview :layer()
    elseif _tag == CFactionPanelView.TAG_FACTIONLIST then
        print(" 社团列表界面")
        self.m_pageTag              = CFactionPanelView.TAG_FACTIONLIST
        tempinfoview                = CFactionCheckListView()
        self.m_mediator             = CFactionApplyMediator( tempinfoview)
        self.m_factionPageContainer = tempinfoview :layer()
    elseif _tag == CFactionPanelView.TAG_INFOMATION then
        print(" 社团信息界面")
        --self.m_verifyButton :setVisible( true)
        self.m_pageTag              = CFactionPanelView.TAG_INFOMATION
        tempinfoview                = CFactionInfomationView()     
        self.m_mediator             = CFactionInfomationMediator( tempinfoview)
        self.m_factionPageContainer = tempinfoview :layer()
    elseif _tag == CFactionPanelView.TAG_MEMBERLIST then
        print(" 社团成员界面") 
        self.m_pageTag              = CFactionPanelView.TAG_MEMBERLIST
        tempinfoview                = CFactionMemberListView()
        self.m_mediator             = CFactionMemberListMediator( tempinfoview)
        self.m_factionPageContainer = tempinfoview :layer()
    elseif _tag == CFactionPanelView.TAG_ACTIVITY then
        print(" 社团活动界面") 
        self.m_pageTag = CFactionPanelView.TAG_ACTIVITY
        tempinfoview                = CFactionActivePanelView()
        self.m_mediator             = CFactionActiveMediator( tempinfoview)
        self.m_factionPageContainer = tempinfoview :layer()
    end        
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
    self.m_factionPanelViewContainer :addChild( self.m_factionPageContainer, -1)
end
-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CFactionPanelView.clickCellCallBack(self,eventType, obj, x, y)        
    if eventType == "TouchBegan" then
        --删除Tips
        _G.g_FactionPopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CFactionPanelView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                if self.m_mediator ~= nil then
                    controller :unregisterMediator( self.m_mediator)
                    self.m_mediator = nil
                end
                -- if _G.g_CFactionVerifyListMediator ~= nil then
                --     _G.controller : unregisterMediator( _G.g_CFactionVerifyListMediator )
                --     _G.g_CFactionVerifyListMediator = nil
                -- end
                --controller :unregisterMediatorByName( "CEquipInfoMediator")
                CCDirector :sharedDirector() :popScene( )

                self : unloadResource()
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() == CFactionPanelView.TAG_SKILL and self.m_pageTag ~= CFactionPanelView.TAG_SKILL then
            print(" 社团技能界面")
            self :createViewByTag( CFactionPanelView.TAG_SKILL)
        elseif obj :getTag() == CFactionPanelView.TAG_FACTIONLIST  then --and self.m_pageTag ~= CFactionPanelView.TAG_FACTIONLIST
            print(" 社团列表界面")
            self :createViewByTag( CFactionPanelView.TAG_FACTIONLIST)
        elseif obj :getTag() == CFactionPanelView.TAG_INFOMATION  then  --and self.m_pageTag ~= CFactionPanelView.TAG_INFOMATION
            print(" 社团信息界面")
            self :createViewByTag( CFactionPanelView.TAG_INFOMATION)
        elseif obj :getTag() == CFactionPanelView.TAG_MEMBERLIST and self.m_pageTag ~= CFactionPanelView.TAG_MEMBERLIST then
            print(" 社团成员界面")
            self :createViewByTag( CFactionPanelView.TAG_MEMBERLIST)
        elseif obj :getTag() == CFactionPanelView.TAG_ACTIVITY and self.m_pageTag ~= CFactionPanelView.TAG_ACTIVITY then
            print(" 社团活动界面")
            self :createViewByTag( CFactionPanelView.TAG_ACTIVITY)
        end    
    end
end





















