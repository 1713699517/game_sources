--[[
 --CFactionCreateView
 --社团创建主界面
 --]]
require "view/view"
require "mediator/mediator"
require "controller/command"

require "common/WordFilter"
require "view/ErrorBox/ErrorBox"

CFactionCreateView = class(view, function( self)
    print("CFactionCreateView:社团创建主界面")
    self.m_createButton          = nil   --创建按钮
    self.m_cancleButton          = nil   --取消按钮
    self.m_closedButton          = nil   --关闭按钮
    self.m_factionCreateViewContainer  = nil  --人物面板的容器层
end)
--Constant:
CFactionCreateView.TAG_CREATE       = 200  --创建
CFactionCreateView.TAG_CANCLE       = 201  --取消
CFactionCreateView.TAG_CLOSED       = 202  --关闭

CFactionCreateView.FONT_SIZE        = 23

--加载资源
function CFactionCreateView.loadResource( self)
end
--释放资源
function CFactionCreateView.unLoadResource( self)

end
--初始化数据成员
function CFactionCreateView.initParams( self, layer)
    print("CFactionCreateView.initParams")
    --注册mediator
    require "mediator/FactionMediator"
    self.m_mediator = CFactionCreateMediator( self)
    controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
    --初始化屏蔽字库
    _G.g_WordFilter :initialize()
end
--释放成员
function CFactionCreateView.realeaseParams( self)
    --释放屏蔽字库
    _G.g_WordFilter :destory()
    --注销mediator
    controller :unregisterMediator( self.m_mediator)
    --释放资源
    self :unLoadResource()
    --移除界面
    if self.m_scenelayer ~= nil then
        self.m_scenelayer :removeFromParentAndCleanup( true)
        self.m_scenelayer = nil
    end
end
--布局成员
function CFactionCreateView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团创建主界面")
        --背景部分
        local backgroundSize          = CCSizeMake( winSize.height/3*4*0.6, winSize.height*0.7)
        local panelbackgroundfirst    = self.m_factionCreateViewContainer :getChildByTag( 100)
        local panelbackgroundsecond   = self.m_factionCreateViewContainer :getChildByTag( 101)
        local closeButtonSize         = self.m_closedButton :getPreferredSize()
        local createButtonSize        = self.m_createButton :getPreferredSize()       
        panelbackgroundfirst :setPreferredSize( backgroundSize)
        panelbackgroundsecond :setPreferredSize( CCSizeMake( backgroundSize.width-50, backgroundSize.height*0.72))        
        panelbackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        panelbackgroundsecond :setPosition( ccp( winSize.width/2, winSize.height*0.45+20))
        --界面名称
        self.m_viewnameLabel :setPosition( winSize.width/2, winSize.height/2+backgroundSize.height/2-createButtonSize.height/2-20)
        self.m_factioninfoLabel :setPosition( ccp( winSize.width*0.3-10, winSize.height/2+100))
        self.m_editbox :setPosition( ccp( winSize.width*0.55, winSize.height/2+100))
        self.m_claimGoldLabel :setPosition( ccp( winSize.width*0.35, winSize.height/2+30))
        self.m_claimLvLabel :setPosition( ccp( winSize.width*0.35, winSize.height/2-20))
        self.m_createButton :setPosition( ccp( winSize.width/2+createButtonSize.width/2+20, winSize.height/2-createButtonSize.height-40))
        self.m_cancleButton :setPosition( ccp( winSize.width/2-createButtonSize.width/2-20, winSize.height/2-createButtonSize.height-40))
        self.m_closedButton :setPosition( ccp( winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2-15, winSize.height/2+backgroundSize.height/2-closeButtonSize.height/2-10))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团创建主界面")        
    end
end

--主界面初始化
function CFactionCreateView.init(self, winSize, layer)
    print("viewID:",self._viewID)
    --加载资源
    -- self.loadResource(self)
    --初始化数据
    self.initParams(self,layer)
    --初始化界面
    self.initView(self, layer)
    --请求服务端消息
    self.requestService(self)
    --布局成员
    self.layout(self, winSize)  
end

function CFactionCreateView.scene(self)
    print("create scene")
    local winSize      = CCDirector :sharedDirector() :getVisibleSize()
    self._scene        = CCScene :create()
    self.m_scenelayer  = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionCreateView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionCreateView.layer( self)
    print("create m_scenelayer")
    local function local_fullScreenTouchCallBack( eventType, obj, x , y )
        if eventType == "TouchBegan" then
            return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
        elseif eventType == "TouchEnded" then
            return false
        end
    end
    local winSize     = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionCreateView self.m_scenelayer 105 ")
    --self.m_scenelayer : setTouchesEnabled( true )
    --self.m_scenelayer : setFullScreenTouchEnabled( true )
    --self.m_scenelayer : setTouchesPriority( -200 )
    --self.m_scenelayer : registerControlScriptHandler(local_fullScreenTouchCallBack,"this is CPlotView self.m_scenelayer 462")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionCreateView.requestService ( self)
    --require "common/protocol/auto/REQ_ARENA_KILLER"
    --local msg = REQ_ARENA_KILLER()
    --_G.CNetwork :send( msg)
end

--初始化排行榜界面
function CFactionCreateView.initView(self, layer)
    print("CFactionCreateView.initView")
    --副本界面容器
    self.m_factionCreateViewContainer = CContainer :create()
    self.m_factionCreateViewContainer : setControlName("this is CFactionCreateView self.m_factionCreateViewContainer 94 ")
    layer :addChild( self.m_factionCreateViewContainer)
    
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local panelbackgroundfirst   = CSprite :createWithSpriteFrameName( "general_thirdly_underframe.png")     --背景Img
    local panelbackgroundsecond  = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    panelbackgroundfirst : setControlName( "this CFactionCreateView panelbackgroundfirst 124 ")
    panelbackgroundsecond : setControlName( "this CFactionCreateView panelbackgroundsecond 125 ")
    --创建各种Button
    self.m_createButton      = self :createButton( "创建社团", "general_button_normal.png", CallBack, CFactionCreateView.TAG_CREATE, "self.m_createButton")   
    self.m_cancleButton      = self :createButton( "取消", "general_button_normal.png", CallBack, CFactionCreateView.TAG_CANCLE, "self.m_cancleButton")
    self.m_closedButton      = self :createButton( "", "general_close_normal.png", CallBack, CFactionCreateView.TAG_CLOSED, "self.m_closedButton")                    
    
    --创建提示信息Label  
    self.m_factioninfoLabel  = CCLabelTTF :create( "社团名称:", "Arial", CFactionCreateView.FONT_SIZE)
    self.m_claimGoldLabel    = CCLabelTTF :create( "消耗美刀: ".._G.Constant.CONST_CLAN_CREATE_COST.."万", "Arial", CFactionCreateView.FONT_SIZE)
    self.m_claimLvLabel      = CCLabelTTF :create( "需要等级: ".._G.Constant.CONST_CLAN_LV_LIMIT.."级", "Arial", CFactionCreateView.FONT_SIZE)

    self.m_factioninfoLabel :setAnchorPoint( ccp(0,0.5))
    self.m_claimGoldLabel :setAnchorPoint( ccp(0,0.5))
    self.m_claimLvLabel :setAnchorPoint( ccp(0,0.5))

    local editboxSize          = CCSizeMake( 300, 50)
    local editboxBackground    = CCScale9Sprite :createWithSpriteFrameName( "general_second_underframe.png")
    local editboxDefaultString = "请输入社团名称"
    self.m_editbox = CEditBox :create( editboxSize, editboxBackground, 40, editboxDefaultString, kEditBoxInputFlagSensitive)
    self.m_editbox :registerControlScriptHandler( CallBack, " this is CFactionCreateView self.m_editbox CallBack")

    --社团列表 界面标题
    self.m_viewnameLabel  = CCLabelTTF :create( "创建社团", "Arial", CFactionCreateView.FONT_SIZE)

    self.m_factionCreateViewContainer :addChild( self.m_viewnameLabel)
    self.m_factionCreateViewContainer :addChild( self.m_factioninfoLabel)
    self.m_factionCreateViewContainer :addChild( self.m_claimGoldLabel)
    self.m_factionCreateViewContainer :addChild( self.m_claimLvLabel)
    self.m_factionCreateViewContainer :addChild( self.m_editbox)
    self.m_factionCreateViewContainer :addChild( panelbackgroundfirst, -1, 100)
    self.m_factionCreateViewContainer :addChild( panelbackgroundsecond, -1, 101)
    self.m_factionCreateViewContainer :addChild( self.m_createButton)
    self.m_factionCreateViewContainer :addChild( self.m_cancleButton)
    self.m_factionCreateViewContainer :addChild( self.m_closedButton, 2)      
end

--创建按钮Button
function CFactionCreateView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionCreateView.createButton buttonname:".._string.._controlname)
    local _itembutton = CButton :createWithSpriteFrameName( _string, _image)
    _itembutton :setControlName( "this CFactionCreateView ".._controlname)
    _itembutton :setFontSize( CFactionCreateView.FONT_SIZE)
    _itembutton :setTag( _tag)
    _itembutton :registerControlScriptHandler( _func, "this CFactionCreateView ".._controlname.."CallBack")
    return _itembutton
end

--更新本地list数据
function CFactionCreateView.setLocalList( self, _factioncount, _factionlist)
    print("CFactionCreateView.setLocalList")
end

function CFactionCreateView.createClanSuccess( self)
    print("CFactionCreateView.createClanSuccess")
    self :realeaseParams()
    require "view/FactionPanelLayer/FactionPanelView"
    CCDirector :sharedDirector() :popScene()
    _G.pFactionPanelView = CFactionPanelView()
    CCDirector :sharedDirector() :pushScene( _G.pFactionPanelView :scene())
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CFactionCreateView.clickCellCallBack(self,eventType, obj, x, y)     
print("FFFF:", eventType)   
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "EditBoxReturn" then 
        print( "EEEE:", x)
        local szClanName = tostring( self.m_editbox :getTextString())
        print("szClanName: ",szClanName)
        if szClanName == "" then
            --CCMessageBox("输入名称不能为空，请重新输入","Editbox输入回调")   
            local ErrorBox = CErrorBox()
            local function func1()
                print("确定")
            end
            local BoxLayer = ErrorBox : create("输入名称不能为空，请重新输入！",func1)  
            self.m_scenelayer: addChild(BoxLayer,1000)       
            self.m_editbox :setTextString(szClanName)
        elseif _G.g_WordFilter :hasBanWord( szClanName) then  
            --CCMessageBox("输入名称包含敏感字符，请重新输入","Editbox输入回调")  
            local ErrorBox = CErrorBox()
            local function func1()
                print("确定")
            end
            local BoxLayer = ErrorBox : create("输入名称包含敏感字符，请重新输入！",func1)  
            self.m_scenelayer: addChild(BoxLayer,1000)       
            self.m_editbox :setTextString(szClanName)
        else
            local res = string.find(self.m_editbox :getTextString(), " ") --查找是否含有空格
            if res ~= nil and res > 0 then
                --CCMessageBox("输入名称包含有空格，请重新输入","Editbox输入回调") 
                local ErrorBox = CErrorBox()
                local function func1()
                    print("确定")
                end
                local BoxLayer = ErrorBox : create("输入名称包含有空格，请重新输入！",func1)
                self.m_scenelayer: addChild(BoxLayer,1000)        
                self.m_editbox :setTextString(szClanName)
            end
        end
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CFactionCreateView.TAG_CLOSED or obj :getTag() == CFactionCreateView.TAG_CANCLE then
            print("关闭/取消")
            if self ~= nil then
                self :realeaseParams()
            else
                print("objSelf = nil", self)
            end
        elseif obj :getTag() == CFactionCreateView.TAG_CREATE then
            print(" 创建社团:"..self.m_editbox :getTextString())
            -- (手动) -- [33050]请求创建社团 -- 社团
            local clanname = self.m_editbox :getTextString()
            if clanname == "" then
                --CCMessageBox("输入名称不能为空，请重新输入","Editbox输入回调")
                local ErrorBox = CErrorBox()
                local function func1()
                    print("确定")
                end
                local BoxLayer = ErrorBox : create("输入名称不能为空，请重新输入！",func1)
                self.m_scenelayer: addChild(BoxLayer,1000)        
                self.m_editbox :setTextString(clanname)
            else
                require "common/protocol/auto/REQ_CLAN_ASK_REBUILD_CLAN"
                local msg = REQ_CLAN_ASK_REBUILD_CLAN()
                msg :setClanName( clanname)
                _G.CNetwork :send( msg)
            end
        end    
    end
end


















