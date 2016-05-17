require "mediator/mediator"
--[[
场景漂浮文字
]]
require "controller/LogsCommand"
require "controller/GuideCommand"
require "controller/FlyItemCommand"

CLogsMediator = class(mediator, function(self, _view)
    self.name = "CLogsMediator"
    self.view = _view
    _G.Config:load( "config/goods.xml" )
    _G.Config:load( "config/fight_gas_total.xml" )
    print("_G.Config.goodss",_G.Config.goodss)
end)


function CLogsMediator.processCommand(self, _command)
    if _command:getType() == CNetworkCommand.TYPE then
        local msgID = _command:getProtocolID()
        local ackMsg = _command:getAckMessage()
        if msgID == _G.Protocol["ACK_GAME_LOGS_NOTICES"] then -- [22760]获得|失去通知 -- 日志
            self : ACK_GAME_LOGS_NOTICES( ackMsg )
            print("22760")
            return true
        elseif msgID == _G.Protocol["ACK_GAME_LOGS_EVENT"] then -- [22780]事件通知 -- 日志
            self : ACK_GAME_LOGS_EVENT( ackMsg )
            print("22780------",ackMsg :getId())

            ----[[
            if _G.g_CFunOpenManager ~= nil then
                _G.g_CFunOpenManager : addOneNotic( ackMsg )
            end
            --]]

            --活跃度可领取奖励  -- 添加特效
            if ackMsg :getId() == _G.Constant.CONST_LOGS_1117 then
                print("活跃度可领取奖励  -- 添加特效---")
                _G.g_GameDataProxy : setIsActivenessCCBIHere( true )
                if _G.pCActivityIconView ~= nil then
                    _G.pCActivityIconView : createActivenessCCBI()
                end
            end

            return true
        end
    end

    if _command :getType() == CLogsCommand.TYPE then
        self : ACK_LOGS_COMMAND( _command :getData() )
    end

    if _command :getType() == CGuideNoticCammand.TYPE then
        if _command:getData() == CGuideNoticCammand.ADD then

            print("CGuideNoticCammand.ADD--> msgId=".._command:getNoticId())

            local msgId   = _command:getNoticId()
            if msgId ~= nil then
                local msgList = {}
                msgList.id = msgId
                msgList.count_str  = 0
                msgList.str_module = {}
                msgList.count_int  = 0
                msgList.int_module = {}

                _G.g_CFunOpenManager :addOneNotic( msgList )
            end

        end
    end

    return false
end

--{接收command :getData()}
function CLogsMediator.ACK_LOGS_COMMAND( self, _szData )
    if _szData ~= nil then
        self : getView() : pushOne( _szData )
    end
end

-- [22760]获得|失去通知 -- 日志
function CLogsMediator.ACK_GAME_LOGS_NOTICES( self, _ackMsg )
    local evenType = _ackMsg : getType()
    if evenType == _G.Constant.CONST_LOGS_TYPE_CURRENCY then
        self : checkCurrency( _ackMsg )
    elseif evenType == _G.Constant.CONST_LOGS_TYPE_GOODS then
        self : checkGoods( _ackMsg )
    elseif evenType == _G.Constant.CONST_LOGS_TYPE_ATTR then
        self : checkAttr( _ackMsg )
    elseif evenType == _G.Constant.CONST_LOGS_TYPE_BUFF then
        self : checkBuff( _ackMsg )
    elseif evenType == _G.Constant.CONST_LOGS_TYPE_DOUQI then
        self : checkFightGas( _ackMsg )
    end
end

-- [22780]事件通知 -- 日志
function CLogsMediator.ACK_GAME_LOGS_EVENT( self, _ackMsg )
    local tmpStr = CLanguageManager:sharedLanguageManager():getString("logs_"..tostring(_ackMsg:getId()))

    --邮件8004 在主界面添加一个图标
    if tonumber( _ackMsg :getId() ) == _G.Constant.CONST_LOGS_8004 then
        require "controller/EmailCommand"
        local command = CEmailUpdataCommand( CEmailUpdataCommand.ICON )
        controller :sendCommand( command )
    end

    if tmpStr == nil then
        return
    end
    --local value = tmpStr.value
    local strModule = _ackMsg : getStrModule()
    for i=1,_ackMsg : getCountStr() do
        tmpStr =  self : gsub( tmpStr, "$", strModule[i] : getType1(), strModule[i] : getColour() )
    end
    local intModule = _ackMsg : getIntModule()
    for i=1,_ackMsg : getCountInt() do
        tmpStr =  self : gsub( tmpStr, "#", intModule[i] : getType2()  )
    end
    self : getView() : pushOne( tmpStr )
end


--[[
    *****************************others function
]]


--{金币类判断}
function CLogsMediator.checkCurrency( self, _ackMsg )
    local mess = _ackMsg : getMess()
    if mess == nil then
        return
    end
    for i=1, _ackMsg : getCount() do
        local stateStr = CLanguageManager:sharedLanguageManager():getString("state_symbol_"..tostring(mess[i]:getStates()))
        local currencyStr = CLanguageManager:sharedLanguageManager():getString("currency_type"..tostring(mess[i]:getId()))
        if currencyStr ~= nil and stateStr ~= nil then
            local result  = currencyStr..stateStr..tostring( mess[i] : getValue() )
            local nStates = mess[i] :getStates()
            self : getView() : pushOne( result, nStates )
        end
    end
end
--{装备类判断}
function CLogsMediator.checkGoods( self, _ackMsg )
    -- body
    local mess = _ackMsg : getMess()
    if mess == nil then
        return
    end
    for i=1,_ackMsg : getCount() do
        local stateStr = CLanguageManager:sharedLanguageManager():getString("state_"..tostring(mess[i]:getStates()))
        local goodsNode = _G.Config.goodss : selectSingleNode( "goods[@id="..tostring(mess[i] : getId()).."]" )
        if (not goodsNode:isEmpty()) and stateStr ~= nil then
            if mess[i]:getStates() == 1 then --get item
                local cf = CFlyItemCommand( mess[i] : getId() )
                controller:sendCommand(cf)
            end

            local result = stateStr..goodsNode:getAttribute("name").."*"..tostring(mess[i] : getValue())

            self : getView() : pushOne( result )
        end
    end
end
--{属性类判断}
function CLogsMediator.checkAttr( self, _ackMsg )
    local mess = _ackMsg : getMess()
    if mess == nil then
        return
    end
    for i=1,_ackMsg : getCount() do
        local stateStr = CLanguageManager:sharedLanguageManager():getString("state_symbol_"..tostring(mess[i]:getStates()))
        local currencyStr = CLanguageManager:sharedLanguageManager():getString("goodss_goods_base_types_base_type_type"..tostring(mess[i] : getId()) )
        if currencyStr ~= nil and stateStr ~= nil then
            local result = currencyStr..stateStr..tostring(mess[i] : getValue())
            local nStates = mess[i] :getStates()
            self : getView() : pushOne( result, nStates )
        end
    end
end
--{属性类判断}
function CLogsMediator.checkBuff( self, _ackMsg )
    -- body
end

function CLogsMediator.gsub( self, _str ,_taget, _source, _color )
    local result=""
    local isfind = false
    local colorStr = CLanguageManager:sharedLanguageManager():getString("CONST_COLOR_"..tostring(_color))
    if colorStr == nil then
        colorStr = "<color:255,255,255,255>"
    else
        colorStr = colorStr.value
    end
    for i=1,string.len(_str) do
        local tmpStr = string.sub(_str,i,i)
        if tmpStr == _taget and isfind == false then
            result = result.._source
            isfind = true
        else
            result = result..tmpStr
        end
    end
    return result
end

--{斗气类判断}
function CLogsMediator.checkFightGas( self, _ackMsg )
    _G.Config:load("config/fight_gas_total.xml")
    local nCount = _ackMsg :getCount()
    if nCount > 0 then
        local mess = _ackMsg :getMess()

        for i=1, nCount do
            local stateStr = CLanguageManager:sharedLanguageManager():getString("state_"..tostring(mess[i]:getStates()))
            local goodsNode = _G.Config.fight_gas_totals : selectSingleNode( "fight_gas_total[@gas_id="..tostring(mess[i] : getId()).."]" )
            if (not goodsNode:isEmpty()) and stateStr ~= nil then
                local result  = stateStr..goodsNode:getAttribute("gas_name").." *"..tostring( mess[i] : getValue() )
                local nStates = mess[i] :getStates()
                self : getView() : pushOne( result, nStates )
            end
        end
    end


end