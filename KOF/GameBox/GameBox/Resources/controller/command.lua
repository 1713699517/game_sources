require "common/protocol/auto/REQ_ROLE_LOGIN"

command = class(function(self, _type)
    self.type = _type
    self.data = nil
end)

function command.getType(self)
    return self.type
end

function command.getData(self)
    return self.data
end

function command.setData(self, data)
    self.data = data
end

CNetworkCommand = class(command, function(self, _msgId, _ackMessage)
    self.type = "TYPE_CNetworkCommand"
    self.m_nMsgId = _msgId
    self.m_ackMessage = _ackMessage
end)

CNetworkCommand.TYPE = "TYPE_CNetworkCommand"

function CNetworkCommand.getProtocolID(self)
	return self.m_nMsgId
end

function CNetworkCommand.getAckMessage(self)
	return self.m_ackMessage
end



_controller = class(function(self)
    self.mediators = nil
    self.m_processor = CContainer:create()
    self.m_processor : setControlName( "this is _controller self.m_processor")
    self.m_processor:retain()
    local function processMessage(eventType, ackMessage)
        self:onProcessNetworkMessage(eventType, ackMessage)
    end

    self.m_processor:registerNetworkMessageScriptHandler(processMessage)

    local function processCCNotificationCenterMessage(_notificationName)
        if _notificationName == "DISCONNECT_MESSAGE" then
            print("cgggg", CNetwork:getReconnect() )
            if CNetwork:getReconnect() ~= true then
                return
            end

            require "view/ErrorBox/ErrorBox"

            CCLOG("LUA received disconnect message")

            local function exitGame()
                CCDirector:sharedDirector():endToLua()
            end

            local function reConnect()
                local voReact = VO_NetworkAsyncObject( 0 , {} )
                local voCommand = CNetworkAsyncCommand(CNetworkAsyncCommand.ACT_WAIT, voReact)
                _G.controller:sendCommand(voCommand)
                self:onConnectionDisconnected()
            end
            if _G.g_ServerTime.dispHandle ~= nil then
                _G.Scheduler : unschedule( _G.g_ServerTime.dispHandle )
                _G.g_ServerTime.dispHandle = nil
            end
            
            local errorBox = CErrorBox()
            local BoxLayer = errorBox : create("与服务器已经断开连接请重新登陆",reConnect,exitGame)
            local btn = errorBox : getBoxCancelBtn()
            if btn ~= nil then
                btn : setText("退出")
                btn : setTouchesPriority( -200000 - 100 )
            end
            local btn2 = errorBox : getBoxEnsureBtn()
            if btn2 ~= nil then
                btn2 : setText("重连")
                btn2 : setTouchesPriority( -200000 - 100 )
            end
            local nowScene = CCDirector : sharedDirector() : getRunningScene()
            nowScene : addChild(BoxLayer,1000)
            
            if _G.pCGuideManager ~= nil then
                _G.pCGuideManager:disConnectServer()
            end
        elseif _notificationName == "LevelResource" then
            if self.fun_updateSceneFun ~= nil then
                _G.controller.fun_updateSceneFun()
                self : setUpdateSceneFun()

            end


            if _G.g_CTaskNewDataProxy ~= nil then
                local currentTask = _G.g_CTaskNewDataProxy :getMainTask()
                --判断是否为60级的 下载后续任务
                if currentTask ~= nil and currentTask.target_type == 6 and currentTask.target_id ~= nil and currentTask.target_id == 21 and currentTask.state == 3 then
                    currentTask.state = 4           --更新为任务完成状态

                    _G.g_CTaskNewDataProxy :setTaskDataList( currentTask )

                    local l_task_list = _G.g_CTaskNewDataProxy :getTaskDataList()
                    if l_task_list ~= nil then
                        for key, taskValue in pairs( l_task_list ) do
                            if taskValue.id == currentTask.id then
                                --更新主线任务
                                _G.g_CTaskNewDataProxy :setMainTask( l_task_list[key] )
                                break
                            end
                        end
                    end

                end
            end

        end

    end
    CCNotificationCenter:sharedNotificationCenter():registerScriptObserver(processCCNotificationCenterMessage)
end)

function _controller.setUpdateSceneFun( self, _func )
    self.fun_updateSceneFun = _func
end

function _controller.performSelector(self, delay, l_func)
    return self.m_processor:performSelector(delay, l_func)
end

function _controller.unperformSelector(self, acthandle)
    self.m_processor:unperformSelector(acthandle)
end


function _controller.onConnectionDisconnected(self)


    local httpReconn = CCHttpRequest()
    _G.pDateTime:reset()
    local timeLong = _G.pDateTime:getTotalSeconds()

    local sessionId = ""
    local macID = CDevice:sharedDevice():getMAC()
    if macID == nil or string.len(macID) == 0 then
        macID = "1"
    end
    local strTemp = "cid=".._G.LoginConstant.CID.."&sid="..tostring(_G.g_LoginInfoProxy:getServerId()).."&uuid="..tostring(_G.LoginInfo.uuid)..
    "&uid="..tostring(_G.g_LoginInfoProxy:getUid()).."&mac="..macID.."&fcm=0&fcm_id=&session="..sessionId.."&time="..tostring(timeLong)
    local strTempWithKey = strTemp.."&key=".._G.LoginConstant.KEY

    local strMD5 = CMD5Crypto:md5( strTempWithKey, string.len(strTempWithKey) )
    local postData = tostring(strTemp).."&sign="..tostring(strMD5)

    local function relinkcallback(response)
        self:onReconnectCallBack(response)
    end

    self.onReconnectCallBack({})

    -- local strRelinkUrl = _G.netWorkUrl .. "/api/Phone/LoginRelink"
    -- httpReconn:setUrl( strRelinkUrl )
    -- httpReconn:setRequestData( postData, string.len(postData) )
    -- httpReconn:setRequestType(1) --post
    -- httpReconn:setLuaCallback( relinkcallback )
    -- CCHttpClient:getInstance():send( httpReconn )
end

function _controller.onReconnectCallBack(self, response)
    -- local text = response:getResponseText()
    -- if string.len(text) == 0 then
    --     -- local voCommand = CNetworkAsyncCommand(CNetworkAsyncCommand.ACT_CONTINUE)
    --     -- _G.controller:sendCommand(voCommand)
    --     --CCNotificationCenter:sharedNotificationCenter():postNotification("DISCONNECT_MESSAGE")
    --     self : onConnectionDisconnected()
    --     return
    -- end
    -- text = "["..text.."]"
    -- CCLOG("Relink text = "..text)
    -- local jsonObjArr = parseJSonObjects(text)
    -- local jsonObj = jsonObjArr[1]
    local jsonObj = {ref = 1, host = "192.168.1", port = "8080", uuid = "10001", pwd = "123456", login_time = os.time()}

    if tonumber(jsonObj.ref) == 0 then
        CCMessageBox(jsonObj.msg, "Error"..tostring(jsonObj.error))
        CCLOG("codeError!!!! from command "..tostring(jsonObj.error))
    elseif tonumber(jsonObj.ref) == 1 then
        if not CNetwork:isConnected() then
            local ret = CNetwork:connect( tostring(jsonObj.host), tonumber(jsonObj.port) )
            if ret ~= 0 then
                local msg = REQ_ROLE_LOGIN()
                msg: setUid(_G.g_LoginInfoProxy:getUid())
                msg: setUuid(jsonObj.uuid)
                msg: setSid(_G.g_LoginInfoProxy:getServerId())
                msg: setCid(217)
                msg: setOs("ios")
                msg: setPwd(jsonObj.pwd)
                msg: setVersions(1.34)
                msg: setFmc(0)
                msg: setRelink(true)
                msg: setDebug(false)
                msg: setLoginTime(tonumber(jsonObj.login_time))
                CNetwork :send(msg)

                CRechargeScene:setRechargeData("username", tostring( CUserCache:sharedUserCache():getObject("userName")))
                CRechargeScene:setRechargeData("roleid", tostring(_G.g_LoginInfoProxy:getUid()))
                CRechargeScene:setRechargeData("serverid", tostring(_G.g_LoginInfoProxy:getServerId()))
            else
                CCNotificationCenter:sharedNotificationCenter():postNotification("DISCONNECT_MESSAGE")
                --CCMessageBox("Couldn't reconnect to Server", "Error!")
            end
        end
    end

    local voCommand = CNetworkAsyncCommand(CNetworkAsyncCommand.ACT_CONTINUE)
    _G.controller:sendCommand(voCommand)
end

function _controller.onProcessNetworkMessage(self, eventType, ackMessage)
    local ackMsg = CNetwork :parse(eventType, ackMessage)
    if ackMsg ~= nil then
        local networkCmd = CNetworkCommand( ackMessage:getMsgID(), ackMsg)
        self:sendCommand( networkCmd )
    end
end

function _controller.registerMediator(self, mediator)
    if self.mediators == nil then
        self.mediators = {}
    end
    self.mediators[ mediator:getName() ] = mediator
    CCLOG("_registerMediator  "..mediator:getName())
end

function _controller.unregisterMediatorByName(self, name)
    self.mediators[name] = nil
    CCLOG("unregisterMediator  "..name)
end

function _controller.unregisterMediators(self)
    for k,v in pairs(self.mediators) do
        self:unregisterMediatorByName(k)
    end
end

function _controller.unregisterMediator(self, mediator)
    self.unregisterMediatorByName(self, mediator:getName())
end

function _controller.sendCommand(self, _command)
    if _command:is(command) then
        CCLOG("start _controller.sendCommand  ".._command:getType())
        for key,value in pairs(self.mediators) do
            if( value:is(mediator) ) then
                CCLOG("start  processCommand  "..value:getName())
                if value:processCommand(_command) == true then
                    CCLOG("end  processCommand  enter "..value:getName())
                    break
                end
                CCLOG("end  processCommand  no enter "..value:getName())
            end
        end
        CCLOG("end _controller.sendCommand  ".._command:getType())
    end
end

_G.controller = _controller()