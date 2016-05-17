require "view/view"

CPKWaitReceiveView = class(view, function( self, _time )
    self : loadResources()
    self.m_nTime = _time
    self.winSize = CCDirector : sharedDirector() : getVisibleSize()
end)

CPKWaitReceiveView.TAG_CANCLE = 10


function CPKWaitReceiveView.loadResources( self )
    CCSpriteFrameCache : sharedSpriteFrameCache() : addSpriteFramesWithFile( "General.plist" )
end

function CPKWaitReceiveView.getShowView( self )
    self : initView()
    self : initlayout()
    self : registerEnterFrameCallBack()
    return self.m_lpBackContainer
end



function CPKWaitReceiveView.registerEnterFrameCallBack( self )
    local function onEnterFrame( _duration )
        self : updateTime()
    end

    self.m_lpBackContainer : scheduleUpdateWithPriorityLua( onEnterFrame, 0 )
end

function CPKWaitReceiveView.initView( self )

    self.m_lpBackContainer = CContainer : create()
    self.m_lpBackground = CSprite : createWithSpriteFrameName( "general_thirdly_underframe.png" )
    self.m_lpCancleBtn = CButton :createWithSpriteFrameName("取消", "general_button_normal.png")
    self.m_lpTips = CCLabelTTF : create( "提示", "Marker Felt", 20 )
    self.m_lpString = CCLabelTTF : create( "您正在邀请对战,等待对方响应", "Marker Felt", 20 )
    self.m_lpTimeString = CCLabelTTF : create( "", "Marker Felt", 20 )

    self.m_lpBackground : setControlName( "this is CPKWaitReceiveView, m_lpBackground, 23" )
    self.m_lpCancleBtn : setControlName( "this is CPKWaitReceiveView, m_lpCancleBtn, 24" )

    self.m_lpBackContainer : setFullScreenTouchEnabled(true)
    self.m_lpBackContainer :setTouchesPriority( -20001 )
    self.m_lpCancleBtn : setTouchesPriority( -20002 )

    self.m_lpBackContainer : setTouchesEnabled( true )
    self.m_lpCancleBtn : setTouchesEnabled( true )
    self.m_lpCancleBtn : setTag( self.TAG_CANCLE )

    local function CellCallBack( eventType, obj, x, y)
       return self : clickCellCallBack( eventType, obj, x, y)
    end
    self.m_lpCancleBtn : registerControlScriptHandler( CellCallBack, "this CPKWaitReceiveView self.m_lpCancleBtn 36")

    self.m_lpBackContainer : addChild( self.m_lpBackground )
    self.m_lpBackground : addChild( self.m_lpCancleBtn )
    self.m_lpBackground : addChild( self.m_lpTips )
    self.m_lpBackground : addChild( self.m_lpString )
    self.m_lpBackground : addChild( self.m_lpTimeString )
end

function CPKWaitReceiveView.initlayout( self )
    local backgroundSize = CCSizeMake( 415, 280 )
    self.m_lpBackground : setPreferredSize( backgroundSize )
    self.m_lpBackground : setPosition( self.winSize.width/2, self.winSize.height /2 )

    local cancelBtnSize = self.m_lpCancleBtn : getPreferredSize()
    self.m_lpCancleBtn : setPosition( 0, 0-backgroundSize.height/4)

    self.m_lpTips : setPosition( 0, backgroundSize.height/5*2  )
    self.m_lpString : setPosition( 0, backgroundSize.height/4 )
    self.m_lpTimeString : setPosition( 0, 0 )
end

function CPKWaitReceiveView.updateTime( self )
    local now = _G.g_ServerTime : getServerTimeSeconds()
    local time = self.m_nTime - now
    time = time < 0 and 0 or time
    self.m_lpTimeString : setString( tostring(time) )
    if time <= 0 then
        self.m_lpBackContainer : removeFromParentAndCleanup( true )
    end
end

function CPKWaitReceiveView.clickCellCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            if obj : getTag() == self.TAG_CANCLE then
                self : clickCancel()
            end
            self.m_lpBackContainer : removeFromParentAndCleanup( true )
            return true
        end
    end
end

function CPKWaitReceiveView.clickCancel( self )
    local comm = CStageREQCommand(_G.Protocol["REQ_WAR_PK_CANCEL"])
    _G.controller : sendCommand( comm )

end