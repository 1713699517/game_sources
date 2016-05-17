require "view/view"
require "view/Stage/PKWaitReceiveView"

CTouchPlayView = class(view, function( self, _uid, _name, _lv, _pro, _x, _y )
    self.m_nUid = _uid
    self.m_szName = _name or ""
    self.m_nLv = _lv
    self.m_nPro = _pro or "1"
    self.m_nX = _x
    self.m_nY = _y
    self.winSize = CCDirector : sharedDirector() : getVisibleSize()

    self.m_szProName =  CLanguageManager :sharedLanguageManager() :getString( tostring("Role_ProName_0" .. tostring( self.m_nPro) ))        --职业名称

end)

CTouchPlayView.TAG_INFO = 10
CTouchPlayView.TAG_FRIEND = 20
CTouchPlayView.TAG_PM = 30
CTouchPlayView.TAG_PK = 40



function CTouchPlayView.loadResources( self )
    CCSpriteFrameCache : sharedSpriteFrameCache() : addSpriteFramesWithFile( "General.plist" )
    CCSpriteFrameCache : sharedSpriteFrameCache() : addSpriteFramesWithFile( "mainResources/RoleCardResources.plist" )
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("HeadIconResources/HeadIconResources.plist")
end

function CTouchPlayView.getShowView( self )
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

function CTouchPlayView.initView( self )
    self.m_lpBackground = CSprite : createWithSpriteFrameName( "card_underframe.png" )
    self.m_lpInfoBtn = CButton :createWithSpriteFrameName("查看信息", "general_button_normal.png")
    self.m_lpFriendBtn = CButton :createWithSpriteFrameName("加为好友", "general_button_normal.png")
    self.m_lpPMBtn = CButton :createWithSpriteFrameName("私聊", "general_button_normal.png")
    self.m_lpPKBtn = CButton :createWithSpriteFrameName("邀请切磋", "general_button_normal.png")
    
    --role head头像
    self.m_lpRoleUnderframe = CSprite :createWithSpriteFrameName( "crad_roleframe.png" )        --头像底框
    local strRole = "role_head_0" .. tostring( self.m_nPro ) .. ".jpg"
    print( "strRole ", strRole )
    self.m_lpRoleHead       = CSprite :createWithSpriteFrameName( strRole )--人物头像
    self.m_lpRoleTopframe   = CSprite :createWithSpriteFrameName( "card_roleheadframe.png" )    --头像最上面的框
    
    self.m_lpName = CCLabelTTF : create( "姓名 : " .. self.m_szName, "Marker Felt", 20 )
    self.m_lpLv = CCLabelTTF : create( "等级 : ".. tostring( self.m_nLv ), "Marker Felt", 20 )
    self.m_lpPro = CCLabelTTF :create( "职业 : " .. tostring( self.m_szProName ), "Marker Felt", 20 )

    self.m_lpBackground : setControlName( "this is CTouchPlayView, m_lpBackground, 28" )
    self.m_lpInfoBtn : setControlName( "this is CTouchPlayView, m_lpInfoBtn, 29" )
    self.m_lpFriendBtn : setControlName( "this is CTouchPlayView, m_lpFriendBtn, 30" )
    self.m_lpPMBtn : setControlName( "this is CTouchPlayView, m_lpPMBtn, 31" )
    self.m_lpPKBtn : setControlName( "this is CTouchPlayView, m_lpPKBtn, 32" )

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

    self.m_lpBackground : registerControlScriptHandler( CellCallBack, "this CTouchPlayView self.m_lpBackground 62")
    self.m_lpInfoBtn : registerControlScriptHandler( CellCallBack, "this CTouchPlayView self.m_lpInfoBtn 63")
    self.m_lpFriendBtn : registerControlScriptHandler( CellCallBack, "this CTouchPlayView self.m_lpFriendBtn 64")
    self.m_lpPMBtn : registerControlScriptHandler( CellCallBack, "this CTouchPlayView self.m_lpPMBtn 65")
    self.m_lpPKBtn : registerControlScriptHandler( CellCallBack, "this CTouchPlayView self.m_lpPKBtn 66")

    self.m_lpBackground : addChild( self.m_lpInfoBtn )
    self.m_lpBackground : addChild( self.m_lpFriendBtn )
    self.m_lpBackground : addChild( self.m_lpPMBtn )
    self.m_lpBackground : addChild( self.m_lpPKBtn )
    self.m_lpBackground : addChild( self.m_lpName )
    self.m_lpBackground : addChild( self.m_lpLv )
    self.m_lpBackground : addChild( self.m_lpPro )
    
    self.m_lpBackground : addChild( self.m_lpRoleUnderframe )
    self.m_lpRoleUnderframe : addChild( self.m_lpRoleHead )
    self.m_lpRoleUnderframe : addChild( self.m_lpRoleTopframe )

end


function CTouchPlayView.initlayout( self )
    --local backgroundSize = CCSizeMake( 415, 280 )
    
    local backgroundSize = self.m_lpBackground :getPreferredSize()
    self.m_lpBackground : setPreferredSize( backgroundSize )

    local infoBtnSize = self.m_lpInfoBtn : getPreferredSize()
    self.m_lpInfoBtn : setPosition( 0-backgroundSize.width/4, -38 )

    local friendBtnSize = self.m_lpFriendBtn : getPreferredSize()
    self.m_lpFriendBtn : setPosition( backgroundSize.width/4, -38 )

    local PMBtnSize = self.m_lpPMBtn : getPreferredSize()
    self.m_lpPMBtn : setPosition( 0-backgroundSize.width/4, -10-backgroundSize.height/3)

    local PKBtnSize = self.m_lpPKBtn : getPreferredSize()
    self.m_lpPKBtn : setPosition( backgroundSize.width/4, -10-backgroundSize.height/3)
    
    local underframeSize = self.m_lpRoleUnderframe :getPreferredSize()
    local nX = -backgroundSize.width / 2 + 12 + underframeSize.width /2
    local nY = backgroundSize.height / 2 - 5 - underframeSize.height / 2
    self.m_lpRoleUnderframe : setPosition( ccp( nX, nY ) )

    self.m_lpName : setAnchorPoint( ccp(0,0.5) )
    self.m_lpLv : setAnchorPoint( ccp(0,0.5) )
    self.m_lpPro : setAnchorPoint( ccp( 0, 0.5 ))

    local nPPP = 1.05
    local nYDistance = 20
    local nDistance = 15
    self.m_lpName : setPosition(0-backgroundSize.width/4 - infoBtnSize.width/2 + underframeSize.width * nPPP, backgroundSize.height/4 + nDistance)
    self.m_lpLv : setPosition(0-backgroundSize.width/4 - infoBtnSize.width/2 + underframeSize.width * nPPP,backgroundSize.height/4+ nDistance -nYDistance)
    self.m_lpPro : setPosition( 0-backgroundSize.width/4 - infoBtnSize.width/2 + underframeSize.width * nPPP, backgroundSize.height/4+ nDistance -2 *nYDistance)
    

end

--事件响应
function CTouchPlayView.clickCellCallBack( self, eventType, obj, x, y )
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
            self.m_lpBackground : removeFromParentAndCleanup( true )
            return true
        end
    end
end

function CTouchPlayView.clickInfo( self )
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
function CTouchPlayView.clickFriedn( self )
    require "common/protocol/auto/REQ_FRIEND_ADD"
    local msg = REQ_FRIEND_ADD()
    msg :setType( 1 )
    msg :setCount( 1 )
    msg :setDetail( { self.m_nUid } )
    _G.CNetwork : send( msg )
end
function CTouchPlayView.clickPM( self )
    local _wayCommand = CFriendOpenChatCommand( self.m_szName )
    _G.controller:sendCommand(_wayCommand)
end
function CTouchPlayView.clickPK( self )
    local comm = CStageREQCommand(_G.Protocol["REQ_WAR_PK"])
    comm : setOtherData( {uid=self.m_nUid} )
    _G.controller : sendCommand( comm )
    local timeOut = (_G.g_ServerTime : getServerTimeSeconds())+30
    local tempView = CPKWaitReceiveView(timeOut)
    local container = _G.g_Stage : getPKReceiveContainer()
    container : addChild( tempView : getShowView() )
end



