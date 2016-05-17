
require "view/view"
require "view/CreateRoleScene/AllServerScene"
require "view/CreateRoleScene/SelectRoleScene"
require "view/CreateRoleScene/ServerNoticView"



--选择服务器场景
CSelectServerScene = class(view,function( self )
end)

CSelectServerScene.TAG_MORSERVER = 101
CSelectServerScene.TAG_GOIN      = 102
CSelectServerScene.TAG_GOBACK    = 103
CSelectServerScene.TAG_USER      = 104

function CSelectServerScene.initParameter(self)
    self.m_pSeverList        = nil
    self.m_pHistoryServers   = nil
    self.m_pRecommendServers = nil

    self.m_bIsInit       = false
    self.m_goMoreServer  = true
end

function CSelectServerScene.loadResources(self)
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("General.plist")
    CCSpriteFrameCache :sharedSpriteFrameCache() :addSpriteFramesWithFile("loginResources/LoginResources.plist")
end

function CSelectServerScene.unloadResources(self)

    --删除CCBI
    if self.m_logoImgCCBI ~= nil then
        self.m_logoImgCCBI : removeFromParentAndCleanup( true )
        self.m_logoImgCCBI = nil
    end

    CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromFile("loginResources/LoginResources.plist")
    CCTextureCache :sharedTextureCache():removeTextureForKey("loginResources/LoginResources.pvr.ccz")


    for i=1,3 do
        local r = CCTextureCache :sharedTextureCache():textureForKey("loginResources/login_background_0"..tostring(i)..".jpg")
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
    end

    local r = CCTextureCache :sharedTextureCache():textureForKey("loginResources/login_background_04.png")
    if r ~= nil then
        CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
        CCTextureCache :sharedTextureCache():removeTexture(r)
        r = nil
    end

    for i=1,4 do
        local r = CCTextureCache :sharedTextureCache():textureForKey("loginResources/login_big_player"..tostring(i)..".png")
        if r ~= nil then
            CCSpriteFrameCache :sharedSpriteFrameCache():removeSpriteFramesFromTexture(r)
            CCTextureCache :sharedTextureCache():removeTexture(r)
            r = nil
        end
    end
    
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
    CCTextureCache :sharedTextureCache() : dumpCachedTextureInfo()
end

function CSelectServerScene.initView(self,_winSize)


    self.m_pContainer     = CContainer :create()
    self.m_pContainer     : setControlName( "this is CSelectServerScene self.m_pContainer 125")
    self.m_scene  :addChild(self.m_pContainer)

    --背景
    self.m_pBackground = CSprite :create("loginResources/login_background_03.jpg",CCRectMake( (1136-_winSize.width)/2,0,_winSize.width,_winSize.height ))
    self.m_pBackground : setControlName( "this CSelectServerScene self.m_pBackground 43 ")    
    self.m_pContainer  :addChild( self.m_pBackground , -100 )

    self:createWorldImg(self.m_pContainer,_winSize)

--------------------------------------------------------------------------------------
------ logo CCBI   START  
--------------------------------------------------------------------------------------
    -- 显示选择服务器 等 主界面
    local function local_mainContianerVisity()
        if self.m_mainContainer ~= nil then
            self.m_mainContainer : setVisible( true )
        end
    end

    -- logo CCBI 移动完成
    local function local_moveActionCallBack()
        self.m_pContainer : performSelector( 0.5, local_mainContianerVisity )
    end

    -- logo CCBI 事件 (移动的时候)
    local function local_moveCCBICallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "local_moveCCBICallFunc  "..eventType )
            arg0 : play("run")
        end
    end

    -- logo CCBI 移动CCBI
    local function local_moveAction()
        if self.m_logoImgCCBI ~= nil then

            --删除原先的CCBI
            -- self.m_logoImgCCBI : removeFromParentAndCleanup( true )
            -- self.m_logoImgCCBI = nil

            --创建新的CCBI
            -- self.m_logoImgCCBI = CMovieClip:create( "CharacterMovieClip/effects_logo_1.ccbi" )
            -- self.m_logoImgCCBI : setControlName( "this CSelectServerScene self.m_logoImgCCBI 84")
            -- self.m_logoImgCCBI : registerControlScriptHandler( local_moveCCBICallFunc )
            -- self.m_logoImgCCBI : setPosition( _winSize.width*0.5, _winSize.height*0.5)
            -- self.m_pContainer : addChild( self.m_logoImgCCBI , -50 )

            --移动CCBI
            local _actionInfo = CCArray:create()
            _actionInfo:addObject(CCMoveTo:create( 0.5, ccp( _winSize.width*0.5,_winSize.height*0.75 ) ))
            _actionInfo:addObject(CCCallFunc:create(local_moveActionCallBack))
            self.m_logoImgCCBI : runAction( CCSequence:create(_actionInfo) )
        end
    end

    -- logo CCBI 事件 (不动的时候)
    local function local_animationCallFunc( eventType, arg0, arg1, arg2, arg3 )
        if eventType == "Enter" then
            print( "local_animationCallFunc  "..eventType )
            if self.m_bIsInit == false then
                arg0 : play("run")
            end
        elseif eventType == "AnimationComplete" then
            --移动CCBI
            return local_moveAction()
        end
    end

    -- 创建logo CCBI
    local function local_createLogoCCBI()
        self.m_logoImgCCBI = CMovieClip:create( "CharacterMovieClip/effects_logo.ccbi" )
        self.m_logoImgCCBI : setControlName( "this CSelectServerScene self.m_logoImgCCBI 84")
        self.m_logoImgCCBI : registerControlScriptHandler( local_animationCallFunc )
        self.m_logoImgCCBI : setPosition( _winSize.width*0.5, _winSize.height*0.5)
        self.m_pContainer : addChild( self.m_logoImgCCBI , -50 )
    end
    -- 延迟
    self.m_pContainer : performSelector( 0.8, local_createLogoCCBI )
--------------------------------------------------------------------------------------






    local function local_ButtonCallBack( eventType,obj,x,y )
        --CCLOG("aaaaaaaaa--->  ".. eventType .." "..tostring(self.ButtonCallBack)..":"..tostring(CSelectServerScene.ButtonCallBack))
        return self:ButtonCallBack(eventType,obj,x,y)
    end

    local function local_ServerButtonCallBack( eventType,obj,x,y )
        --CCLOG("bbbbbbbbb--->  ".. eventType .." "..tostring(self.ServerButtonCallBack)..":"..tostring(CSelectServerScene.ServerButtonCallBack))
        return self:ServerButtonCallBack(eventType,obj,x,y)
    end

    self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setVisible( false )
    self.m_mainContainer : setControlName( "this is CSelectServerScene self.m_mainContainer 125")
    self.m_pContainer : addChild(self.m_mainContainer)

    --登陆信息
    self.m_serverNoticLabels = {}
    self.m_serverButtonList  = {}
    self.m_serverList = {}
    for i=1,1 do
        self.m_serverList[i] = {}
        self.m_serverList[i].idx = i
        self.m_serverList[i].serverId = 0
        local imgName = "login_word_xzfwq.png"
        if i == 2 then 
            imgName = "login_word_zjdl.png"
        end
        self.m_serverNoticLabels[i] = CSprite :createWithSpriteFrameName(imgName)
        self.m_serverNoticLabels[i] : setControlName( "this CSelectServerScene self.m_serverNoticLabels[i] 43 ")
        self.m_mainContainer :addChild( self.m_serverNoticLabels[i] , 0 )

        self.m_serverButtonList[i] = CButton :createWithSpriteFrameName("","login_input_underframe.png")
        self.m_serverButtonList[i] : setControlName( "this CSelectServerScene self.m_serverButtonList[i] 43 ")
        self.m_serverButtonList[i] : setTag( 0 )
        self.m_serverButtonList[i] : registerControlScriptHandler( local_ServerButtonCallBack, "this CSelectServerScene. self.m_serverButtonList[i] 43" )
        self.m_serverButtonList[i] : setFontSize( 30 )
        self.m_serverButtonList[i] : setPreferredSize( CCSizeMake(325,72) )
        self.m_mainContainer :addChild( self.m_serverButtonList[i] , 0 )
    end
    self.m_moreServerBtn = CButton :createWithSpriteFrameName("","login_server_change_normal.png")
    self.m_moreServerBtn : setControlName( "this CSelectServerScene self.m_moreServerBtn 43 ")
    self.m_moreServerBtn : setTag( CSelectServerScene.TAG_MORSERVER )
    self.m_moreServerBtn : registerControlScriptHandler( local_ButtonCallBack, "this CSelectServerScene. self.m_moreServerBtn 43" )
    self.m_moreServerBtn : setTouchesEnabled( false )
    self.m_mainContainer :addChild( self.m_moreServerBtn , 0 )

    self.m_goInBtn = CButton :createWithSpriteFrameName("进入游戏","login_button_click_02.png")
    self.m_goInBtn : setControlName( "this CSelectServerScene self.m_goInBtn 43 ")
    self.m_goInBtn : registerControlScriptHandler( local_ButtonCallBack, "this CSelectServerScene. self.m_moreServerBtn 43" )
    self.m_goInBtn : setTag( CSelectServerScene.TAG_GOIN )
    self.m_goInBtn : setFontSize( 30 )
    self.m_goInBtn : setPreferredSize( CCSizeMake(225,70) )
    self.m_goInBtn : setTouchesEnabled( false )
    self.m_mainContainer :addChild( self.m_goInBtn , 0 )

    if LUA_AGENT() == 12 then
        self.m_userBtn = CButton :createWithSpriteFrameName("账号管理","login_button_click_02.png")
        self.m_userBtn : setControlName( "this CSelectServerScene self.m_userBtn 43 ")
        self.m_userBtn : registerControlScriptHandler( local_ButtonCallBack, "this CSelectServerScene. self.m_moreServerBtn 43" )
        self.m_userBtn : setTag( CSelectServerScene.TAG_USER )
        self.m_userBtn : setFontSize( 30 )
        self.m_userBtn : setPreferredSize( CCSizeMake(225,70) )
        self.m_mainContainer :addChild( self.m_userBtn , 0 )
    end

end

function CSelectServerScene.layout(self,_winSize)

    self.m_pBackground : setPreferredSize( CCSizeMake(_winSize.width,_winSize.height) )

    self.m_pBackground  : setPosition( _winSize.width/2, _winSize.height/2)

    local serverBtnSize     = self.m_serverButtonList[1]:getPreferredSize()
    local wordImg1Size      = self.m_serverNoticLabels[1]:getPreferredSize()
    local moreServerBtnSize = self.m_moreServerBtn:getPreferredSize()
    self.m_serverNoticLabels[1] : setPosition( _winSize.width*0.5-serverBtnSize.width/2-wordImg1Size.width/2-12, _winSize.height*0.47)
    self.m_serverButtonList[1]  : setPosition( _winSize.width*0.5, _winSize.height*0.47)

    self.m_moreServerBtn : setPosition( _winSize.width*0.5+serverBtnSize.width/2+moreServerBtnSize.width/2+12, _winSize.height*0.47)
    self.m_goInBtn       : setPosition( _winSize.width*0.5, _winSize.height*0.31)

    if LUA_AGENT() == 12 then
        self.m_userBtn       : setPosition( _winSize.width*0.5, _winSize.height*0.17)
    end
end

--创建3张循环地图
function CSelectServerScene.createWorldImg( self, _container, _winSize )

    self.m_firstWorldImg = 1

    --地图
    self.m_worldImg1 = CSprite :create("loginResources/login_background_04.png")
    self.m_worldImg1 : setControlName( "this CSelectServerScene self.m_worldImg1 43 ")    
    _container  :addChild( self.m_worldImg1 , -90 )

    self.m_worldImg2 = CSprite :create("loginResources/login_background_04.png")
    self.m_worldImg2 : setControlName( "this CSelectServerScene self.m_worldImg2 43 ")    
    _container  :addChild( self.m_worldImg2 , -90 )

    self.m_worldImg3 = CSprite :create("loginResources/login_background_04.png")
    self.m_worldImg3 : setControlName( "this CSelectServerScene self.m_worldImg2 43 ")    
    _container  :addChild( self.m_worldImg3 , -90 )

    local world1Size    = self.m_worldImg1:getPreferredSize()
    local world2Size    = self.m_worldImg2:getPreferredSize()
    local world3Size    = self.m_worldImg3:getPreferredSize()
    self.m_worldImg1    : setPosition( world1Size.width/2, _winSize.height/2)
    self.m_worldImg2    : setPosition( world1Size.width + world2Size.width/2, _winSize.height/2)
    self.m_worldImg3    : setPosition( world1Size.width + world2Size.width + world3Size.width/2, _winSize.height/2)

end

--3张地图 移动
function CSelectServerScene.goWorldAction( self )

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

function CSelectServerScene.init(self, _winSize)

    self:loadResources()
	
    self :initParameter()

	self :initView(_winSize)

	self :layout(_winSize)

    self :goWorldAction()

    SimpleAudioEngine:sharedEngine():playBackgroundMusic("Sound@mp3/begin.mp3", true)
end


function CSelectServerScene.scene(self)
    local winSize   = CCDirector: sharedDirector():getVisibleSize()
    self.m_scene    = CCScene :create()
    self:init(winSize)
    return self.m_scene
end


--创建菊花  -- 记得要自己删除
function CSelectServerScene.createJuHua( self )
    
    self:removeJuHua()

    local function local_JuHuaCallBack( eventType, obj, x, y )
        if eventType == "Exit" then
            print("juhua-juhua-juhua      unlock")
            CCDirector : sharedDirector () : getTouchDispatcher() : setDispatchEvents(true)
        end
    end

    local director = CCDirector :sharedDirector()
    local winSize  = director : getWinSize()
    local nowScene = CCDirector : sharedDirector() : getRunningScene()

    self.m_JuHua_Action = CSprite : create( "loading.png" )
    local action = CCRotateBy:create(2/4, 90)
    local foreverAction = CCRepeatForever : create( action )
    self.m_JuHua_Action : setPosition(winSize.width/2,winSize.height/2)
    self.m_JuHua_Action : registerControlScriptHandler( local_JuHuaCallBack, "this is CSelectServerScene self.m_JuHua_Action 378" )
    self.m_JuHua_Action : runAction( foreverAction )
    nowScene : addChild( self.m_JuHua_Action, 1000 )

    print("juhua-juhua-juhua      lock")
    CCDirector : sharedDirector () : getTouchDispatcher() : setDispatchEvents(false)
end

--删除菊花 
function CSelectServerScene.removeJuHua( self )
    if self.m_JuHua_Action ~= nil then
        self.m_JuHua_Action : removeFromParentAndCleanup()
        self.m_JuHua_Action = nil
    end
end


function CSelectServerScene.ButtonCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then
            local tag = obj:getTag()
            if tag == CSelectServerScene.TAG_MORSERVER then
                CCLOG("登陆界面----进入更多服务器选择")
                self:createJuHua()
                self.m_goMoreServer = true
                self:getServerList()
            elseif tag == CSelectServerScene.TAG_GOIN then 
                CCLOG("登陆界面----进入角色选择")
                self:createJuHua()
                obj:setTouchesEnabled( false )
                self:requestRoleList( _G.g_LoginInfoProxy:getServerId() )
            elseif tag == CSelectServerScene.TAG_GOBACK then
                CCLOG("登陆界面----返回")
            elseif tag == CSelectServerScene.TAG_USER then
                CCLOG("baidu --- user")
                LUA_EXECUTE_COMMAND(12)
            end
        end
    end

end

function CSelectServerScene.ServerButtonCallBack(self,eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) )
    elseif eventType == "TouchEnded" then
        if obj:containsPoint( obj:convertToNodeSpaceAR(ccp(x,y)) ) then
            local tag = obj:getTag()
            if tag == 0 then
                CCLOG("没有服务器")
                return
            end
            self:setServerId( tag )
        end
    end

end

function CSelectServerScene.goMroeServerScene( self )
    _G.pAllServerScene = CAllServerScene()
    local _startupScene = _G.pAllServerScene :scene()
    CCDirector :sharedDirector():pushScene( _startupScene )
end


function parseJSonObjects(_str)
    CCLOG("parseJsonStart")
    local ret = {}
    local a1 = string.find(_str, "%[")
    local a2 = string.find(_str, "%]")
    local i = 0
    if a1 ~= nil and a2 ~= nil then
        i = 1
    end
    local pos = 1--string.find(_str, "{", a1)
    local endpos = 1--string.find(_str, "}",pos)
    while pos ~= nil do
        pos = string.find(_str,"{", pos)
        endpos = string.find(_str,"}", pos)
        if pos == nil then
            break
        end
        if pos ~= nil and endpos ~= nil then
            ret[i] = {}
            local sstr = string.sub( _str, pos+1, endpos-1 )
            
            --循环读取各种字段加至table
            for k,v in string.gmatch(sstr, '"([%a_]+)"%s*:%s*"?([^,%s"]+)"?') do
                ret[i][k] = v
            end
            i = i + 1
        end
        pos = endpos + 1
    end
    CCLOG("parseJsonEnd")
    --CCLOG("a1"..tostring(a1).." a2"..tostring(a2))
    return ret
end

--获取服务器列表
function CSelectServerScene.getServerList(self)
    local function serverListCallback(response)
        self:onServerListCallback(response)
    end
    -- local getServerListRequest = CCHttpRequest()
    _G.pDateTime:reset()
    local timeLong = _G.pDateTime:getTotalSeconds()
    local sessionId = "";  -- by:yiping 

    local strTemp = "cid=".._G.LoginConstant.CID.."&uuid="..tostring(_G.LoginInfo.uuid).."&session="..sessionId.."&time="..tostring(timeLong)
    local strTempWithKey = strTemp.."&key=".._G.LoginConstant.KEY
    CCLOG("SERVERLIS1 == "..strTempWithKey)
    local strMD5 = CMD5Crypto:md5( strTempWithKey, string.len(strTempWithKey) )

    local strUrl = _G.netWorkUrl .. "/api/Phone/ServList?"..tostring(strTemp).."&sign="..tostring(strMD5)
    -- CCLOG("SERVERLIS3 == "..strUrl)
    -- getServerListRequest : setUrl( strUrl )

    -- getServerListRequest : setRequestType(0)
    -- getServerListRequest : setLuaCallback( serverListCallback )
    --CCHttpClient:getInstance():setTimeoutForConnect(5.0)
    --CCHttpClient:getInstance():setTimeoutForRead(5.0)
    -- CCHttpClient :getInstance():send(getServerListRequest)
    serverListCallback(nil)
end

function CSelectServerScene.onServerListCallback( self, response )
    CCLOG("onServerListCallback -->")

    local function local_viewCallBack()
        self:removeJuHua()
    end
    
    _G.Scheduler:performWithDelay( 0.2, local_viewCallBack )

    -- local text = response :getResponseText()
    -- if string.len(text) == 0 then
    --     --CCMessageBox("Couldn't connect to Server","Error!")
    --     CCLOG("codeError!!!! Couldn't connect to Server")
    --     self :getServerList()
    --     return
    -- end
    
    self.m_httpSeverString = "[{\"ref\":1}]"--response:getResponseText()
    
    local strResult = self.m_httpSeverString--response:getResponseText()
    -- if string.find(strResult, "<") == 1 then
    --     --CCMessageBox("Server Busy","Error!")
    --     CCLOG("codeError!!!! Server Busy")
    --     self:createMessageBox("服务器繁忙")
    --     self :getServerList()
    --     return
    -- end
    CCLOG("SERVERLIST == "..strResult)
    -- local _,_,ref = string.find(strResult, '{"ref":(%d),')
    -- if ref ~= "1" then
    --     local _,_,msg = string.find(strResult, '"msg":"([^%s,]+)"')
    --     --CCMessageBox(msg,"Server List Error")
    --     CCLOG("codeError!!!! Server List Error"..msg)
    --     return
    -- end


    -- local a1,a2 = string.find(strResult, '"history":%[')
    -- local b1,b2 = string.find(strResult, '%],', a1)
    -- local _history = string.sub(strResult, a2, b1)
    self.m_pHistoryServers = {}--parseJSonObjects(_history)

    --recommend
    -- a1,a2 = string.find(strResult, '"recommend":%[')
    -- b1,b2 = string.find(strResult, '%],', a1)
    -- local _recommend = string.sub(strResult, a1, b1)
    self.m_pRecommendServers = {{name = "danji",sid="1"}}--parseJSonObjects(_recommend)
    
    --SeverList
    -- a1,a2 = string.find(strResult, '"all":%[')
    -- b1,b2 = string.find(strResult, '%],', a1)
    -- local _severList = string.sub(strResult, a1, b1)
    self.m_pSeverList = {{name = "danji",sid="1",ip="192.168.1.1",port="8080"},{name = "sever",sid="2",ip="192.168.1.1",port="8080"}}--parseJSonObjects(_severList)

    

    if self.m_bIsInit == false then
        self:resetServerBtn()

        self.m_moreServerBtn : setTouchesEnabled( true )
        self.m_goInBtn : setTouchesEnabled( true )

        self.m_bIsInit = true
    else
        if self.m_goMoreServer then
            self:resetServerBtn()
            self.m_goMoreServer = false
            self:goMroeServerScene()
        end
    end
end

function CSelectServerScene.resetServerBtn( self, _serverID )
    local recentlyServer = nil
    local newServer      = nil
    if _serverID ~= nil then
        recentlyServer = self:getServerById(_serverID)
    else
        recentlyServer = self:getRecentlyServer()
    end
    if newServer == nil then 
        newServer = self.m_pRecommendServers[1]
    end

    -- self.m_serverList[1].idx = 2
    -- self.m_serverList[1].serverId = newServer["sid"]
    -- self.m_serverButtonList[1] : setText(newServer.name.."("..tostring(newServer.count)..")")
    -- self.m_serverButtonList[1] : setTag( 1 )

    -- self.m_serverList[2].idx = 1
    -- self.m_serverList[2].serverId = recentlyServer["sid"]
    -- self.m_serverButtonList[2] : setText(recentlyServer.name.."("..tostring(recentlyServer.count)..")")
    -- self.m_serverButtonList[2] : setColor(ccc4(255,255,0,255))
    -- self.m_serverButtonList[2] : setTag( 2 )

    self.m_serverList[1].idx = 1
    self.m_serverList[1].serverId = newServer["sid"]
    self.m_serverButtonList[1] : setText(recentlyServer.name.."("..tostring(recentlyServer.count)..")")
    self.m_serverButtonList[1] : setColor(ccc4(255,255,0,255))
    self.m_serverButtonList[1] : setTag( 1 )

    _G.g_LoginInfoProxy:setServerId( recentlyServer["sid"] )
end

function CSelectServerScene.getRecentlyServer( self )
    local recentlyServer = nil
    if self.m_pHistoryServers[1] ~= nil then
        recentlyServer = self.m_pHistoryServers[1]
    elseif self.m_pRecommendServers[1] ~= nil then
        recentlyServer = self.m_pRecommendServers[1]
    elseif self.m_pSeverList[1] ~= nil then
        recentlyServer = self.m_pSeverList[2]
    end
    return recentlyServer
end

--获取用户列表
function CSelectServerScene.requestRoleList(self, _serverId)
    local function roleListCallback(response)
        self :onRoleListCallback(response)
    end

    
    -- local getRoleListRequest = CCHttpRequest()
    _G.pDateTime:reset()
    local timeLong = _G.pDateTime:getTotalSeconds()
    local sessionId = "";  -- by:yiping 
    local fcm = "0";  -- by:yiping 
    local fcmId = "";  -- by:yiping 

    local strTemp = "cid=".._G.LoginConstant.CID.."&sid="..tostring(_serverId).."&uuid="..tostring(_G.LoginInfo.uuid).."&fcm="..fcm.."&fcm_id="..fcmId.."&session="..sessionId.."&time="..tostring(timeLong)
    local strTempWithKey = strTemp.."&key=".._G.LoginConstant.KEY
    local strMD5 = CMD5Crypto:md5( strTempWithKey, string.len(strTempWithKey) )
    local strUrl = _G.netWorkUrl .. "/api/Phone/RoleList?"..tostring(strTemp).."&sign="..tostring(strMD5)


    print("get role list", strUrl)

    -- getRoleListRequest:setUrl(strUrl)
    -- getRoleListRequest:setRequestType(0)
    -- getRoleListRequest:setLuaCallback( roleListCallback )
    --CCHttpClient:getInstance():setTimeoutForConnect(5.0)
    --CCHttpClient:getInstance():setTimeoutForRead(5.0)
    -- CCHttpClient:getInstance():send(getRoleListRequest)
    roleListCallback(nil)
end

function CSelectServerScene.onRoleListCallback(self, response)
    CCLOG("onRoleListCallback -->")

    local function local_viewCallBack()
        self:removeJuHua()
        self.m_goInBtn :setTouchesEnabled( true )
    end
    

    _G.Scheduler:performWithDelay( 0.2, local_viewCallBack )

    -- local text = response :getResponseText()
    -- if string.len(text) == 0 then
    --     --CCMessageBox("Couldn't connect to Server","Error!")
    --     CCLOG("codeError!!!! Couldn't connect to Server")
    --     self:createMessageBox("无法链接服务器")
    --     self :getServerList()
    --     return
    -- end

    
    local strResult = "[{\"ref\":1}]"--response:getResponseText()
    -- if string.find(strResult, "<") == 1 then
    --     --CCMessageBox("Server Busy","Error!")
    --     CCLOG("codeError!!!! Server Busy")
    --     self:createMessageBox("服务器繁忙")
    --     self :getServerList()
    --     return
    -- end
    -- print("strResult--->  "..strResult)
    -- local _,_,ref = string.find(strResult, '{"ref":(%d),')
    -- if ref ~= "1" then
    --     local _,_,msg = string.find(strResult, '"msg":"([^%s,]+)"')
    --     --CCMessageBox(msg,"Role List Error")
    --     CCLOG("codeError!!!! Role List Error"..msg)

    --     self:createMessageBox("服务器繁忙")
    --     return
    -- end
    
    -- local a1,a2 = string.find(strResult, '"role_list":%[')
    -- local b1,b2 = string.find(strResult, '%],',a1)
    -- local _roleList = string.sub(strResult, a2, b1)

    self.m_pRoleList = {{uid = 0, pro = 0, uname = "dan1", lv = 10},{uid = 1, pro = 1, uname = "dan2", lv = 10}}--parseJSonObjects(_roleList)

    print("-----------roleList------------")
    for i,v in ipairs(self.m_pRoleList) do
        print(i,v.uid,v.pro,v.uname)
    end
    print("-----------roleList------------")

    self:goSelectRoleView( self.m_pRoleList )
end

function CSelectServerScene.createMessageBox( self, _msg )

    local runningScene = CCDirector : sharedDirector() : getRunningScene()

    require "view/ErrorBox/ErrorBox"
    local ErrorBox  = CErrorBox()
    local BoxLayer  = ErrorBox : create( _msg )
    runningScene : addChild( BoxLayer, 1000)
end

function CSelectServerScene.goSelectRoleView( self, _playerList )
    _G.pSelectRoleView = CSelectRoleScene()
    local sence = _G.pSelectRoleView:scene( _playerList )
    CCDirector :sharedDirector():pushScene( sence )
end


function CSelectServerScene.setServerId( self, _idx )
    local serverId = self.m_serverList[tonumber( _idx )].serverId
    
    for i,obj in ipairs(self.m_serverButtonList) do
        local tag = obj:getTag()
        if tag == tonumber(_idx) then
            self.m_serverButtonList[i]:setColor(ccc4(255,255,0,255))
        else
            self.m_serverButtonList[i]:setColor(ccc4(255,255,255,255))
        end
    end

    _G.g_LoginInfoProxy:setServerId( serverId )
end

function CSelectServerScene.getServerById( self, _serverId )
    for i,v in ipairs(self.m_pSeverList) do
        if tonumber(v["sid"]) == tonumber(_serverId) then
            return v
        end
    end
end

function CSelectServerScene.getAllServerList( self )
    return self.m_pSeverList
end

function CSelectServerScene.getRecommendServerList( self )
    return self.m_pRecommendServers
end

function CSelectServerScene.getHistoryServerList( self )
    return self.m_pHistoryServers
end

function CSelectServerScene.getRoleList( self )
    return self.m_pRoleList
end

