
require "common/RequestMessage"
require "common/protocol/auto/REQ_ROLE_LOGIN"
require "common/Network"

require "common/protocol/auto/REQ_ROLE_CREATE"
require "proxy/LoginInfoProxy"
require "view/CreateRoleScene/CreateRoleScene"
require "mediator/SelectRoleMediator"

--setLuaCallback
CSelectRoleScene = class(view,function(self)

end)

--TAG
CSelectRoleScene.TAG_GOIN    = 101
CSelectRoleScene.TAG_CREATE  = 102
CSelectRoleScene.TAG_GOBACK  = 103
CSelectRoleScene.TAG_LEFT    = 201
CSelectRoleScene.TAG_RIGHT   = 202
CSelectRoleScene.TAG_NAME    = 999
CSelectRoleScene.TAG_FLOOR   = 666

CSelectRoleScene.PageSize  = 3

CSelectRoleScene.SIZE_MAIN = CCSizeMake( 854,640 )
CSelectRoleScene.SIZE_SCO  = CCSizeMake( 740,360 )
CSelectRoleScene.SIZE_CELL = CCSizeMake( 215,360 )

function CSelectRoleScene.initView(self, _winSize)

    self.m_pContainer     = CContainer :create()
    self.m_pContainer     : setControlName( "this is CSelectRoleScene self.m_pContainer 125")
    self.m_scene  :addChild(self.m_pContainer)

    --背景
    self.m_pBackground = CSprite :create("loginResources/login_background_03.jpg",CCRectMake( (1136-_winSize.width)/2,0,_winSize.width,_winSize.height ))
    self.m_pBackground : setControlName( "this CSelectRoleScene self.m_pBackground 43 ")    
    self.m_pContainer  :addChild( self.m_pBackground , -100 )

    local function local_btnTouchCallBack( eventType,obj,x,y )
        return self:btnTouchCallBack(eventType,obj,x,y)
    end

    self.m_goBackBtn = CButton :createWithSpriteFrameName("","login_return_click.png")
    self.m_goBackBtn : setControlName( "this CSelectRoleScene self.m_goBackBtn 43 ")
    self.m_goBackBtn : registerControlScriptHandler( local_btnTouchCallBack, "this CSelectRoleScene. self.m_moreServerBtn 43" )
    self.m_goBackBtn : setTag( CSelectRoleScene.TAG_GOBACK )
    self.m_pContainer :addChild( self.m_goBackBtn , 0 )

    self.m_mainContainer     = CContainer :create()
    self.m_mainContainer     : setControlName( "this is CSelectRoleScene self.m_mainContainer 125")
    self.m_pContainer  :addChild(self.m_mainContainer)

    self.m_goInBtn = CButton :createWithSpriteFrameName("进入游戏","login_button_click_02.png")
    self.m_goInBtn : setControlName( "this CSelectRoleScene self.m_goInBtn 43 ")
    self.m_goInBtn : registerControlScriptHandler( local_btnTouchCallBack, "this CSelectRoleScene. self.m_moreServerBtn 43" )
    self.m_goInBtn : setTag( CSelectRoleScene.TAG_GOIN )
    self.m_goInBtn : setFontSize( 30 )
    self.m_goInBtn : setPreferredSize( CCSizeMake(225,70) )
    self.m_mainContainer :addChild( self.m_goInBtn , 0 )

    self.m_createPlayerBtn = CButton :createWithSpriteFrameName("创建角色","login_button_click_02.png")
    self.m_createPlayerBtn : setControlName( "this CSelectRoleScene self.m_createPlayerBtn 43 ")
    self.m_createPlayerBtn : registerControlScriptHandler( local_btnTouchCallBack, "this CSelectRoleScene. self.m_moreServerBtn 43" )
    self.m_createPlayerBtn : setTag( CSelectRoleScene.TAG_CREATE )
    self.m_createPlayerBtn : setFontSize( 24 )
    self.m_mainContainer :addChild( self.m_createPlayerBtn , 0 )

    self:initRoleView()

    -- self:createLightActioc()
end

function CSelectRoleScene.layout(self, _winSize)

    local mainSize = CSelectRoleScene.SIZE_MAIN

    --背景
    self.m_pBackground : setPreferredSize( CCSizeMake(_winSize.width,_winSize.height) )
    self.m_pBackground : setPosition( _winSize.width/2, _winSize.height/2)
    --返回按钮
    local goBackBtnSize = self.m_goBackBtn:getPreferredSize()
    self.m_goBackBtn     : setPosition( _winSize.width-goBackBtnSize.width/2-15, _winSize.height-goBackBtnSize.height/2-20)

    --主界面
    self.m_mainContainer : setPosition( _winSize.width/2 - mainSize.width/2, 0)

    self.m_goInBtn         : setPosition( mainSize.width/2, mainSize.height*0.135)
    self.m_createPlayerBtn : setPosition( mainSize.width*0.21, mainSize.height*0.135)
end

function CSelectRoleScene.createOneRole( self,_roleInfo )

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("idle")
        end
    end

    local button = CButton:createWithSpriteFrameName("","transparent.png")
    button :setControlName( "this CSelectRoleScene button 84")
    button :setTag( _roleInfo.uid )
    button :setPreferredSize( CCSizeMake( 190,360 ) )

    local roleCCBI = CMovieClip:create( "CharacterMovieClip/1000".._roleInfo.pro.."_normal.ccbi" )
    roleCCBI :setControlName( "this CSelectRoleScene roleCCBI 84")
    roleCCBI :registerControlScriptHandler( animationCallFunc)
    roleCCBI :setTag( _roleInfo.uid )
    
    table.insert(self.m_roleCCBIList,roleCCBI)

    local lvBg    = CSprite:createWithSpriteFrameName( "login_lv_underframe.png" )
    local lvImg   = CSprite:createWithSpriteFrameName( "login_LV.png" )
    local lvLabel = CCLabelTTF:create( _roleInfo.lv,"Arial",22 )
    lvBg    : setControlName( "this is CSelectRoleScene lvBg 125")
    lvImg   : setControlName( "this is CSelectRoleScene lvImg 125")
    lvImg   : setPosition( ccp( -20,0 ) )
    lvLabel : setPosition( ccp( 10 ,0 ) )
    lvLabel : setAnchorPoint( ccp( 0,0.5 ) )

    lvBg    : addChild( lvImg , 10 )
    lvBg    : addChild( lvLabel , 10 )
    

    local nameBg    = CSprite:createWithSpriteFrameName( "login_name_underframe.png", CCRectMake( 51,0,5,43 ) )
    nameBg : setControlName( "this is CSelectRoleScene nameBg 125")
    local nameLabel = CCLabelTTF:create( _roleInfo.uname,"Arial",22 )
    nameBg :setPreferredSize( CCSizeMake( 217,43 ) )
    nameBg :addChild( nameLabel , 10, CSelectRoleScene.TAG_NAME )

    local floorImg = CSprite:createWithSpriteFrameName( "login_role_background_normal.png" )
    floorImg : setControlName( "this is CSelectRoleScene floorImg 125")

    roleCCBI : setPosition( ccp( 0,-90 ) )
    lvBg     : setPosition( ccp( 0,140 ) )
    nameBg   : setPosition( ccp( 0,-160 ) )
    floorImg : setPosition( ccp( 0,-100 ) )

    button : addChild( roleCCBI, 15 )
    button : addChild( lvBg, 10 )
    button : addChild( nameBg, 10, CSelectRoleScene.TAG_NAME )
    button : addChild( floorImg, -10, CSelectRoleScene.TAG_FLOOR )
    return button
end

function CSelectRoleScene.initRoleView( self )
    if self.m_playerList == nil then
        return
    end

    if #self.m_playerList >= 6 then
        self.m_createPlayerBtn:setTouchesEnabled( false )
    end

    local function local_roleTouchCallBack( eventType,obj,touches )
        return self:roleTouchCallBack( eventType,obj,touches )
    end

    local mainSize = CSelectRoleScene.SIZE_MAIN
    local totail   = #self.m_playerList
    local pageNum  = math.ceil( totail/CSelectRoleScene.PageSize )
    local listIdx  = 1

    self.m_roleContainer = CContainer :create()
    self.m_roleContainer : setControlName( "this is CSelectRoleScene self.m_roleContainer 125")
    self.m_mainContainer :addChild(self.m_roleContainer)

    self.m_pScrollView     = CPageScrollView :create(1,CSelectRoleScene.SIZE_SCO)
    self.m_roleContainer : addChild( self.m_pScrollView,100 )
    for i=1,pageNum do
        local pagContainer = CContainer :create()
        pagContainer : setControlName( "this is CSelectRoleScene pagContainer 125")
        self.m_pScrollView :addPage(pagContainer,false)

        local roleLayout = CHorizontalLayout:create()
        roleLayout : setCellSize( CSelectRoleScene.SIZE_CELL )
        roleLayout : setCellHorizontalSpace( 28 )
        -- roleLayout : setCellVerticalSpace( 20 )
        roleLayout : setVerticalDirection( false)
        roleLayout : setHorizontalDirection( true)
        roleLayout : setLineNodeSum(3)
        -- roleLayout : setColumnNodeSum(4)
        roleLayout : setPosition( -mainSize.width*0.414,0 )--
        pagContainer : addChild( roleLayout,10 )

        for j=1,CSelectRoleScene.PageSize do
            if self.m_playerList[listIdx] ~= nil then 
                local role = self:createOneRole( self.m_playerList[listIdx] )
                role : setTouchesMode( kCCTouchesAllAtOnce )
                role : setTouchesEnabled( true)
                role : registerControlScriptHandler( local_roleTouchCallBack, "this CSelectRoleScene role 117 ")
                roleLayout :addChild( role, 10 )

                if listIdx == 1 then 
                    self:setUid( self.m_playerList[i].uid )
                    self:setHightLineSpr( role )
                end

                listIdx = listIdx + 1
            end
        end
        
    end

    local function local_dirBtnCalkBack( eventType,obj,x,y )
        return self:btnTouchCallBack(eventType,obj,x,y)
    end

    local leftImg = CButton :createWithSpriteFrameName( "","login_arrow_left.png" )
    leftImg : setControlName( "this is CSelectRoleScene leftImg 211")
    leftImg : registerControlScriptHandler( local_dirBtnCalkBack, "this CSelectRoleScene. leftImg 211" )
    leftImg : setTag( CSelectRoleScene.TAG_LEFT )
    self.m_roleContainer :addChild( leftImg , 10 )

    local rightImg = CButton :createWithSpriteFrameName( "","login_arrow_right.png" )
    rightImg : setControlName( "this is CSelectRoleScene rightImg 217")
    rightImg : registerControlScriptHandler( local_dirBtnCalkBack, "this CSelectRoleScene. rightImg 217" )
    rightImg : setTag( CSelectRoleScene.TAG_RIGHT )
    self.m_roleContainer :addChild( rightImg , 10 )


    self.m_pScrollView : setPosition( 114/2, mainSize.height*0.24)
    leftImg  : setPosition( 114/2-22, mainSize.height*0.24+CSelectRoleScene.SIZE_SCO.height/2)
    rightImg : setPosition( 114/2+22+CSelectRoleScene.SIZE_SCO.width, mainSize.height*0.24+CSelectRoleScene.SIZE_SCO.height/2)
end

function CSelectRoleScene.createLightActioc( self )

    if self.m_lightContainer ~= nil then
        self.m_lightContainer : removeFromParentAndCleanup( true )
        self.m_lightContainer = nil
    end

    self.m_lightContainer = CContainer :create()
    self.m_lightContainer : setControlName( "this is CSelectRoleScene self.m_lightContainer 125")
    self.m_pContainer  :addChild(self.m_lightContainer)

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end
    self.m_lightActionCCBI = CMovieClip:create( "CharacterMovieClip/effects_login.ccbi" )
    self.m_lightActionCCBI : setControlName( "this CSelectServerScene self.m_lightActionCCBI 84")
    self.m_lightActionCCBI : registerControlScriptHandler( animationCallFunc)
    self.m_lightActionCCBI : setPosition( ccp( 200, 200 ) )
    self.m_lightContainer : addChild( self.m_lightActionCCBI , -50 )

    local function local_createLightActionAgain()
        return self:createLightActioc()
    end

    local function local_actionCallBack()
        self.m_lightContainer : performSelector( 3, local_createLightActionAgain )
    end

    local _actionInfo = CCArray:create()
    _actionInfo:addObject(CCMoveTo:create( 0.5, ccp( -100,200 ) ))
    _actionInfo:addObject(CCCallFunc:create(local_actionCallBack))
    self.m_lightContainer : runAction( CCSequence:create(_actionInfo) )

end

function CSelectRoleScene.removeRoleContainer( self )
    if self.m_roleContainer ~= nil then
        
        local roleCCBIList = self:getRoleCCBIList()
        
        print("CSelectRoleScene.removeRoleContainer ",#roleCCBIList)
        for i,ccbi in ipairs(roleCCBIList) do
            ccbi:removeFromParentAndCleanup( true )
        end

        if self.m_hightLineCCBI ~= nil then
            self.m_hightLineCCBI : removeFromParentAndCleanup( true )
            self.m_hightLineCCBI = nil
        end
        
        self.m_roleContainer : removeFromParentAndCleanup( true )
        self.m_roleContainer = nil
    end
end

function CSelectRoleScene.setHightLineSpr( self,_obj )
    if self.m_hightLineCCBI ~= nil then 
        print("self.m_hightLineCCBI   remove !!!")
        self.m_hightLineCCBI : removeFromParentAndCleanup( true )
        self.m_hightLineCCBI = nil
    end

    local function animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "Enter««««««««««««««««"..eventType )
            arg0 : play("run")
        end
    end
    self.m_hightLineCCBI = CMovieClip:create( "CharacterMovieClip/effects_login.ccbi" )
    self.m_hightLineCCBI : setControlName( "this CSelectServerScene self.m_hightLineCCBI 84")
    self.m_hightLineCCBI : registerControlScriptHandler( animationCallFunc)
    self.m_hightLineCCBI : setPosition( ccp( 200, 200 ) )
    self.m_hightLineCCBI : setPosition( ccp( 0,37 ) )--33
    _obj : addChild( self.m_hightLineCCBI , -50 )

    if self.m_touchRoleFloor ~= nil then
        self.m_touchRoleFloor : setVisible( true )
    end

    if _obj : getChildByTag( CSelectRoleScene.TAG_FLOOR ) ~= nil then
        self.m_touchRoleFloor = _obj : getChildByTag( CSelectRoleScene.TAG_FLOOR )
        self.m_touchRoleFloor : setVisible( false )
    end

    if self.selectRoleBtn ~= nil then
        self.selectRoleBtn : setColor( ccc4( 255,255,255,255 ) )
    end
    self.selectRoleBtn = _obj : getChildByTag( CSelectRoleScene.TAG_NAME ) : getChildByTag( CSelectRoleScene.TAG_NAME )
    self.selectRoleBtn : setColor( ccc4( 255,255,0,255 ) )

end

function CSelectRoleScene.setUid( self, _uid )

    _G.g_LoginInfoProxy:setUid( _uid )

end

function CSelectRoleScene.loadResources(self)
    print( "nnnnnnnnnnnnnnnn x CSelectRoleScene.loadResources")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("loginResources/LoginResources.plist")
end

function CSelectRoleScene.initParameter(self,_playerList)

    self.m_playerList = _playerList
    self.m_roleCCBIList = {}

    self:registMediator()
end

function CSelectRoleScene.getRoleCCBIList(self)
    return self.m_roleCCBIList
end

function CSelectRoleScene.registMediator( self )

    self:unRegistMediator()

    _G.pSelectRoleMediator = CSelectRoleMediator( self )
    controller:registerMediator(_G.pSelectRoleMediator)

end

function CSelectRoleScene.unRegistMediator( self )

    if _G.pSelectRoleMediator ~= nil then
        controller :unregisterMediator(_G.pSelectRoleMediator)
        _G.pSelectRoleMediator = nil
    end

end

function CSelectRoleScene.init(self, winSize,_playerList)
    self:loadResources()
    self:initParameter(_playerList)
    self:initView(winSize)
    self:layout(winSize)
end

function CSelectRoleScene.scene(self,_playerList) 
    local winSize = CCDirector:sharedDirector():getVisibleSize()
    self.m_scene = CCScene:create()
    self  :init(winSize,_playerList)
    return self.m_scene
end

function CSelectRoleScene.btnTouchCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then
            local tag = obj:getTag()
            if tag == CSelectRoleScene.TAG_GOIN then

                --第一次进入游戏
                _G.g_LoginInfoProxy :setFirstLogin( false )

                self : goInBtnFunCallback( obj )
            elseif tag == CSelectRoleScene.TAG_CREATE then 
                CCLOG("CSelectRoleScene----CREATE")
                _G.pSelectServerView:createJuHua()
                self:socketForCreateRoleConnectServer()
            elseif tag == CSelectRoleScene.TAG_GOBACK then 
                CCLOG("CSelectRoleScene----GOBACK")
                if _G.pSelectRoleMediator ~= nil then
                    controller :unregisterMediator(_G.pSelectRoleMediator)
                    _G.pSelectRoleMediator = nil
                    _G.pSelectRoleView = nil
                end
                CNetwork :setReconnect(false)
                CNetwork :disconnect()
                CCDirector:sharedDirector():popScene()
            elseif tag == CSelectRoleScene.TAG_LEFT then 
                CCLOG("CSelectRoleScene----TAG_LEFT")
                self:chuangePage(tag)
            elseif tag == CSelectRoleScene.TAG_RIGHT then 
                CCLOG("CSelectRoleScene----TAG_RIGHT")
                self:chuangePage(tag)
            end
        end
    end
end

function CSelectRoleScene.chuangePage( self, _dir )
    if self.m_pScrollView ~= nil then 
        local NowPgae = self.m_pScrollView:getPage()
        local count   = self.m_pScrollView:getPageCount()
        if count > 1 then
            if _dir == CSelectRoleScene.TAG_LEFT then
                if NowPgae > 0 then 
                    self.m_pScrollView:setPage(NowPgae-1,true)
                end
            else
                if NowPgae < count-1 then
                    self.m_pScrollView:setPage(NowPgae+1,true)
                end
            end
        end
    end
end

function CSelectRoleScene.socketForCreateRoleConnectServer(self)

    local serverList = _G.pSelectServerView:getAllServerList()
    for i = 1, table.maxn(serverList) do
        if(tonumber(_G.g_LoginInfoProxy:getServerId())==tonumber(serverList[i]["sid"])) then

            CNetwork :setReconnect(false)
            local ret = CNetwork :connect(serverList[i]["ip"],serverList[i]["port"])

            _G.pSelectServerView:removeJuHua()
            if(ret ~=0 )then
                _G.pCreateRoleScene = CCreateRoleScene()
                local _startupScene = _G.pCreateRoleScene :scene()
                CCDirector :sharedDirector():pushScene( _startupScene )
                CCLOG("创建玩家")
            else
                CNetwork :disconnect()
                CCLOG("无法连接服务器")
            end
            break
        end
    end
end



function CSelectRoleScene.roleTouchCallBack(self,eventType, obj, touches )
    if eventType == "TouchesBegan" then
        -- print("CSelectRoleScene  TouchesBegan   touches:count() 前")
        local touchesCount = touches:count()
        -- print("CSelectRoleScene  TouchesBegan   touches:count() 后",touchesCount)
        for i=1, touchesCount do
            local touch = touches :at( i - 1 )
            local touchPoint = touch :getLocation()
            if obj:containsPoint( obj :convertToNodeSpaceAR(ccp(touchPoint.x, touchPoint.y))) then
                self.touchID     = touch :getID()
                self.tagIdx      = obj :getTag()
                break
            end
        end
    elseif eventType == "TouchesEnded" then
        if self.touchID == nil then
           return
        end
        -- print("CSelectRoleScene  TouchesEnded   touches:count() 前")
        local touchesCount2 = touches:count()
        -- print("CSelectRoleScene  TouchesEnded   touches:count() 后")
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID and self.tagIdx == obj :getTag() then
                
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

                    local tag = obj:getTag()
                    self:setHightLineSpr( obj )
                    self:setUid( tag )
                    
                    print("选中--->"..tag)

                    self.touchID    = nil
                    self.tagIdx     = nil
                end
            end
        end
    end
end

function CSelectRoleScene.goInBtnFunCallback( self,obj )
    if #self.m_playerList == 0 then
        local msg = "请先创建角色"
        local ErrorBox  = CErrorBox()
        local BoxLayer  = ErrorBox : create(msg)
        self.m_scene : addChild( BoxLayer )
        return
    end
    CCLOG("CSelectRoleScene----GOIN")
    obj:setTouchesEnabled(false)
    _G.pSelectServerView:createJuHua()

    --锁住屏幕
    -- local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
    -- if isdis == true then
    --     CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( false)
    -- end

    --下载60级资源
    local isUpdate = false
    local uid = tonumber(_G.g_LoginInfoProxy:getUid())
    for k,v in pairs(self.m_playerList) do
        if uid == tonumber(v.uid) and tonumber(v.lv) >=60 then
            --CCTextureCache :sharedTextureCache() :removeUnusedTextures()
            --CCSpriteFrameCache :sharedSpriteFrameCache() :removeUnusedSpriteFrames()
            
            local updateScene = CGameUpdateScene : create(60)
            CCDirector:sharedDirector():pushScene( updateScene )
            isUpdate = true

            local function socketConnectSeverCallback(  )
                self : socketConnectSever()
            end
            _G.controller : setUpdateSceneFun( socketConnectSeverCallback )
        end
    end


    if isUpdate == false then
        self :socketConnectSever()
        CCLOG("进入游戏 角色ID="..tostring(_G.g_LoginInfoProxy:getUid()).." 服务器="..tostring(_G.g_LoginInfoProxy:getServerId()))
    end
end

function CSelectRoleScene.socketConnectSever(self)
    CCLOG("aaaa".. tostring(_G.g_LoginInfoProxy:getServerId()) )
    local serverList =  _G.pSelectServerView:getAllServerList()
    for k=1,#serverList do
        CCLOG(serverList[k]["ip"],serverList[k]["port"])
        if(tonumber(serverList[k]["sid"])==tonumber(_G.g_LoginInfoProxy:getServerId()))then
            CCLOG(serverList[k]["ip"],serverList[k]["port"])
            CCLOG(serverList[k]["port"])
            print("登陆---->ip="..serverList[k]["ip"],"   port="..serverList[k]["port"])
            CNetwork :setReconnect(false)
            local ret = CNetwork :connect(serverList[k]["ip"],serverList[k]["port"])
            if(ret ~=0 )then
                CCLOG("正在连接服务器。。。。。。。")
                --CCMessageBox("正在连接服务器。。。。。。。","asdf")
                self :askSocketRoleLogin()
            else
                CCLOG("服务器没有打开")
                _G.pSelectServerView : createMessageBox("无法链接服务器")
                --解锁屏幕
                _G.pSelectServerView:removeJuHua()
                -- local isdis = CCDirector :sharedDirector() :getTouchDispatcher() :isDispatchEvents()
                -- if isdis == false then
                --     CCDirector :sharedDirector() :getTouchDispatcher() :setDispatchEvents( true)
                -- end

                self.m_goInBtn:setTouchesEnabled(true)
                -- CCMessageBox("服务器没有打开 ","Error")
            end
            break
        end
    end
end

function CSelectRoleScene.askSocketRoleLogin(self)
    require "common/protocol/auto/REQ_ROLE_LOGIN"
    print("πππππππ --- ",_G.g_LoginInfoProxy:getUid(),_G.LoginInfo.uuid,_G.g_LoginInfoProxy:getServerId())
    local msg = REQ_ROLE_LOGIN()
    msg: setUid(_G.g_LoginInfoProxy:getUid())
    msg: setUuid(_G.LoginInfo.uuid)
    msg: setSid(_G.g_LoginInfoProxy:getServerId())
    msg: setCid(217)
    msg: setOs("ios")
    msg: setPwd(getStringByKey(self.m_playerList,"uid","pwd",_G.g_LoginInfoProxy:getUid()))
    msg: setVersions(1.34)
    msg: setFmc(0)
    msg: setRelink(false)
    msg: setDebug(false)
    msg: setLoginTime(getStringByKey(self.m_playerList,"uid","login_time",_G.g_LoginInfoProxy:getUid()))
    -- CNetwork :send(msg)
    local voCommand = CNetworkAsyncCommand(CNetworkAsyncCommand.ACT_CONTINUE)
    controller:sendCommand(voCommand)

    local msgID = 1010
    local ackMsgClsName = Protocol[msgID]
    print("ackMsgClsName:"..ackMsgClsName)
    local cls=_G[ackMsgClsName]
    local ackMsg = cls()
    local networkCmd = CNetworkCommand( msgID, ackMsg)
    controller:sendCommand( networkCmd )
    
    CRechargeScene:setRechargeData("username", tostring( CUserCache:sharedUserCache():getObject("userName")))
    CRechargeScene:setRechargeData("roleid", tostring(_G.g_LoginInfoProxy:getUid()))
    CRechargeScene:setRechargeData("serverid", tostring(_G.g_LoginInfoProxy:getServerId()))

    CNetwork :setReconnect(true)
end

function getStringByKey(findTable,m_key,m_needStr,m_findStr)
    for k=1, #findTable do
        if( tostring(findTable[k][m_key]) == tostring(m_findStr)) then
            return findTable[k][m_needStr]
        end
    end
end



