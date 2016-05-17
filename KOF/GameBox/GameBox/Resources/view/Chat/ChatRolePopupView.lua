require "view/view"
require "view/Stage/PKWaitReceiveView"

CChatRolePopupView = class(view, function( self, _uid, _name, _lv, _x, _y )
    self.m_nUid = _uid
    self.m_szName = _name or ""
    self.m_nLv = _lv
    self.m_nX = _x
    self.m_nY = _y
    self.winSize = CCDirector : sharedDirector() : getVisibleSize()

end)

CChatRolePopupView.TAG_INFO = 10
CChatRolePopupView.TAG_FRIEND = 20
CChatRolePopupView.TAG_PM = 30
CChatRolePopupView.TAG_PK = 40



function CChatRolePopupView.loadResources( self )
    CCSpriteFrameCache : sharedSpriteFrameCache() : addSpriteFramesWithFile( "General.plist" )
end

function CChatRolePopupView.getShowView( self )
    self : loadResources()
    self : initView()
    self : initlayout()

    local backgroundSize = self.m_lpBackground : getPreferredSize()
    local x = self.m_nX
    local y = self.m_nY
    x = (x + backgroundSize.width/2) > (self.winSize.width) and (self.winSize.width - backgroundSize.width/2) or x
    x = (x - backgroundSize.width/2 < 0) and (backgroundSize.width/2 or x) or x
    y = (y + backgroundSize.height/2) > (self.winSize.height) and (self.winSize.height - backgroundSize.height/2) or y
    y = (y - backgroundSize.height/2 < 0) and (backgroundSize.height/2 or y) or y
    self.m_lpBackground : setPosition( x, y )
    return self.m_lpBackground
end

function CChatRolePopupView.initView( self )
    self.m_lpBackground = CSprite : createWithSpriteFrameName( "general_thirdly_underframe.png" )
    self.m_lpInfoBtn = CButton :createWithSpriteFrameName("查看信息", "general_button_normal.png")
    self.m_lpFriendBtn = CButton :createWithSpriteFrameName("加为好友", "general_button_normal.png")
    self.m_lpPMBtn = CButton :createWithSpriteFrameName("私聊", "general_button_normal.png")
    self.m_lpPKBtn = CButton :createWithSpriteFrameName("邀请切磋", "general_button_normal.png")
    self.m_lpName = CCLabelTTF : create( self.m_szName, "Marker Felt", 20 )
    self.m_lpLv = CCLabelTTF : create( "等级  "..tostring(self.m_nLv), "Marker Felt", 20 )

    self.m_lpBackground : setControlName( "this is CChatRolePopupView, m_lpBackground, 28" )
    self.m_lpInfoBtn : setControlName( "this is CChatRolePopupView, m_lpInfoBtn, 29" )
    self.m_lpFriendBtn : setControlName( "this is CChatRolePopupView, m_lpFriendBtn, 30" )
    self.m_lpPMBtn : setControlName( "this is CChatRolePopupView, m_lpPMBtn, 31" )
    self.m_lpPKBtn : setControlName( "this is CChatRolePopupView, m_lpPKBtn, 32" )

    self.m_lpBackground : setTouchesPriority( -20001 )
    self.m_lpInfoBtn : setTouchesPriority( -20002 )
    self.m_lpFriendBtn : setTouchesPriority( -20002 )
    self.m_lpPMBtn : setTouchesPriority( -20002 )
    self.m_lpPKBtn : setTouchesPriority( -20002 )

    self.m_lpBackground : setTouchesEnabled( true )
    self.m_lpInfoBtn : setTouchesEnabled( true )
    self.m_lpFriendBtn : setTouchesEnabled( true )
    self.m_lpPMBtn : setTouchesEnabled( true )
    self.m_lpPKBtn : setTouchesEnabled( true )

    self.m_lpInfoBtn : setTag( self.TAG_INFO )
    self.m_lpFriendBtn : setTag( self.TAG_FRIEND )
    self.m_lpPMBtn : setTag( self.TAG_PM )
    self.m_lpPKBtn : setTag( self.TAG_PK )

    local function CellCallBack( eventType, obj, x, y)
       return self : clickCellCallBack( eventType, obj, x, y)
    end

    self.m_lpBackground : registerControlScriptHandler( CellCallBack, "this CChatRolePopupView self.m_lpBackground 62")
    self.m_lpInfoBtn : registerControlScriptHandler( CellCallBack, "this CChatRolePopupView self.m_lpInfoBtn 63")
    self.m_lpFriendBtn : registerControlScriptHandler( CellCallBack, "this CChatRolePopupView self.m_lpFriendBtn 64")
    self.m_lpPMBtn : registerControlScriptHandler( CellCallBack, "this CChatRolePopupView self.m_lpPMBtn 65")
    self.m_lpPKBtn : registerControlScriptHandler( CellCallBack, "this CChatRolePopupView self.m_lpPKBtn 66")

    self.m_lpBackground : addChild( self.m_lpInfoBtn )
    self.m_lpBackground : addChild( self.m_lpFriendBtn )
    self.m_lpBackground : addChild( self.m_lpPMBtn )
    --self.m_lpBackground : addChild( self.m_lpPKBtn )
    self.m_lpBackground : addChild( self.m_lpName )
    self.m_lpBackground : addChild( self.m_lpLv )
end


function CChatRolePopupView.initlayout( self )
    local backgroundSize = CCSizeMake( 415, 280 )
    self.m_lpBackground : setPreferredSize( backgroundSize )

    local infoBtnSize = self.m_lpInfoBtn : getPreferredSize()
    self.m_lpInfoBtn : setPosition( 0-backgroundSize.width/4,0)

    local friendBtnSize = self.m_lpFriendBtn : getPreferredSize()
    self.m_lpFriendBtn : setPosition( backgroundSize.width/4,0)

    local PMBtnSize = self.m_lpPMBtn : getPreferredSize()
    self.m_lpPMBtn : setPosition( 0-backgroundSize.width/4, 0-backgroundSize.height/4)

    local PKBtnSize = self.m_lpPKBtn : getPreferredSize()
    self.m_lpPKBtn : setPosition( backgroundSize.width/4, 0-backgroundSize.height/4)

    self.m_lpName : setAnchorPoint( ccp(0,0.5) )
    self.m_lpLv : setAnchorPoint( ccp(0,0.5) )

    self.m_lpName : setPosition(0-backgroundSize.width/4 - infoBtnSize.width/2,backgroundSize.height/4)
    self.m_lpLv : setPosition(0-backgroundSize.width/4 - infoBtnSize.width/2,backgroundSize.height/4-20)

end

--事件响应
function CChatRolePopupView.clickCellCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            if obj : getTag() == self.TAG_INFO then
                self : clickInfo()
            elseif obj : getTag() == self.TAG_FRIEND then
                self : clickFriedn()
            elseif obj : getTag() == self.TAG_PM then
                self : clickPM()
            elseif obj : getTag() == self.TAG_PK then
                self : clickPK()
            end
            if self.m_lpBackground ~= nil then
                self.m_lpBackground : removeFromParentAndCleanup( true )
                self.m_lpBackground = nil
            end
            return true
        end
    end
end

function CChatRolePopupView.reset( self)
    if self.m_lpBackground ~= nil then
        self.m_lpBackground : removeFromParentAndCleanup( true )
        self.m_lpBackground = nil
    end
end

function CChatRolePopupView.clickInfo( self )
    print( "查看信息:")
    --请求玩家身上装备 --本玩家
    print("请求玩家身上装备开始")
    local msg = REQ_GOODS_EQUIP_ASK()
    msg :setUid( self.m_nUid)
    msg :setPartner( 0)
    _G.CNetwork :send( msg)
    print("请求玩家身上装备结束")
    print("请求玩家属性开始:"..(self.m_nUid))
    local msg_role = REQ_ROLE_PROPERTY()
    msg_role: setSid( _G.g_LoginInfoProxy :getServerId() )
    msg_role: setUid( self.m_nUid )
    msg_role: setType( 0 )
    _G.CNetwork : send( msg_role )
    print("请求玩家属性结束")
end
function CChatRolePopupView.clickFriedn( self )
    require "common/protocol/auto/REQ_FRIEND_ADD"
    local msg = REQ_FRIEND_ADD()
    msg :setType( 1 )
    msg :setCount( 1 )
    msg :setDetail( { self.m_nUid } )
    _G.CNetwork : send( msg )
end
function CChatRolePopupView.clickPM( self )
    CCDirector :sharedDirector() :popScene()
    local _wayCommand = CFriendOpenChatCommand( self.m_szName )
    _G.controller:sendCommand(_wayCommand)
end
function CChatRolePopupView.clickPK( self )
    local comm = CStageREQCommand(_G.Protocol["REQ_WAR_PK"])
    comm : setOtherData( {uid=self.m_nUid} )
    _G.controller : sendCommand( comm )
    local timeOut = (_G.g_ServerTime : getServerTimeSeconds())+30
    local tempView = CPKWaitReceiveView(timeOut)
    local container = _G.g_Stage : getPKReceiveContainer()
    container : addChild( tempView : getShowView() )
end



