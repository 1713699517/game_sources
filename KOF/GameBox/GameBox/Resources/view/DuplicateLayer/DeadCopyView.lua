require "view/view"

CDeadCopyView = class( view, function ( self )
    CCLOG("副本死亡界面被实例化")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")

    self.m_backgroundMain = nil --底图 400*380
    self.m_showUp = nil --上底图 340*120
    self.m_showDown = nil --下底图 340*120
    self.m_exitButton = nil --退出按钮
    self.m_reviveButton = nil --复活按钮
end)

CDeadCopyView.FONT_NAME = "Marker Felt"
CDeadCopyView.FONT_SIZE24 = 24
CDeadCopyView.FONT_SIZE48 = 48
CDeadCopyView.BUTTON_EXIT = 100
CDeadCopyView.BUTTON_REVIVE = 200



function CDeadCopyView.container( self, _rmb )
    self.m_lpContainer = CContainer :create() -- 总层
    self.m_rmb = _rmb

    self.m_lpContainer : setControlName( "this is CDeadCopyView self.m_lpContainer 25")
    self : initView()
    self : layoutView()

    return self.m_lpContainer
end
function CDeadCopyView.scene( self )
    self.m_lpContainer = CCScene :create() -- 总层
    self : initView()
    self : layoutView()

    return self.m_lpContainer
end

--初始化 成员
function CDeadCopyView.initView( self )
    local function CellCallBack( eventType, obj, x, y)
       return self : clickCellCallBack( eventType, obj, x, y)
    end
    --底图
    self.m_backgroundMain  = CSprite :createWithSpriteFrameName( "general_main_underframe.png")
    self.m_showUp = CSprite :createWithSpriteFrameName( "general_second_underframe.png")
    self.m_showDown = CSprite :createWithSpriteFrameName( "general_second_underframe.png")
    self.m_backgroundMain : setControlName( "this CDeadCopyView self.m_backgroundMain 48 ")
    self.m_showUp : setControlName( "this CDeadCopyView self.m_showUp 49 ")
    self.m_showDown : setControlName( "this CDeadCopyView self.m_showDown 50 ")
    self.m_backgroundMain : addChild( self.m_showUp )
    self.m_backgroundMain : addChild( self.m_showDown )

    --退出按钮
    self.m_exitButton = CButton :createWithSpriteFrameName( "确定", "general_four_button_normal.png")
    self.m_exitButton : setControlName( "this CDeadCopyView self.m_exitButton 53 " )
    self.m_exitButton : setTag( self.BUTTON_EXIT )
    self.m_exitButton : registerControlScriptHandler( CellCallBack, "this CDeadCopyView self.m_exitButton 58")
    self.m_exitButton : setFullScreenTouchEnabled( true )
    self.m_exitButton : setTouchesPriority( -100 )
    self.m_exitButton : setTouchesEnabled( true )
    self.m_backgroundMain : addChild( self.m_exitButton )

    if self.m_rmb ~= nil then
    --复活按钮
        self.m_reviveButton = CButton :createWithSpriteFrameName( "复活", "general_four_button_normal.png")
        self.m_reviveButton : setControlName( "this CDeadCopyView self.m_reviveButton 63 " )
        self.m_reviveButton : setTag( self.BUTTON_REVIVE )
        self.m_reviveButton : registerControlScriptHandler( CellCallBack, "this CDeadCopyView self.m_reviveButton 68")
        -- self.m_reviveButton : setFullScreenTouchEnabled( true )
        self.m_reviveButton : setTouchesPriority( -100 )
        self.m_reviveButton : setTouchesEnabled( true )
        self.m_backgroundMain : addChild( self.m_reviveButton )
    end

    --死亡提示
    self.m_upGoodsStr = CCLabelTTF : create( "[屌丝]你已经死了,快退出副本!!!" , self.FONT_NAME , self.FONT_SIZE24 )
    self.m_backgroundMain : addChild( self.m_upGoodsStr )

    self.m_lpContainer : addChild( self.m_backgroundMain )
end

--布局
function CDeadCopyView.layoutView( self )
    local winSize = CCDirector      : sharedDirector() :getVisibleSize()
    --主底图位置 和大小
    local mainGroundSize = CCSizeMake( 400, 380 )
    self.m_backgroundMain           : setPreferredSize( mainGroundSize )
    self.m_backgroundMain           : setPosition(  winSize.width/2, winSize.height/2 )

    local showUpDowmSize = CCSizeMake( 340, 120 )
    self.m_showUp : setPreferredSize( showUpDowmSize )
    self.m_showDown : setPreferredSize( showUpDowmSize )

    local buttonSize = self.m_exitButton : getPreferredSize()
    if self.m_rmb ~= nil then
    --复活按钮
        self.m_reviveButton : setPosition( 0 - buttonSize.width / 2,0 - mainGroundSize.width/3 )
    end
    --退出按钮
    self.m_exitButton : setPosition(  buttonSize.width / 2, 0 -  mainGroundSize.width/3 )
end

--事件响应
function CDeadCopyView.clickCellCallBack( self, eventType, obj, x, y )
    if eventType == "TouchBegan" then
        return true
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR( ccp( x, y ) ) ) then
            print(" obj : getTag()", obj : getTag() )
            if obj : getTag() == self.BUTTON_EXIT then
                self : clickOkButton()
            elseif obj : getTag() == self.BUTTON_REVIVE then
                self : clickRelive()
            end
        end
    end
end

--{退出副本}
function CDeadCopyView.clickOkButton( self )
    _G.g_Stage : exitCopy()
end

--{请求复活}
function CDeadCopyView.clickRelive( self )
    local comm = CStageREQCommand(_G.Protocol["REQ_SCENE_RELIVE_REQUEST"])
    _G.controller : sendCommand( comm )
end


















