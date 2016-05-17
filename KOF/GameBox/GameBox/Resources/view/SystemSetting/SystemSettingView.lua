--*********************************
--2013-9-14 by 陈元杰
--系统设置 子界面-CSystemSettingView
--*********************************

require "view/view"
require "controller/command"
require "mediator/mediator"
require "view/ErrorBox/ErrorBox"

CSystemSettingView = class(view, function(self)
end)

--************************
--常量定义
--************************
-- button的Tag值
CSystemSettingView.TAG_CLOSE   = 201
CSystemSettingView.TAG_EXIT    = 202
CSystemSettingView.TAG_CHUANGE = 203

-- ccColor4B 常量
CSystemSettingView.RED   = ccc4(255,0,0,255)
CSystemSettingView.GOLD  = ccc4(255,235,0,255)
CSystemSettingView.GREEN = ccc4(120,222,66,255)

CSystemSettingView.FONT_SIZE = 20

CSystemSettingView.CELL_SIZE = CCSizeMake( 255,50 )
CSystemSettingView.JIANGE_X  = 100
CSystemSettingView.JIANGE_Y  = 45


function CSystemSettingView.initView( self, _mainSize )

    self.m_mainContainer = CContainer :create()
    self.m_mainContainer : setControlName( "this CSystemSettingScene self.m_mainContainer 39 ")
    self.m_viewContainer : addChild( self.m_mainContainer )

    self.m_mainBg = CSprite :createWithSpriteFrameName("general_second_underframe.png")
    self.m_mainBg : setControlName( "this CSystemSettingView self.m_mainBg 39 ")
    self.m_mainBg : setPreferredSize( CCSizeMake( 824,554 ) )
    self.m_mainContainer : addChild( self.m_mainBg )

    self.m_lineBg = CSprite :createWithSpriteFrameName("general_dividing_line.png", CCRectMake( 200,0,6,3 ))
    self.m_lineBg : setControlName( "this CSystemSettingView self.m_lineBg 39 ")
    self.m_lineBg : setPreferredSize( CCSizeMake( 854,3 ) )
    self.m_mainContainer : addChild( self.m_lineBg )

    ----------------------------
    --主界面
    ----------------------------
    local function local_btnTouchCallBack( eventType,obj,x,y )
        return self:btnTouchCallBack( eventType,obj,x,y )
    end

    self.m_exitBtn   = CButton :createWithSpriteFrameName( "退出游戏", "general_button_normal.png")
    self.m_exitBtn   :setControlName( "this CFurinkazanView self.m_exitBtn 521 ")
    self.m_exitBtn   :setTag( CSystemSettingView.TAG_EXIT )
    self.m_exitBtn   :setFontSize(24)
    self.m_exitBtn   :registerControlScriptHandler( local_btnTouchCallBack, "this CSystemSettingView self.m_exitBtn 525 ")
    self.m_mainContainer :addChild( self.m_exitBtn )

    self.m_chuangeBtn    = CButton :createWithSpriteFrameName( "切换角色", "general_button_normal.png")
    self.m_chuangeBtn   :setControlName( "this CFurinkazanView self.m_chuangeBtn 521 ")
    self.m_chuangeBtn   :setTag( CSystemSettingView.TAG_CHUANGE )
    self.m_chuangeBtn   :setFontSize(24)
    self.m_chuangeBtn   :registerControlScriptHandler( local_btnTouchCallBack, "this CSystemSettingView self.m_chuangeBtn 525 ")
    self.m_mainContainer :addChild( self.m_chuangeBtn )


    local function local_editBoxCallBack( eventType,obj,x,y )
        return self:editBoxCallBack( eventType,obj,x,y )
    end

    self.m_checkBoxContainer = CContainer :create()
    self.m_checkBoxContainer : setControlName( "this CSystemSettingView self.m_checkBoxContainer 39 ")
    self.m_mainContainer     : addChild( self.m_checkBoxContainer )

    local cellSize = CSystemSettingView.CELL_SIZE
    self.m_sysListLayout = CHorizontalLayout:create()
    self.m_sysListLayout : setCellSize( cellSize )
    self.m_sysListLayout : setCellHorizontalSpace(CSystemSettingView.JIANGE_X)
    self.m_sysListLayout : setCellVerticalSpace(CSystemSettingView.JIANGE_Y)
    self.m_sysListLayout : setLineNodeSum(2)
    self.m_sysListLayout : setColumnNodeSum(4)
    self.m_sysListLayout : setVerticalDirection(false)   --垂直  从上至下
    self.m_sysListLayout : setHorizontalDirection( true )    --从左到右
    self.m_checkBoxContainer : addChild(self.m_sysListLayout )

    self.m_checkBoxList = {}
    for i=1,#self.m_sysSettingList do
        local state   = self.m_sysSettingList[i].state
        local sysType = self.m_sysSettingList[i].type
        local typeName = _G.pCSystemSettingProxy : getSettingNameByType( sysType )
        self.m_sysSettingList[i].isChuange = false --是否改变
        self.m_checkBoxList[i] = CCheckBox:create("LuckyResources/general_pages_normal.png", "LuckyResources/general_pages_pressing.png", typeName )
        self.m_checkBoxList[i] : setControlName( "this CSystemSettingView m_checkBoxList[i] 262 ")
        self.m_checkBoxList[i] : setTag( sysType )
        self.m_checkBoxList[i] : setFontSize( 25 )
        self.m_checkBoxList[i] : registerControlScriptHandler( local_editBoxCallBack, "this CSystemSettingView self.m_checkBoxList[i] 269")
        self.m_checkBoxList[i] : setPosition( ccp( -cellSize.width/2 + 30, 0 ) )
        -- self.m_sysListLayout : addChild(self.m_checkBoxList[i])

        if state == 0 then
            self.m_checkBoxList[i] : setChecked( false )
        else
            self.m_checkBoxList[i] : setChecked( true )
        end

        local itemBg = CSprite :createWithSpriteFrameName("transparent.png")
        itemBg : setControlName( "this CSystemSettingView itemBg 39 ")
        itemBg : setPreferredSize( cellSize )
        self.m_sysListLayout : addChild( itemBg )

        itemBg : addChild( self.m_checkBoxList[i],100 )
    end
end

function CSystemSettingView.loadResources(self)
    print("CSystemSettingView -- 加载资源")
    -- CCSpriteFrameCache :sharedSpriteFrameCache():addSpriteFramesWithFile("ActivitiesResources/ActivitiesResources.plist")
end

function CSystemSettingView.layout(self, _mainSize)

    self.m_mainBg : setPosition( ccp( _mainSize.width/2, 292 ) )
    self.m_lineBg : setPosition( ccp( _mainSize.width/2, 165 ) )
    ----------------------------
    --主界面
    ----------------------------
    self.m_chuangeBtn : setPosition( ccp( 280, 92 ) )
    self.m_exitBtn    : setPosition( ccp( 854-280, 92 ) )
    self.m_sysListLayout : setPosition( _mainSize.width/2 - CSystemSettingView.CELL_SIZE.width - CSystemSettingView.JIANGE_X/2, 510 )
end

--初始化数据成员
function CSystemSettingView.initParams( self)

    --注册mediator
    -- _G.pCActivitiesMediator = CActivitiesMediator(self)
    -- controller :registerMediator(_G.pCActivitiesMediator)--先注册后发送 否则会报错

    local list = {}
    if _G.pCSystemSettingProxy : getInited() then
        list = _G.pCSystemSettingProxy:getSysSettingList()
    else
        print("缓存没数据","提示")
    end

    print("-------------系统设置--------------")

    self.m_sysSettingList = {}
    for i,v in ipairs(list) do
        print("----"..i,v.type,v.state)
        -- if v.type ~= _G.Constant.CONST_SYS_SET_GUIDE then
        --     --新手指引  不能设置
        --     table.insert( self.m_sysSettingList, v )
        -- end
        if v.type < 107 then
            table.insert( self.m_sysSettingList, v )
            print("长度:"..#self.m_sysSettingList)
        end
    end
    print("-------------系统设置--------------")

end

function CSystemSettingView.init(self, _mainSize)
    --加载资源
    self:loadResources()
    --初始化数据
    self:initParams()
    --初始化界面
    self:initView(_mainSize)
    --布局成员
    self:layout(_mainSize)
end

function CSystemSettingView.layer(self)
    local _winSize  = CCDirector:sharedDirector():getVisibleSize()
    local _mainSize = CCSizeMake( 854, _winSize.height )

    self.m_viewContainer = CContainer :create()
    self.m_viewContainer : setControlName( "this CLogUpdataView self.m_viewContainer 39 ")

    self:init( _mainSize )
    return self.m_viewContainer
end

function CSystemSettingView.chuangeRole( self )
    -- body
    --读取角色列表并切换UI


    _G.pSelectServerView = CSelectServerScene()
    local _startupScene = _G.pSelectServerView :scene()
    CNetwork:setReconnect(false)
    controller:unregisterMediators()    --清空所有Mediator
    g_initializeMediators()             --注册一般的Mediator
    CCDirector:sharedDirector():popToRootScene()
    CCDirector :sharedDirector():replaceScene( _startupScene )
    _G.pSystemScene:unloadResources()
    _G.pSelectServerView :getServerList()
    CNetwork:disconnect()
    --CNetwork:setReconnect(true)


    --[[
    local function roleListCallback(response)
        self :onRoleListCallback(response)
    end


    local getRoleListRequest = CCHttpRequest()
    _G.pDateTime:reset()
    local timeLong = _G.pDateTime:getTotalSeconds()
    local sessionId = "";  -- by:yiping
    local fcm = "0";  -- by:yiping
    local fcmId = "";  -- by:yiping

    local strTemp = "cid=".._G.LoginConstant.CID.."&sid="..tostring(_G.g_LoginInfoProxy:getServerId()).."&uuid="..tostring(_G.LoginInfo.uuid).."&fcm="..fcm.."&fcm_id="..fcmId.."&session="..sessionId.."&time="..tostring(timeLong)
    local strTempWithKey = strTemp.."&key=".._G.LoginConstant.KEY
    local strMD5 = CMD5Crypto:md5( strTempWithKey, string.len(strTempWithKey) )
    local strUrl = _G.netWorkUrl .. "/api/Phone/RoleList?"..tostring(strTemp).."&sign="..tostring(strMD5)

    print(strUrl)
    getRoleListRequest:setUrl(strUrl)
    getRoleListRequest:setRequestType(0)
    getRoleListRequest:setLuaCallback( roleListCallback )
    --CCHttpClient:getInstance():setTimeoutForConnect(5.0)
    --CCHttpClient:getInstance():setTimeoutForRead(5.0)
    CCHttpClient:getInstance():send(getRoleListRequest)
    CCDirector:sharedDirector():getTouchDispatcher():setDispatchEvents(false)
    ]]
end


function CSystemSettingView.onRoleListCallback(self, response)
    CCDirector:sharedDirector():getTouchDispatcher():setDispatchEvents(true)
    CCLOG("onRoleListCallback -->")

    local text = response :getResponseText()
    if string.len(text) == 0 then
        print("Couldn't connect to Server","Error!")
        return
    end


    local strResult = response:getResponseText()
    local _,_,ref = string.find(strResult, '{"ref":(%d),')
    if ref ~= "1" then
        local _,_,msg = string.find(strResult, '"msg":"([^%s,]+)"')
        print(msg,"Role List Error")
        return
    end

    local a1,a2 = string.find(strResult, '"role_list":%[')
    local b1,b2 = string.find(strResult, '%],',a1)
    local _roleList = string.sub(strResult, a2, b1)

    local playerlist = parseJSonObjects(_roleList)
    self:goSelectRoleView( playerlist )
end

function CSystemSettingView.goSelectRoleView( self, _playerList )
    _G.pSelectRoleView = CSelectRoleScene()
    local sence = _G.pSelectRoleView:scene( _playerList )
    CCDirector :sharedDirector():pushScene( sence )
end

function CSystemSettingView.exitGame( self )
    -- body
    CCDirector:sharedDirector():endToLua()
end

--************************
--按钮回调
--************************
function CSystemSettingView.btnTouchCallBack(self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
    elseif eventType == "TouchEnded" then
        if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
            local tag = obj:getTag()
            if tag == CSystemSettingView.TAG_CHUANGE then
                print("点击切换角色啦")

                local ErrorBox = CErrorBox()
                local function func1()
                    return self:chuangeRole()
                end
                local function func2()
                    print("bad2")
                end
                local BoxLayer = ErrorBox : create("是否回到切换角色界面?",func1,func2)
                _G.pSystemScene:getSceneLayer() : addChild(BoxLayer,500)

            elseif tag == CSystemSettingView.TAG_EXIT then
                print("点击退出游戏啦")

                local ErrorBox = CErrorBox()
                local function func1()
                    return self:exitGame()
                end
                local function func2()
                    print("bad2")
                end
                local BoxLayer = ErrorBox : create("是否退出游戏?",func1,func2)
                _G.pSystemScene:getSceneLayer() : addChild(BoxLayer,500)
            end
        end
    end
end



function CSystemSettingView.editBoxCallBack(self, eventType, obj, x, y)
    if eventType == "TouchBegan" then
        return obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y)))
    elseif eventType == "TouchEnded" then
        -- if obj:containsPoint(obj:convertToNodeSpaceAR(ccp(x,y))) then
            local sysType = obj:getTag()
            print("   点击类型为--"..sysType)

            local idx     = self:getIdxByType( sysType )
            local sysInfo = self.m_sysSettingList[idx]

            if self.m_sysSettingList[idx].isChuange then
                --之前已改变  现在复原
                self.m_sysSettingList[idx].isChuange = false
                if sysInfo.state == 0 then
                    self.m_checkBoxList[idx] : setChecked( false )
                else
                    self.m_checkBoxList[idx] : setChecked( true )
                end
            else
                self.m_sysSettingList[idx].isChuange = true
                if sysInfo.state == 0 then
                    self.m_checkBoxList[idx] : setChecked( true )
                else
                    self.m_checkBoxList[idx] : setChecked( false )
                end
            end

            --背景音乐
            if idx == _G.Constant.CONST_SYS_SET_MUSIC_BG then
                if self.m_checkBoxList[idx] : getChecked() == false then
                    SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()
                else
                    SimpleAudioEngine:sharedEngine():resumeBackgroundMusic()
                end
            end
        -- end
    end
end


function CSystemSettingView.getIdxByType( self, _type )

    for i,v in ipairs(self.m_sysSettingList) do
        if v.type == _type then
            return i
        end
    end
    return nil
end

--************************
--发送协议
--************************
--请求界面
function CSystemSettingView.sendSaveSettingMessage( self )

    require "common/protocol/auto/REQ_SYS_SET_CHECK"

    local list = _G.pCSystemSettingProxy:getSysSettingList()

    for i,v in ipairs(self.m_sysSettingList) do
        if v.isChuange then
            local msg = REQ_SYS_SET_CHECK()
            msg : setType( v.type )
            CNetwork : send( msg )

            self.m_sysSettingList[i].isChuange = false
            if self.m_sysSettingList[i].state == 0 then
                self.m_sysSettingList[i].state = 1
            else
                self.m_sysSettingList[i].state = 0
            end

            if self.m_sysSettingList[i].type == _G.Constant.CONST_SYS_SET_MUSIC_BG then
                if self.m_sysSettingList[i].state == 0 then
                    SimpleAudioEngine:sharedEngine():stopBackgroundMusic(true)
                else
                    --获取
                    SimpleAudioEngine:sharedEngine():playBackgroundMusic("Sound@mp3/"..tostring(_G.g_Stage:getBackgroundMusicId())..".mp3", true)
                end
            elseif self.m_sysSettingList[i].type == _G.Constant.CONST_SYS_SET_SHOW_ROLE then
                if self.m_sysSettingList[i].state == 0 then
                    local comm = CStageREQCommand(_G.Protocol["REQ_SCENE_REQUEST_PLAYERS"])
                    _G.controller : sendCommand( comm )
                else
                    _G.CharacterManager : removeOtherPlayer()
                end
            end

        end
    end

end


