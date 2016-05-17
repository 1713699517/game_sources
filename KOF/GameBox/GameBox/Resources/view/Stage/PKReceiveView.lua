require "view/view"

CPKReceiveView = class(view, function( self, _uid, _name,  _time )
    self.m_szName = _name or ""
    self.m_nUid = _uid
    self.m_nTime = _time
    self.winSize = CCDirector : sharedDirector() : getVisibleSize()
    self : loadResources()
end)

CPKReceiveView.TAG_CANCLE = 10
CPKReceiveView.TAG_OK = 20


function CPKReceiveView.getShowView( self )
    self : initView()
    self : initlayout()
    self : registerEnterFrameCallBack()

    return self.m_lpBackContainer
end

function CPKReceiveView.registerEnterFrameCallBack( self )
    local function onEnterFrame( _duration )
        self : updateTime()
    end

    self.m_lpBackContainer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CPKReceiveView.loadResources( self )
    CCSpriteFrameCache : sharedSpriteFrameCache() : addSpriteFramesWithFile( "General.plist" )
end

function CPKReceiveView.initView( self )
    self.m_lpBackContainer = CContainer : create()
    self.m_lpBackground = CSprite : createWithSpriteFrameName( "general_thirdly_underframe.png" )
    self.m_lpOKBtn = CButton :createWithSpriteFrameName("接受", "general_button_normal.png")
    self.m_lpCancleBtn = CButton :createWithSpriteFrameName("取消", "general_button_normal.png")
    self.m_lpTips = CCLabelTTF : create( "提示", "Marker Felt", 20 )
    self.m_lpString = CCLabelTTF : create( "是否接收玩家:[ "..self.m_szName.." ]的挑战", "Marker Felt", 20 )
    self.m_lpTimeString = CCLabelTTF : create( "", "Marker Felt", 20 )

    self.m_lpBackground : setControlName( "this is CPKReceiveView, m_lpBackground, 28" )
    self.m_lpOKBtn : setControlName( "this is CPKReceiveView, m_lpOKBtn, 29" )
    self.m_lpCancleBtn : setControlName( "this is CPKReceiveView, m_lpCancleBtn, 30" )


    self.m_lpBackContainer : setFullScreenTouchEnabled(true)
    self.m_lpBackContainer :setTouchesPriority( -20001 )
    self.m_lpOKBtn : setTouchesPriority( -20002 )
    self.m_lpCancleBtn : setTouchesPriority( -20002 )


    self.m_lpBackContainer : setTouchesEnabled( true )
    self.m_lpOKBtn : setTouchesEnabled( true )
    self.m_lpCancleBtn : setTouchesEnabled( true )

    self.m_lpOKBtn : setTag( self.TAG_OK )
    self.m_lpCancleBtn : setTag( self.TAG_CANCLE )


    local function CellCallBack( eventType, obj, x, y)
       return self : clickCellCallBack( eventType, obj, x, y)
    end
    self.m_lpOKBtn : registerControlScriptHandler( CellCallBack, "this CPKReceiveView self.m_lpOKBtn 43")
    self.m_lpCancleBtn : registerControlScriptHandler( CellCallBack, "this CPKReceiveView self.m_lpCancleBtn 44")

    self.m_lpBackContainer : addChild( self.m_lpBackground )
    self.m_lpBackground : addChild( self.m_lpOKBtn )
    self.m_lpBackground : addChild( self.m_lpCancleBtn )
    self.m_lpBackground : addChild( self.m_lpTips )
    self.m_lpBackground : addChild( self.m_lpString )
    self.m_lpBackground : addChild( self.m_lpTimeString )

end

function CPKReceiveView.initlayout( self )

    local backgroundSize = CCSizeMake( 415, 280 )
    self.m_lpBackground : setPreferredSize( backgroundSize )
    self.m_lpBackground : setPosition( self.winSize.width/2, self.winSize.height /2 )

    local cancelBtnSize = self.m_lpCancleBtn : getPreferredSize()
    self.m_lpCancleBtn : setPosition( 0-backgroundSize.width/4, 0-backgroundSize.height/4)

    local oKBtnSize = self.m_lpOKBtn : getPreferredSize()
    self.m_lpOKBtn : setPosition( backgroundSize.width/4, 0-backgroundSize.height/4)

    self.m_lpTips : setPosition( 0, backgroundSize.height/5*2  )
    self.m_lpString : setPosition( 0, backgroundSize.height/4 )
    self.m_lpTimeString : setPosition( 0, 0 )
end

function CPKReceiveView.updateTime( self )
    local now = _G.g_ServerTime : getServerTimeSeconds()
    local time = self.m_nTime - now
    time = time < 0 and 0 or time
    self.m_lpTimeString : setString( tostring(time) )
    if time <= 0 then
        self.m_lpBackContainer : removeFromParentAndCleanup( true )
    end
end

function CPKReceiveView.clickCellCallBack( self,eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            if obj : getTag() == self.TAG_CANCLE then
                self : clickCancel()
            elseif obj : getTag() == self.TAG_OK then
                self : clickOK()
            end
            self.m_lpBackContainer : removeFromParentAndCleanup( true )
            return true
        end
    end
end

function CPKReceiveView.clickOK( self )
    local comm = CStageREQCommand(_G.Protocol["REQ_WAR_PK_REPLY"])
    comm : setOtherData( {uid =self.m_nUid, res = 1 })
    _G.controller : sendCommand( comm )
end
function CPKReceiveView.clickCancel( self )
    local comm = CStageREQCommand(_G.Protocol["REQ_WAR_PK_REPLY"])
    comm : setOtherData( {uid =self.m_nUid, res = 0 })
    _G.controller : sendCommand( comm )
end