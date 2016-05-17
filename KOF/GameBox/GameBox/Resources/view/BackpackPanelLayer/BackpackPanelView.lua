--[[
 --CBackpackPanelView
 --大背包面板主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "view/BackpackPanelLayer/BackpackView"

require "controller/GuideCommand"

CBackpackPanelView = class(view, function( self)
    print("CBackpackPanelView:大背包面板主界面")
    self.m_closedButton            = nil   --关闭按钮
    self.m_tagLayout               = nil   --5种Tag按钮的水平布局
    self.m_backpackPageContainer    = nil   --5个标签容器公用
    self.m_backpackPanelViewContainer  = nil  --人物面板的容器层
    self.m_sellList     = {}
    self.m_sellAllPrice = 0
end)

_G.g_CBackpackPanelView = CBackpackPanelView()
--Constant:
CBackpackPanelView.TAG_START          = 200  --开始标签
CBackpackPanelView.TAG_ALLGOODS       = 201  --全部
CBackpackPanelView.TAG_PROPS          = 202  --道具
CBackpackPanelView.TAG_GEMSTONE       = 203  --宝石
CBackpackPanelView.TAG_MATERIAL       = 204  --材料
CBackpackPanelView.TAG_CLOSED         = 205  --关闭

CBackpackPanelView.SELL_MAX_COUNT     = 12 --出售界面最大数量

CBackpackPanelView.TAB_BUTTON_SIZE    = CCSizeMake( 127, 60)
CBackpackPanelView.FONT_SIZE          = 23

--加载资源
function CBackpackPanelView.loadResource( self)
    -- CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist") 
    --CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("ImageBackpack/backpackUI.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("FactionResources/FactionResources.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("mainResources/MainUIResources.plist")    --货币
end
--释放资源
function CBackpackPanelView.unloadResources(self)

    --CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("ImageBackpack/backpackUI.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("FactionResources/FactionResources.plist")
    
    CCTextureCache :sharedTextureCache():removeTextureForKey("FactionResources/FactionResources.pvr.ccz")

    for i,v in ipairs(self.m_createResStrList) do

        print("     -----> "..v)
        local r = CCTextureCache :sharedTextureCache():textureForKey(v)
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
    end
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()

end

function CBackpackPanelView.setCreateResStr( self, _str )
    for i,v in ipairs(self.m_createResStrList) do
        if v == _str then
            return
        end
    end

    table.insert( self.m_createResStrList, _str )
end

--初始化数据成员
function CBackpackPanelView.initParams( self, layer)
    print("CBackpackPanelView.initParams")
    require "mediator/BackpackMediator"
    self.m_parntermediator = CBackpackMediator(self)
    controller :registerMediator(self.m_parntermediator)--先注册后发送 否则会报错  

    self.m_createResStrList = {}
end
--释放成员
function CBackpackPanelView.realeaseParams( self)
    if self.m_backpackPageContainer ~= nil then
        self.m_backpackPageContainer :removeAllChildrenWithCleanup( true)
    end

    self.m_createResStrList = {}
end

--布局成员
function CBackpackPanelView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--大背包面板主界面2")
        --背景部分
        local backgroundSize          = CCSizeMake( winSize.height/3*4, winSize.height)
        local backgroundfirst         = self.m_backpackPanelViewContainer :getChildByTag( 99)
        local panelbackgroundfirst    = self.m_backpackPanelViewContainer :getChildByTag( 100)
        local panelbackgroundsecond   = self.m_backpackPanelViewContainer :getChildByTag( 101)
        local closeButtonSize         = self.m_closedButton: getPreferredSize() 

        panelbackgroundfirst :setPreferredSize( backgroundSize)
        backgroundfirst :setPreferredSize( CCSizeMake( winSize.width, winSize.height))

        backgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        panelbackgroundsecond :setPreferredSize( CCSizeMake( backgroundSize.width*0.6, backgroundSize.height*0.87))        
        panelbackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        panelbackgroundsecond :setPosition( ccp( winSize.width/2-backgroundSize.width/2+backgroundSize.width*0.6/2+15, winSize.height*0.87/2+15))
        --默认显示属性
        self.m_buttonTab : setSelectedTabIndex( 0)--全部
        --标签Button部分
        self.m_buttonTab :setPosition( ccp( winSize.width/2-backgroundSize.width/2+20, winSize.height-closeButtonSize.height/2-10))
        self.m_closedButton :setPosition( ccp( winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--大背包面板主界面")        
    end
end

--主界面初始化
function CBackpackPanelView.init(self, winSize, layer)
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
    _G.pCGuideManager:initGuide( self.m_guideButton , _G.Constant.CONST_FUNC_OPEN_BAG)
end

function CBackpackPanelView.scene(self, _isSellType)
    print("create scene")
    self.m_isSellType = _isSellType
    if self.m_isSellType == nil then
        self.m_isSellType = false
    else
        self.m_isSellType = true
    end
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CBackpackPanelView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)

    local function local_onEnter(eventType, obj, x, y)
        return self:onEnter(eventType, obj, x, y)
    end
    self.m_scenelayer :registerControlScriptHandler(local_onEnter,"CBackpackPanelView scene self.m_scenelayer 136")

    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CBackpackPanelView.onEnter( self,eventType, obj, x, y )
    if eventType == "Enter" then
        --初始化指引
        print("CBackpackPanelView.Enter  ")
        -- _G.pCGuideManager:initGuide( self.m_guideButton , _G.Constant.CONST_FUNC_OPEN_BAG)
    elseif eventType == "Exit" then
        print("CBackpackPanelView.Exit  ")
        _G.pCGuideManager:exitView( _G.Constant.CONST_FUNC_OPEN_BAG )
    end
end

function CBackpackPanelView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CBackpackPanelView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CBackpackPanelView.requestService ( self)
    require "common/protocol/auto/REQ_ARENA_KILLER"
    --local msg = REQ_ARENA_KILLER()
    --_G.CNetwork :send( msg)
end

--初始化排行榜界面
function CBackpackPanelView.initView(self, layer)
    print("CBackpackPanelView.initView")
    --副本界面容器
    self.m_backpackPanelViewContainer = self :createContainer( "self.m_backpackPanelViewContainer")
    layer :addChild( self.m_backpackPanelViewContainer)
    
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local backgroundfirst        = self :createSprite( "peneral_background.jpg", "backgroundfirst")
    local panelbackgroundfirst   = self :createSprite( "general_first_underframe.png", "panelbackgroundfirst")
    local panelbackgroundsecond  = self :createSprite( "general_second_underframe.png", "panelbackgroundsecond")
    --创建各种Button
    self.m_closedButton      = self :createButton( "", "general_close_normal.png", CallBack, CBackpackPanelView.TAG_CLOSED, "self.m_closedButton")    
    --addChild
    self.m_backpackPanelViewContainer :addChild( backgroundfirst, -1, 99)
    self.m_backpackPanelViewContainer :addChild( panelbackgroundfirst, -1, 100)
    self.m_backpackPanelViewContainer :addChild( panelbackgroundsecond, -1, 101)
    self.m_backpackPanelViewContainer :addChild( self.m_closedButton, 2)
    

    self.m_guideButton                   = CButton :createWithSpriteFrameName( "", "transparent.png")
    self.m_guideButton : setControlName( "this CBarPanelView self.m_guideButton 134 " )
    self.m_guideButton :registerControlScriptHandler( CallBack, "this CBarPanelView self.m_guideButton 147")
    self.m_backpackPanelViewContainer :addChild( self.m_guideButton, 2000)

    --默认属性界面
    --add:
    --local tempinfoview = CFactionInfomationView()
    --self.m_mediator    = CFactionInfomationMediator( tempinfoview)
    --controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
    --self.m_pageTag = CBackpackPanelView.TAG_PROPS
    --self.m_backpackPageContainer = tempinfoview :layer()
    --self.m_backpackPanelViewContainer :addChild( self.m_backpackPageContainer) 
    ----[[
    print( "出售")
    require "view/BackpackPanelLayer/BackpackSellView"
    _G.pBackpackSellView = CBackpackSellView()
    self.m_backpackPanelViewContainer :addChild( _G.pBackpackSellView :layer(), 0)
    
    self.m_tempinfoview = CBackpackView()
    self.m_mediator = CCharacterPropsMediator( self.m_tempinfoview)
    controller :registerMediator( self.m_mediator)
    self.m_backpackPageContainer = self.m_tempinfoview :layer( 1, self.m_partnerId)
    self.m_backpackPanelViewContainer :addChild( self.m_backpackPageContainer, 1)
    --Tab
    self.m_buttonTab = CTab : create (eLD_Horizontal, CBackpackPanelView.TAB_BUTTON_SIZE)--按钮间距   
    self.m_backpackPanelViewContainer :addChild( self.m_buttonTab)
    
    self :addBttonTab( "全部", CallBack, CBackpackPanelView.TAG_ALLGOODS) --全部
    self :addBttonTab( "道具", CallBack, CBackpackPanelView.TAG_PROPS)    --道具    
    self :addBttonTab( "宝石", CallBack, CBackpackPanelView.TAG_GEMSTONE) --宝石    
    self :addBttonTab( "材料", CallBack, CBackpackPanelView.TAG_MATERIAL) --材料
    --]]

end

function CBackpackPanelView.getGoodsBtnById( self, _goodsId )

    if self.m_tempinfoview ~= nil then 
        return self.m_tempinfoview:getGoodsBtnById( _goodsId )
    end

    return nil
end

--向Tab内添加TabPage
function CBackpackPanelView.addBttonTab( self, _string, _func, _tag)
    local _controlname = _string
    local tempTabPage         = self :createTabPage( _string, _func, _tag, _controlname)
    local tempPageContainer   = self :createContainer( "tempPageContainer :".._controlname)
    self.m_buttonTab : addTab( tempTabPage, tempPageContainer)
end

--创建按钮Button
function CBackpackPanelView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CBackpackPanelView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CBackpackPanelView ".._controlname)
    m_button :setFontSize( CBackpackPanelView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CBackpackPanelView ".._controlname.."CallBack")
    return m_button
end

--创建图片Sprite
function CBackpackPanelView.createSprite( self, _image, _controlname)
    local _background = CSprite :createWithSpriteFrameName( _image)
    _background :setControlName( "this CBackpackPanelView createSprite _background".._controlname)
    return _background
end

--创建TabPage
function CBackpackPanelView.createTabPage( self, _string, _func, _tag, _controlname)
    local _itemtabpage = CTabPage :createWithSpriteFrameName( _string, "general_label_normal.png", _string, "general_label_click.png")
    _itemtabpage :setFontSize( CBackpackPanelView.FONT_SIZE)
    _itemtabpage :setTag( _tag)
    _itemtabpage :setControlName( _controlname)
    _itemtabpage :registerControlScriptHandler( _func, "this is CBackpackPanelView.createTabPage _itemtabpage CallBack ".._controlname)
    return _itemtabpage
end
--创建CContainer
function CBackpackPanelView.createContainer( self, _controlname)
    print( "CBackpackPanelView.createContainer:".._controlname)
    local _itemcontainer = CContainer :create()
    _itemcontainer :setControlName( _controlname)
    return _itemcontainer
end
-------------------------------------------------------------------------
function CBackpackPanelView.getSceneContainer(self)
    return self.m_scenelayer
end
--出售相关
function CBackpackPanelView.getSellList(self)
    return self.m_sellList
end
function CBackpackPanelView.getAllPrice(self)
    return self.m_sellAllPrice
end
function CBackpackPanelView.getOneCountByIndex(self, _index)
    for k,v in pairs(self.m_sellList) do
        print(k,v)
        if v.good.index == _index then
            return v.count
        end
    end
    return 0
end
function CBackpackPanelView.getSellIsMax(self)
    if #self.m_sellList < CBackpackPanelView.SELL_MAX_COUNT then
        return true
    end
    return false
end
function CBackpackPanelView.getOneByIndex(self, _index)  --背包设置灰色
    for k,v in pairs(self.m_sellList) do
        print(k,v.good.index)
        if tonumber(v.good.index) == tonumber(_index) then
            return true
        end
    end    
    return false
end
function CBackpackPanelView.deleteOne(self, _index) --出售界面取消出售
    for k,v in pairs(self.m_sellList) do
        print(k,v.good.index)
        if tonumber(v.good.index) == tonumber(_index) then
            self.m_sellAllPrice = self.m_sellAllPrice - v.good.price*v.count
            table.remove(self.m_sellList, k)
            break
        end
    end
end
function CBackpackPanelView.addOne(self, _good, _count) --tips 和 重叠使用框中使用
    local data = {}
    data.good  = _good
    data.count = _count
    self.m_sellAllPrice = self.m_sellAllPrice + _good.price*_count
    table.insert( self.m_sellList, data)
end
function CBackpackPanelView.deleteAll(self)  --出售按钮后
    self.m_sellList      = {}
    self.m_sellAllPrice  = 0
end

-------------------------------------------------------------------------
--更新本地list数据
function CBackpackPanelView.setLocalList( self, _playercount, _playerlist)
    print("CBackpackPanelView.setLocalList")
    self.m_playercount = _playercount
    self.m_playerlist  = _playerlist
end

--清空公共界面容器和相应的mediator
function CBackpackPanelView.resetPageContainer( self)
    self.m_tempinfoview : removeAllCCBI() --当前界面CCBI的删除 jun
    if self.m_backpackPageContainer ~= nil then  --删除背包
        self.m_backpackPageContainer :removeAllChildrenWithCleanup( true)
        self.m_backpackPageContainer = nil
    end
    if self.m_mediator ~= nil then  --注销mediator
        print("注销mediator")
        controller : unregisterMediator( self.m_mediator)
        self.m_mediator = nil
    end
end


--创建与标签相对于的View
function CBackpackPanelView.createViewByTag( self, _tag)
    self :resetPageContainer()
    local tempinfoview = CBackpackView()
    self.m_mediator    = CCharacterPropsMediator( tempinfoview)
    controller :registerMediator( self.m_mediator)
    self.m_backpackPageContainer = tempinfoview :layer( _tag-CBackpackPanelView.TAG_START)      
    self.m_backpackPanelViewContainer :addChild( self.m_backpackPageContainer, 2)
end

function CBackpackPanelView.closeBackpackPanel( self)
    print("关闭")
    self.m_tempinfoview : removeAllCCBI() --当前界面CCBI的删除 jun
    if self ~= nil then
        if self.m_mediator ~= nil then  --注销mediator
            print("注销mediator")
            controller : unregisterMediator( self.m_parntermediator)  --伙伴卡相关处理
            controller : unregisterMediator( self.m_mediator)
            self.m_parntermediator = nil
            self.m_mediator = nil
        end
        --controller :unregisterMediatorByName( "CEquipInfoMediator")
        CCDirector :sharedDirector() :popScene( )
        self:unloadResources()
        self:deleteAll()
        --_G.g_CBackpackPanelView = nil
    else
        print("objSelf = nil", self)
    end
end
-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CBackpackPanelView.clickCellCallBack(self,eventType, obj, x, y)        
    if eventType == "TouchBegan" then
        --删除Tips
        _G.g_PopupView :reset()
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CBackpackPanelView.TAG_CLOSED then
            print("关闭")
            self.m_tempinfoview : removeAllCCBI() --当前界面CCBI的删除 jun
            if self ~= nil then
                if self.m_mediator ~= nil then  --注销mediator
                    print("注销mediator")
                    controller : unregisterMediator( self.m_parntermediator)  --伙伴卡相关处理
                    controller : unregisterMediator( self.m_mediator)
                    self.m_parntermediator = nil
                    self.m_mediator = nil
                end
                --controller :unregisterMediatorByName( "CEquipInfoMediator")
                CCDirector :sharedDirector() :popScene( )
                self:unloadResources()
                self:deleteAll()
                --_G.g_CBackpackPanelView = nil
            else
                print("objSelf = nil", self)
            end
            if self.m_isSellType == true then --如果是出售时打开界面 弹出玩家信息
                require "view/CharacterPanelLayer/CharacterPanelView"
                CCDirector :sharedDirector() :pushScene( _G.g_CharacterPanelView :scene())
            end
        elseif obj :getTag() == CBackpackPanelView.TAG_ALLGOODS and self.m_pageTag ~= CBackpackPanelView.TAG_ALLGOODS then 
            print(" 全部界面")
            self.m_pageTag    = CBackpackPanelView.TAG_ALLGOODS
            self :createViewByTag( CBackpackPanelView.TAG_ALLGOODS)
        elseif obj :getTag() == CBackpackPanelView.TAG_PROPS and self.m_pageTag ~= CBackpackPanelView.TAG_PROPS then  
            print(" 道具界面")
            self.m_pageTag    = CBackpackPanelView.TAG_PROPS 
            self :createViewByTag( CBackpackPanelView.TAG_PROPS)
        elseif obj :getTag() == CBackpackPanelView.TAG_GEMSTONE and self.m_pageTag ~= CBackpackPanelView.TAG_GEMSTONE then
            print(" 宝石界面")
            self.m_pageTag    = CBackpackPanelView.TAG_GEMSTONE
            self :createViewByTag( CBackpackPanelView.TAG_GEMSTONE)
        elseif obj :getTag() == CBackpackPanelView.TAG_MATERIAL and self.m_pageTag ~= CBackpackPanelView.TAG_MATERIAL then
            print(" 材料界面")
            self.m_pageTag    = CBackpackPanelView.TAG_MATERIAL
            self :createViewByTag( CBackpackPanelView.TAG_MATERIAL)
        end    
    end
end


--新手引导点击命令
function CBackpackPanelView.setGuideStepFinish( self )
    local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_END )
    controller:sendCommand(_guideCommand)
end


















