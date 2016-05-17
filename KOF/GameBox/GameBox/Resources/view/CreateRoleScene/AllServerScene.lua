--require "model/selectServer_model"
--require "controller/selectServer_command"
--require "mediator/selectServer_mediator"

--选择服务器场景
CAllServerScene = class(view,function( self )
    
end)

CAllServerScene.pageSize  = 8
CAllServerScene.pageCount = 3

CAllServerScene.FONTSIZE  = 23
CAllServerScene.SIZE_MAIN = CCSizeMake( 854,640 )
CAllServerScene.SIZE_CELL = CCSizeMake( 315,60 )
CAllServerScene.SIZE_SCO  = CCSizeMake( 525,55 )
CAllServerScene.SCO_CELL  = CCSizeMake( 155,50 )

CAllServerScene.TAG_GOIN   = 101
CAllServerScene.TAG_GOBACK = 102

function CAllServerScene.initParameter(self)

    self.nowSCOIdx = 0
    self.firstServerId = _G.g_LoginInfoProxy:getServerId()

end

function CAllServerScene.loadResources()
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
end

function CAllServerScene.createOneCell( self, _serverId, _fun )
    local server = _G.pSelectServerView:getServerById( _serverId )
    local button = CButton :createWithSpriteFrameName("","login_server_frame_normal.png")
    button : setControlName( "this CAllServerScene button 43 ")
    button : setPreferredSize( CAllServerScene.SIZE_CELL )
    button : setTag( _serverId )

    local freeName 
    if tonumber(server["status"]) == 0 or tonumber(server["status"]) == 1 then
        freeName = "login_server_gray.png"
    elseif tonumber(server["status"]) == 2 then 
        freeName = "login_server_red.png"
    else
        freeName = "login_server_green.png"
    end
    local freeImg         = CSprite :createWithSpriteFrameName(freeName)
    local serverNameLabel = CCLabelTTF:create( server.name.."("..tostring(server.count)..")", "Arial", CAllServerScene.FONTSIZE )

    local freeImgSize  = freeImg:getPreferredSize()

    serverNameLabel : setAnchorPoint( ccp( 0,0.5) ) 
    freeImg         : setPosition( ccp( -CAllServerScene.SIZE_CELL.width/2+freeImgSize.width/2+15,0 ) )
    serverNameLabel : setPosition( ccp( -CAllServerScene.SIZE_CELL.width/2+freeImgSize.width+40,0 ) )
    button : addChild( freeImg,10 )
    button : addChild( serverNameLabel,10 )

    local statusImg = nil
    if tonumber(server["status"]) == 1 then
        -- 维护
        statusImg = "login_word_wei.png"
    elseif tonumber(server["is_new"]) == 1 then
        -- 新服
        statusImg = "login_word_xin.png"
    elseif tonumber(server["status"]) == 4 or tonumber(server["is_recommend"]) == 1 then
        -- 推荐
        statusImg = "login_word_jian.png"
    end

    if statusImg ~= nil then
        local stateImg     = CSprite :createWithSpriteFrameName(statusImg)
        local stateImgSize = stateImg:getPreferredSize()
        stateImg        : setPosition( ccp( CAllServerScene.SIZE_CELL.width/2-stateImgSize.width/2-15,0 ) )
        button : addChild( stateImg,10 )
    end

    if _fun ~= nil then 
        button :registerControlScriptHandler( _fun, "this CAllServerScene button 43" )
    end

    return button
end

function CAllServerScene.initView(self,_winSize)
    
    self.m_pContainer = CContainer :create()
    self.m_pContainer : setControlName( "this is CAllServerScene self.m_pContainer 125")
    self.m_scene :addChild(self.m_pContainer)

    --背景
    self.m_pBackground = CSprite :create("loginResources/login_background_03.jpg",CCRectMake( (1136-_winSize.width)/2,0,_winSize.width,_winSize.height ))
    self.m_pBackground : setControlName( "this CAllServerScene self.m_pBackground 43 ")    
    self.m_pContainer  :addChild( self.m_pBackground , -100 )

    self:createWorldImg( self.m_pContainer, _winSize )

    self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this is CAllServerScene self.m_mainContainer 125")
    self.m_pContainer :addChild(self.m_mainContainer)

    --提示
    self.n_titleWordBg = CSprite :createWithSpriteFrameName("login_word_underframe.png")
    self.n_titleWordBg : setControlName( "this CAllServerScene self.m_selectServerWord 43 ")
    self.m_mainContainer :addChild( self.n_titleWordBg , 0 )

    self.m_selectServerWord = CSprite :createWithSpriteFrameName("login_word_xzfwq.png")
    self.m_selectServerWord : setControlName( "this CAllServerScene self.m_selectServerWord 43 ")
    self.m_mainContainer :addChild( self.m_selectServerWord , 0 )

    self.m_SCImg = CSprite :createWithSpriteFrameName("login_server_green.png")
    self.m_SCImg : setControlName( "this CAllServerScene self.m_SCImg 43 ")
    self.m_mainContainer :addChild( self.m_SCImg , 0 )

    self.m_FMImg = CSprite :createWithSpriteFrameName("login_server_red.png")
    self.m_FMImg : setControlName( "this CAllServerScene self.m_FMImg 43 ")
    self.m_mainContainer :addChild( self.m_FMImg , 0 )

    self.m_WHImg = CSprite :createWithSpriteFrameName("login_server_gray.png")
    self.m_WHImg : setControlName( "this CAllServerScene self.m_WHImg 43 ")
    self.m_mainContainer :addChild( self.m_WHImg , 0 )

    local fontSize = 23
    self.m_SCLabel = CCLabelTTF:create( "顺畅","Arial",fontSize )
    self.m_mainContainer :addChild( self.m_SCLabel , 0 )

    self.m_FMLabel = CCLabelTTF:create( "繁忙","Arial",fontSize )
    self.m_mainContainer :addChild( self.m_FMLabel , 0 )

    self.m_WHLabel = CCLabelTTF:create( "维护","Arial",fontSize )
    self.m_mainContainer :addChild( self.m_WHLabel , 0 )

    self.m_recentlyWord = CSprite :createWithSpriteFrameName("login_word_xzfwq.png")
    self.m_recentlyWord : setControlName( "this CAllServerScene self.m_recentlyWord 43 ")
    self.m_mainContainer :addChild( self.m_recentlyWord , 0 )

    -- self.recentlyBtn = self:createOneCell( _G.pSelectServerView:getRecentlyServer()["sid"] )
    -- self.m_mainContainer :addChild( self.recentlyBtn , 0 )


    local function local_ButtonCallBack( eventType,obj,x,y )
        return self:ButtonCallBack(eventType,obj,x,y)
    end

    self.m_goInBtn = CButton :createWithSpriteFrameName("进入游戏","login_button_click_02.png")
    self.m_goInBtn : setControlName( "this CAllServerScene self.m_goInBtn 43 ")
    self.m_goInBtn : registerControlScriptHandler( local_ButtonCallBack, "this CAllServerScene. self.m_moreServerBtn 43" )
    self.m_goInBtn : setTag( CAllServerScene.TAG_GOIN )
    self.m_goInBtn : setFontSize( 30 )
    self.m_goInBtn : setPreferredSize( CCSizeMake(225,70) )
    self.m_mainContainer :addChild( self.m_goInBtn , 0 )

    self.m_goBackBtn = CButton :createWithSpriteFrameName("","login_return_click.png")
    self.m_goBackBtn : setControlName( "this CAllServerScene self.m_goBackBtn 43 ")
    self.m_goBackBtn : registerControlScriptHandler( local_ButtonCallBack, "this CAllServerScene. self.m_moreServerBtn 43" )
    self.m_goBackBtn : setTag( CAllServerScene.TAG_GOBACK )
    self.m_pContainer :addChild( self.m_goBackBtn , 0 )

    --服务器信息
    self:initSerVerListView()
end

function CAllServerScene.layout(self,_winSize)
    --背景
    self.m_pBackground : setPreferredSize( CCSizeMake(_winSize.width,_winSize.height) )
    self.m_pBackground : setPosition( _winSize.width/2, _winSize.height/2)

    local mainSize = CAllServerScene.SIZE_MAIN
    self.m_mainContainer : setPosition( _winSize.width/2 - mainSize.width/2, 0)

    self.n_titleWordBg      : setPosition( mainSize.width*0.25, mainSize.height*0.89)
    self.m_selectServerWord : setPosition( mainSize.width*0.25, mainSize.height*0.89)
    self.m_SCImg : setPosition( mainSize.width*0.470, mainSize.height*0.89)
    self.m_FMImg : setPosition( mainSize.width*0.610, mainSize.height*0.89)
    self.m_WHImg : setPosition( mainSize.width*0.750, mainSize.height*0.89)

    local imgSize = self.m_SCImg:getPreferredSize()
    self.m_SCLabel : setAnchorPoint( ccp( 0,0.5 ) )
    self.m_FMLabel : setAnchorPoint( ccp( 0,0.5 ) )
    self.m_WHLabel : setAnchorPoint( ccp( 0,0.5 ) )
    self.m_SCLabel : setPosition( mainSize.width*0.475 + imgSize.width/2+5, mainSize.height*0.89)
    self.m_FMLabel : setPosition( mainSize.width*0.615 + imgSize.width/2+5, mainSize.height*0.89)
    self.m_WHLabel : setPosition( mainSize.width*0.755 + imgSize.width/2+5, mainSize.height*0.89)

    local goInBtnSize   = self.m_goInBtn:getPreferredSize()
    local goBackBtnSize = self.m_goBackBtn:getPreferredSize()
    self.m_recentlyWord : setPosition( mainSize.width*0.142, mainSize.height*0.09)

    
    self.m_goInBtn       : setPosition( mainSize.width*0.43+CAllServerScene.SIZE_CELL.width/2+goInBtnSize.width/2+40, mainSize.height*0.09)
    self.m_goBackBtn     : setPosition( _winSize.width-goBackBtnSize.width/2-15, _winSize.height-goBackBtnSize.height/2-20)


end

--创建3张循环地图
function CAllServerScene.createWorldImg( self, _container, _winSize )

    self.m_firstWorldImg = 1

    --地图
    self.m_worldImg1 = CSprite :create("loginResources/login_background_04.png")
    self.m_worldImg1 : setControlName( "this CAllServerScene self.m_worldImg1 43 ")    
    _container  :addChild( self.m_worldImg1 , -90 )

    self.m_worldImg2 = CSprite :create("loginResources/login_background_04.png")
    self.m_worldImg2 : setControlName( "this CAllServerScene self.m_worldImg2 43 ")    
    _container  :addChild( self.m_worldImg2 , -90 )

    self.m_worldImg3 = CSprite :create("loginResources/login_background_04.png")
    self.m_worldImg3 : setControlName( "this CAllServerScene self.m_worldImg2 43 ")    
    _container  :addChild( self.m_worldImg3 , -90 )

    local world1Size    = self.m_worldImg1:getPreferredSize()
    local world2Size    = self.m_worldImg2:getPreferredSize()
    local world3Size    = self.m_worldImg3:getPreferredSize()
    self.m_worldImg1    : setPosition( world1Size.width/2, _winSize.height/2)
    self.m_worldImg2    : setPosition( world1Size.width + world2Size.width/2, _winSize.height/2)
    self.m_worldImg3    : setPosition( world1Size.width + world2Size.width + world3Size.width/2, _winSize.height/2)

end

--3张地图 移动
function CAllServerScene.goWorldAction( self )

    if self.m_worldImg1 == nil or self.m_worldImg2 == nil or self.m_worldImg3 == nil then
        return
    end

    print("goWorldAction------->",self.m_firstWorldImg)

    local _winSize     = CCDirector:sharedDirector():getVisibleSize()
    local world1Size   = self.m_worldImg1 : getPreferredSize()
    local world2Size   = self.m_worldImg2 : getPreferredSize()
    local world3Size   = self.m_worldImg3 : getPreferredSize()

    local function local_moveActionCallBack()
        if self.m_firstWorldImg == 1 then
            self.m_firstWorldImg = 2

            self.m_worldImg1 : setPosition( ccp( world2Size.width + world3Size.width + world1Size.width/2, _winSize.height/2 ) )
        elseif self.m_firstWorldImg == 2 then
            self.m_firstWorldImg = 3

            self.m_worldImg2 : setPosition( ccp( world1Size.width + world3Size.width + world2Size.width/2, _winSize.height/2 ) )
        else 
            self.m_firstWorldImg = 1

            self.m_worldImg3 : setPosition( ccp( world1Size.width + world2Size.width + world3Size.width/2, _winSize.height/2 ) )
        end
        self:goWorldAction()

        print("local_moveActionCallBack------->")
    end

    local time = 75
    local pos1 
    local pos2
    local pos3

    if self.m_firstWorldImg == 1 then
        pos1 = ccp( -world1Size.width/2, _winSize.height/2 )
        pos2 = ccp( world2Size.width/2, _winSize.height/2 )
        pos3 = ccp( world2Size.width + world3Size.width/2, _winSize.height/2 )
    elseif self.m_firstWorldImg == 2 then
        pos1 = ccp( world3Size.width + world1Size.width/2, _winSize.height/2 )
        pos2 = ccp( -world2Size.width/2, _winSize.height/2 )
        pos3 = ccp( world3Size.width/2, _winSize.height/2 )
    else
        pos1 = ccp( world1Size.width/2, _winSize.height/2 )
        pos2 = ccp( world1Size.width + world2Size.width/2, _winSize.height/2 )
        pos3 = ccp( -world3Size.width/2, _winSize.height/2 )
    end

    local world_action1 = CCArray:create()
    world_action1:addObject(CCMoveTo:create( time, pos1 ))

    local world_action2 = CCArray:create()
    world_action2:addObject(CCMoveTo:create( time, pos2 ))

    local world_action3 = CCArray:create()
    world_action3:addObject(CCMoveTo:create( time, pos3 ))

    if self.m_firstWorldImg == 1 then
        world_action1:addObject(CCCallFunc:create(local_moveActionCallBack))
    elseif self.m_firstWorldImg == 2 then
        world_action2:addObject(CCCallFunc:create(local_moveActionCallBack))
    else
        world_action3:addObject(CCCallFunc:create(local_moveActionCallBack))
    end

    self.m_worldImg1 : runAction( CCSequence:create(world_action1) )
    self.m_worldImg2 : runAction( CCSequence:create(world_action2) )
    self.m_worldImg3 : runAction( CCSequence:create(world_action3) )

end

function CAllServerScene.initSerVerListView( self )

    local function local_scollViewBtnCallBack( eventType,obj,touches )
        return self:scollViewBtnCallBack( eventType,obj,touches )
    end 

    local serverList  = _G.pSelectServerView:getAllServerList()
    local totailSize  = #serverList
    local countSize   = math.ceil( totailSize/CAllServerScene.pageSize )
    local pageSize    = math.ceil( countSize/CAllServerScene.pageCount )
    local serverIndex = totailSize

    self.m_serverContainer = CContainer :create()
    self.m_serverContainer : setControlName( "this is CAllServerScene self.m_serverContainer 125")
    self.m_mainContainer :addChild(self.m_serverContainer)

    self.m_pScrollView     = CPageScrollView :create(1,CAllServerScene.SIZE_SCO)
    self.m_serverContainer : addChild( self.m_pScrollView,100 )

    local cellSize = CAllServerScene.SCO_CELL
    for i=1,pageSize do
        
        local pagContainer = CContainer :create()
        pagContainer : setControlName( "this is CAllServerScene pagContainer 125")
        self.m_pScrollView :addPage(pagContainer,false)

        local pageLayout = CHorizontalLayout:create()
        pageLayout : setCellSize( cellSize )
        pageLayout : setCellHorizontalSpace( 15 )
        pageLayout : setVerticalDirection( false)
        pageLayout : setHorizontalDirection( true )
        pageLayout : setLineNodeSum(3)
        pageLayout : setPosition( -CAllServerScene.SIZE_SCO.width*0.473,0 )
        pagContainer : addChild( pageLayout )

        for j=1,CAllServerScene.pageCount do

            if serverIndex < 1 then
                break
            end

            local btnStr = ""

            local btn = CButton :createWithSpriteFrameName( "","login_page_normal.png" )
            btn : setFontSize( 24 )
            btn : setPreferredSize( cellSize )
            btn : setTag( serverIndex )
            btn : setTouchesMode( kCCTouchesAllAtOnce )
            btn : setTouchesEnabled( true)
            btn : registerControlScriptHandler( local_scollViewBtnCallBack, "this CAllServerScene btn 117 ")

            local num = serverIndex
            -- btnStr = btnStr..serverIndex.."-"
            if serverIndex == 1 then
                btnStr = btnStr..tostring( num ).."-"
                serverIndex = serverIndex - 1
                if totailSize == 1 then
                    self :setHightLineForSCOBtn(btn)
                end
            elseif serverIndex == totailSize then
                self :setHightLineForSCOBtn(btn)
                serverIndex = serverIndex-CAllServerScene.pageSize
                if serverIndex < 0 then
                    btnStr = btnStr..tostring(1).."-"
                else
                    btnStr = btnStr..tostring(serverIndex+1).."-"
                end
                
            else
                if totailSize%CAllServerScene.pageSize == 0 then 
                    serverIndex = serverIndex-CAllServerScene.pageSize
                else
                    serverIndex = serverIndex-totailSize%CAllServerScene.pageSize
                end
                if serverIndex < 0 then
                    btnStr = btnStr..tostring(1).."-"
                else
                    btnStr = btnStr..tostring(serverIndex+1).."-"
                end
                
            end

            btnStr = btnStr..num.."区"

            btn : setText( btnStr )
            pageLayout :addChild( btn )
        end

        
    end

    local tuiJianBtn = CButton :createWithSpriteFrameName( "推荐","login_page_click.png" )
    tuiJianBtn : setFontSize( 24 )
    self.m_serverContainer :addChild( tuiJianBtn , 10 )

    local leftImg = CSprite :createWithSpriteFrameName( "login_arrow_left.png" )
    leftImg : setControlName( "this is CAllServerScene leftImg 125")
    self.m_serverContainer :addChild( leftImg , 10 )

    local rightImg = CSprite :createWithSpriteFrameName( "login_arrow_right.png" )
    rightImg : setControlName( "this is CAllServerScene rightImg 125")
    self.m_serverContainer :addChild( rightImg , 10 )

    local bgSize = CCSizeMake( 755,358 )
    local viewBg = CSprite :createWithSpriteFrameName("login_second_underframe.png")
    viewBg : setControlName( "this is CAllServerScene viewBg 125")
    viewBg : setControlName( "this CAllServerScene viewBg 43 ")
    viewBg : setPreferredSize( bgSize )
    self.m_serverContainer :addChild( viewBg , 10 )

    --定位
    local mainSize = CAllServerScene.SIZE_MAIN
    local scoSize  = CAllServerScene.SIZE_SCO
    self.m_pScrollView : setPosition( mainSize.width*0.265, mainSize.height*0.773-scoSize.height/2)
    tuiJianBtn         : setPosition( mainSize.width*0.130, mainSize.height*0.773)
    leftImg            : setPosition( mainSize.width*0.265-20, mainSize.height*0.773+1.5)
    rightImg           : setPosition( mainSize.width*0.265+scoSize.width+20, mainSize.height*0.773+1.5)
    viewBg             : setPosition( mainSize.width/2, mainSize.height*0.437)
    
    --服务器具体信息
    self:resetMainServerView(totailSize)
end

function CAllServerScene.resetMainServerView( self, _idx )

    if _idx == self.nowSCOIdx then
        return
    end

    local function local_serverBtnTouchCallBack( eventType,obj,x,y )
        return self:serverBtnTouchCallBack( eventType,obj,x,y )
    end

    if self.m_serverMainContainer ~= nil then
        self.m_serverMainContainer : removeFromParentAndCleanup( true )
        self.m_serverMainContainer = nil
    end

    self.nowSCOIdx = _idx

    self.m_serverMainContainer = CContainer :create()
    self.m_serverMainContainer : setControlName( "this is CAllServerScene self.m_serverMainContainer 125")
    self.m_serverContainer :addChild(self.m_serverMainContainer,100)

    local mainSize     = CAllServerScene.SIZE_MAIN
    local serverList   = self:get8ServerListByFirstIdx( _idx )
    local serverLayout = CHorizontalLayout:create()
    serverLayout : setCellSize( CAllServerScene.SIZE_CELL )
    serverLayout : setCellHorizontalSpace( 38 )
    serverLayout : setCellVerticalSpace( 20 )
    serverLayout : setVerticalDirection( false)
    serverLayout : setHorizontalDirection( true)
    serverLayout : setLineNodeSum(2)
    serverLayout : setColumnNodeSum(4)
    serverLayout : setPosition( mainSize.width*0.11,mainSize.height*0.625 )--
    self.m_serverMainContainer : addChild( serverLayout,10 )

    print("««««««««««««««««««««")
    for i,v in ipairs(serverList) do
        print("name="..v.name.."     sid="..v["sid"])
        local serverBtn = self:createOneCell( v["sid"], local_serverBtnTouchCallBack )
        serverLayout :addChild( serverBtn )
        if i == 1 then
            self:setHightLineForServerBtn( serverBtn )
            self:setServerId( v["sid"] )
        end
    end
    print("««««««««««««««««««««")

end

function CAllServerScene.setHightLineForSCOBtn( self, _obj )
    if self.m_heightLineSpr1 ~= nil then
        self.m_heightLineSpr1 : removeFromParentAndCleanup( true )
        self.m_heightLineSpr1 = nil
    end
    self.m_heightLineSpr1 = CSprite:createWithSpriteFrameName( "login_page_click.png" )
    self.m_heightLineSpr1 : setControlName( "this is CAllServerScene self.m_heightLineSpr1 125")
    self.m_heightLineSpr1 : setPreferredSize(CAllServerScene.SCO_CELL)
    _obj:addChild( self.m_heightLineSpr1,1 )
end

function CAllServerScene.setHightLineForServerBtn( self, _obj )
    if self.m_heightLineSpr2 ~= nil then
        self.m_heightLineSpr2 : removeFromParentAndCleanup( true )
        self.m_heightLineSpr2 = nil
    end
    self.m_heightLineSpr2 = CSprite:createWithSpriteFrameName( "login_server_frame_click.png" )
    self.m_heightLineSpr2 : setControlName( "this is CAllServerScene self.m_heightLineSpr2 125")
    self.m_heightLineSpr2 : setPreferredSize(CCSizeMake( CAllServerScene.SIZE_CELL.width+6, CAllServerScene.SIZE_CELL.height+5 ))
    _obj:addChild( self.m_heightLineSpr2,1 )
end

function CAllServerScene.get8ServerListByFirstIdx( self, _idx )

    print("get8ServerListByFirstIdx--idx=".._idx)

    local allServerList = _G.pSelectServerView:getAllServerList()
    local totailSize    = #allServerList
    local list = {}

    for i=_idx,_idx-CAllServerScene.pageSize+1,-1 do
        if allServerList[totailSize-i+1] ~= nil then

            table.insert( list,allServerList[totailSize-i+1] )
        else
            return list
        end
    end

    return list
end

function CAllServerScene.setServerId( self, _serverId )

    local serverId = tonumber( _serverId )
    _G.g_LoginInfoProxy:setServerId( serverId )

    if self.recentlyBtn ~= nil then
        self.recentlyBtn : removeFromParentAndCleanup( true )
        self.recentlyBtn = nil
    end


    local mainSize = CCSizeMake( 854,640 )
    self.recentlyBtn = self:createOneCell( _serverId )
    self.m_mainContainer :addChild( self.recentlyBtn , 0 )
    self.recentlyBtn     : setPosition( mainSize.width*0.43 , mainSize.height*0.09)

    --显示维护公告
    -- if _G.g_CServerNoticView ~= nil then
    --     return
    -- end

    -- _G.g_CServerNoticView = CServerNoticView()
    -- local serverNoticLayer = _G.g_CServerNoticView:layer( _serverId )
    -- self.m_mainContainer:addChild( serverNoticLayer )

    local server = _G.pSelectServerView:getServerById( _serverId )
    if tonumber(server["status"]) == 1 then
        self.m_goInBtn :setTouchesEnabled( false )

        --显示维护公告
        if _G.g_CServerNoticView ~= nil then
            return
        end

        _G.g_CServerNoticView = CServerNoticView()
        local serverNoticLayer = _G.g_CServerNoticView:layer( _serverId )
        self.m_mainContainer:addChild( serverNoticLayer )

    elseif tonumber(server["status"]) == 0 then
        --停服状态
        self.m_goInBtn :setTouchesEnabled( false )
    else
        self.m_goInBtn :setTouchesEnabled( true )
    end

end

function CAllServerScene.init(self, _winSize)

    self :loadResources()
    self :initParameter()
	self :initView(_winSize)
	self :layout(_winSize)
    self :goWorldAction()

end

function CAllServerScene.scene(self)
    local winSize   = CCDirector: sharedDirector():getVisibleSize()
    self.m_scene    = CCScene :create()
    self :init(winSize)
    return self.m_scene
end

function CAllServerScene.open(self, x,y)
    self.close(self,x,y)
end




function CAllServerScene.ButtonCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then
            local tag = obj:getTag()
            if tag == CAllServerScene.TAG_GOIN then 
                CCLOG("更多服务器----进入选择角色界面")
                _G.pSelectServerView:createJuHua()
                _G.pSelectServerView:requestRoleList(_G.g_LoginInfoProxy:getServerId() )
            elseif tag == CAllServerScene.TAG_GOBACK then 
                CCLOG("更多服务器----返回")
                _G.g_LoginInfoProxy:setServerId( self.firstServerId )
                CCDirector:sharedDirector():popScene()
            end
        end
    end

end



function CAllServerScene.scollViewBtnCallBack(self,eventType, obj, touches )
    if eventType == "TouchesBegan" then
        local touchesCount = touches:count()
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
        local touchesCount2 = touches:count()
        for i=1, touchesCount2 do
            local touch2 = touches :at(i - 1)
            if touch2:getID() == self.touchID and self.tagIdx == obj :getTag() then
                local touch2Point = touch2 :getLocation()
                if ccpDistance( touch2Point, touch2 :getStartLocation()) < 10 then

                    local tag = obj:getTag()
                    self:setHightLineForSCOBtn( obj )
                    self:resetMainServerView( tag )

                    self.touchID    = nil
                    self.tagIdx     = nil
                end
            end
        end
    end
end


function CAllServerScene.serverBtnTouchCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then
            local tag = obj:getTag()
            self:setHightLineForServerBtn( obj )
            self:setServerId( tag )
        end
    end

end

