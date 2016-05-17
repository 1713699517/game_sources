
--[[
 --CFactionApplyCheckView
 --社团申请主界面
 --]]

require "view/view"
require "mediator/mediator"
require "controller/command"

require "mediator/FactionMediator"
require "view/FactionPanelLayer/FactionInfomationView"

CFactionApplyCheckView = class(view, function( self)
    print("CFactionApplyCheckView:社团申请主界面")
    self.m_closedButton          = nil   --关闭按钮
    self.m_factionApplyViewContainer  = nil  --人物面板的容器层
end)
--Constant:
CFactionApplyCheckView.TAG_CLOSED       = 205  --关闭
CFactionApplyCheckView.FONT_SIZE        = 23

--加载资源
function CFactionApplyCheckView.loadResource( self)

end
--释放资源
function CFactionApplyCheckView.unLoadResource( self)
end
--初始化数据成员
function CFactionApplyCheckView.initParams( self, layer)
    print("CFactionApplyCheckView.initParams")
    ---require "mediator/FactionMediator"
    --self.m_mediator = CFactionApplyMediator( self)       
    --controller :registerMediator( self.m_mediator)--先注册后发送 否则会报错
end
--释放成员
function CFactionApplyCheckView.realeaseParams( self)
end

--布局成员
function CFactionApplyCheckView.layout( self, winSize)
    --640
    if winSize.height == 640 then
        print("640--社团申请主界面")
        --背景部分
        local backgroundSize          = CCSizeMake( winSize.height/3*4, winSize.height)
        local panelbackgroundfirst    = self.m_factionApplyViewContainer :getChildByTag( 100)
        local panelbackgroundsecond   = self.m_factionApplyViewContainer :getChildByTag( 101)
        local background              = self.m_factionApplyViewContainer :getChildByTag( 102)
        local closeButtonSize         = self.m_closedButton :getPreferredSize()
        local createButtonSize        = CCSizeMake( 160,80)--self.m_createButton :getPreferredSize()   
        background :setPreferredSize( CCSizeMake( winSize.width, winSize.height))    
        panelbackgroundfirst :setPreferredSize( backgroundSize)
        panelbackgroundsecond :setPreferredSize( CCSizeMake( backgroundSize.width-30, backgroundSize.height*0.87)) 
        background :setPosition( ccp( winSize.width/2, winSize.height/2))       
        panelbackgroundfirst :setPosition( ccp( winSize.width/2, winSize.height/2))
        panelbackgroundsecond :setPosition( ccp( winSize.width/2,  winSize.height*0.87/2+15))
        --界面名称
        self.m_viewnameLabel :setPosition( winSize.width/2, winSize.height-createButtonSize.height/2-10) 
        self.m_closedButton :setPosition( ccp( winSize.width/2+backgroundSize.width/2-closeButtonSize.width/2, winSize.height-closeButtonSize.height/2))
    --768
    elseif winSize.height == 768 then
        CCLOG("768--社团申请主界面")
        
    end
end

--主界面初始化
function CFactionApplyCheckView.init(self, winSize, layer)
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

function CFactionApplyCheckView.scene(self, _uid)
    print("create scene")
    self.m_factionUid = _uid
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    --local _scene = CCScene :create()
    self._scene = CCScene :create()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionApplyCheckView self.m_scenelayer 94 ")
    self :init(winSize, self.m_scenelayer)
    print("scene--->",self._scene, self.m_scenelayer)
    self._scene :addChild( self.m_scenelayer)
    return self._scene
end

function CFactionApplyCheckView.layer( self)
    print("create m_scenelayer")
    local winSize = CCDirector :sharedDirector() :getVisibleSize()
    self.m_scenelayer = CContainer :create()
    self.m_scenelayer : setControlName("this is CFactionApplyCheckView self.m_scenelayer 105 ")
    self :init(winSize, self.m_scenelayer)
    return self.m_scenelayer
end

--请求服务端消息
function CFactionApplyCheckView.requestService ( self)
    -- (手动) -- [33010]请求社团面板 -- 社团
    --未创建社团时请求社团列表
    require "common/protocol/auto/REQ_CLAN_ASL_CLANLIST"
    local msg = REQ_CLAN_ASL_CLANLIST()
    msg :setPage( 1)
    --_G.CNetwork :send( msg)
end


--创建按钮Button
function CFactionApplyCheckView.createButton( self, _string, _image, _func, _tag, _controlname)
    print( "CFactionApplyCheckView.createButton buttonname:".._string.._controlname)
    local m_button = CButton :createWithSpriteFrameName( _string, _image)
    m_button :setControlName( "this CFactionApplyCheckView ".._controlname)
    m_button :setFontSize( CFactionApplyCheckView.FONT_SIZE)
    m_button :setTag( _tag)
    m_button :registerControlScriptHandler( _func, "this CFactionApplyCheckView ".._controlname.."CallBack")
    return m_button
end

--初始化排行榜界面
function CFactionApplyCheckView.initView(self, layer)
    print("CFactionApplyCheckView.initView")
    --副本界面容器
    self.m_factionApplyViewContainer = CContainer :create()
    self.m_factionApplyViewContainer : setControlName("this is CFactionApplyCheckView self.m_factionApplyViewContainer 94 ")
    layer :addChild( self.m_factionApplyViewContainer)
    
    local function CallBack( eventType, obj, x, y)
        return self :clickCellCallBack( eventType, obj, x, y)
    end
    local background             = CSprite :createWithSpriteFrameName( "peneral_background.jpg")
    local panelbackgroundfirst   = CSprite :createWithSpriteFrameName( "general_first_underframe.png")     --背景Img
    local panelbackgroundsecond  = CSprite :createWithSpriteFrameName( "general_second_underframe.png")   --背景二级Img
    background :setControlName( "this CFactionApplyCheckView panelbackgroundfirst 140")
    panelbackgroundfirst : setControlName( "this CFactionApplyCheckView panelbackgroundfirst 124 ")
    panelbackgroundsecond : setControlName( "this CFactionApplyCheckView panelbackgroundsecond 125 ")
    --创建各种Button
    self.m_closedButton      = self :createButton( "", "general_close_normal.png", CallBack, CFactionApplyCheckView.TAG_CLOSED, "self.m_closedButton")                    
    --社团列表 界面标题
    self.m_viewnameLabel  = CCLabelTTF :create( "社团信息", "Arial", CFactionApplyCheckView.FONT_SIZE)
    self.m_factionApplyViewContainer :addChild( self.m_viewnameLabel)
    self.m_factionApplyViewContainer :addChild( background, -1, 102)
    self.m_factionApplyViewContainer :addChild( panelbackgroundfirst, -1, 100)
    self.m_factionApplyViewContainer :addChild( panelbackgroundsecond, -1, 101)

    self.m_factionApplyViewContainer :addChild( self.m_closedButton, 2)

    ----[[
    local tempinfoview          = CFactionInfomationView()     
    self.m_mediator             = CFactionInfomationMediator( tempinfoview)
    controller :registerMediator( self.m_mediator)
    self.m_factionApplyViewContainer :addChild( tempinfoview :layer( self.m_factionUid))
    --]]

    --
    --self :setLocalList()         
end

--更新本地list数据
function CFactionApplyCheckView.setLocalList( self, _factioncount, _factionlist)
    print("CFactionApplyCheckView.setLocalList")
end

-----------------------------------------------------
--回调函数
----------------------------------------------------
--BUTTON类型切换buttonCallBack
--单击回调
function CFactionApplyCheckView.clickCellCallBack(self,eventType, obj, x, y)        
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        print("obj: getTag()", obj: getTag())
        if obj :getTag() == CFactionApplyCheckView.TAG_CLOSED then
            print("关闭")
            if self ~= nil then
                controller :unregisterMediatorByName( "CFactionInfomationMediator")
                CCDirector :sharedDirector() :popScene( )
            else
                print("objSelf = nil", self)
            end
        end    
    end
end







































