
require "mediator/mediator"
require "controller/command"

CNpcMediator = class(mediator, function(self, _view)

    self.name = "NpcMediator"
    self.view = _view
end)

function CNpcMediator.processCommand(self, _command)
    if _command:getType() == CNetworkCommand.TYPE then
        local msgID = _command:getProtocolID()
        local ackMsg = _command:getAckMessage()

    end

    if _command :getType() == CTaskDataUpdataCommand.TYPE then
        if _G.Protocol.ACK_TASK_DATA == _command :getData() then
            local curScenesType = _G.g_Stage :getScenesType()
            if curScenesType == _G.Constant.CONST_MAP_TYPE_CITY then
                if _G.CharacterManager ~= nil then
                    --self :ACK_TASK_DATA()
                end
            end
        end
    end

    --更新图标
    if _command :getType() == CNpcUpdateCommand.TYPE then
        self :processData( _command :getData() )
    end
    return false
end

function CNpcMediator.processData( self, _data )
    print("_data类型－－", type( _data ) )

    local npcArr = _G.CharacterManager : getNpc()

    if type( _data ) == "table" then
        CCLOG( "更新npc头上的状态图标" .. _data.id .. _data.state )

        _nState = _data.state
        local _node = _G.g_CTaskNewDataProxy :getTaskDataById( _data.id )
        if _node ~= nil then
            npcNode =_node : children() :get(0,"npc")
            snode = npcNode : children() :get(0,"s")
            enode = npcNode : children() :get(0,"e")
            taskBeginNpc = tonumber(  snode : getAttribute("npc") )
            taskEndNpc   = tonumber( enode:getAttribute("npc") )

            if npcArr ~= nil then
                for key, value in pairs( npcArr ) do

                    if taskBeginNpc == taskEndNpc and taskBeginNpc == tonumber( value.m_nID ) then
                        value :setIcon( nil)
                        value :setIcon( tonumber( _nState ) )
                        break
                    end

                    --不相同时
                    if taskBeginNpc ~= taskEndNpc then
                        if _nState <= 3 then
                            if taskBeginNpc == tonumber( value.m_nID ) then
                                value :setIcon( tonumber( _nState ) )
                                break
                            end
                        elseif _nState > 3 then
                            if taskEndNpc == tonumber( value.m_nID ) then
                                value :setIcon( tonumber( _nState ) )
                                for k, v in pairs( npcArr ) do
                                    if v.m_nID == taskBeginNpc then
                                        v :setIcon( nil )
                                        break
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    elseif type( _data ) == "number" then       --清空
        local _node = _G.g_CTaskNewDataProxy :getTaskDataById( _data )
        if _node ~= nil then
            npcNode=_node : children() :get(0,"npc")
            taskEndNpc   = tonumber( npcNode : children() :get(0,"e"):getAttribute("npc") )

            for key, value in pairs( npcArr ) do
                if value.m_nID == tonumber( taskEndNpc ) then
                    value :setIcon( nil )
                    break
                end
            end
        end
    end
end

function CNpcMediator.ACK_TASK_DATA( self )
    CCLOG( "\n CNpcMediator.ACK_TASK_DATA" )
    local npcArr    = _G.CharacterManager : getNpc()       --获取场景中的npc

    if _G.g_CTaskNewDataProxy :getInitialized() == true and npcArr ~= nil then
        local mainTask = _G.g_CTaskNewDataProxy : getMainTask()

        if mainTask ~= nil then
            local _nState = tonumber( mainTask.state )

            local taskNode = _G.g_CTaskNewDataProxy :getTaskDataById( mainTask.id )
            if taskNode ~= nil then
                taskBeginNpc = tonumber( _G.g_CTaskNewDataProxy :getNpcAttribute( taskNode, "s", "npc" ) )
                taskEndNpc   = tonumber( _G.g_CTaskNewDataProxy :getNpcAttribute( taskNode, "e", "npc" ) )

                for key, value in pairs( npcArr ) do
                    print("key, value", taskBeginNpc, taskEndNpc, value.m_nID, _nState, value.m_szName )

                    --[[for kk, vv in pairs( value ) do
                     print( "111111", kk, vv )
                     end
                     --]]
                    --开始npc和结束npc相同时
                    if taskBeginNpc == taskEndNpc and taskBeginNpc == tonumber( value.m_nID ) then
                        value :setIcon( tonumber( _nState ) )
                        break
                    end

                    --不相同时
                    if taskBeginNpc ~= taskEndNpc then
                        print("\n -=-=-=taskBeginNpc ~= taskEndNpc-=-=-=")
                        if _nState <= 3 then
                            if taskBeginNpc == tonumber( value.m_nID ) then
                                value :setIcon( tonumber( _nState ) )
                                break
                            end
                            elseif _nState > 3 then
                            if taskEndNpc == tonumber( value.m_nID ) then
                                value :setIcon( tonumber( _nState ) )

                                for k, v in pairs( npcArr ) do
                                    if v.m_nID == taskBeginNpc then
                                        v :setIcon( nil )
                                        break
                                    end
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    --[[
     if _G.g_CTaskNewDataProxy :getInitialized() == true then
     local taskData  = _G.g_CTaskNewDataProxy : getTaskDataList()
     if taskData ~= nil and npcArr ~= nil then
     for key, data in pairs( taskData ) do

     local taskNode = _G.g_CTaskNewDataProxy :getTaskDataById( data.id )
     if taskNode ~= nil then
     taskBeginNpc = tonumber( taskNode.npc[1].s[1].npc )
     taskEndNpc   = tonumber( taskNode.npc[1].e[1].npc )
     --------------------------------------
     for npcKey, npcValue in pairs( npcArr ) do
     npcValue :setIcon( nil ) --先全部清空

     --如果开始npc和结束npc相同
     if taskBeginNpc == taskEndNpc and taskBeginNpc == tonumber( npcValue.m_nID ) then
     npcValue :setIcon( tonumber( data.state ) )
     end

     --如果开始npc和结束npc不相同
     if taskBeginNpc ~= taskEndNpc then
     if data.state <= 3 then
     if taskBeginNpc == tonumber( npcValue.m_nID ) then
     npcValue :setIcon( tonumber( data.state ) )
     end
     elseif data.state > 3 then
     if taskEndNpc == tonumber( npcValue.m_nID ) then
     npcValue :setIcon( tonumber( data.state ) )
     end
     end
     end
     end
     --------------------------------------
     end
     --print("CNpcMediator.ACK_TASK_DATA", key, data.id, data.state, data.target_type, taskNode )

     end
     end
     end
     --]]
end

--[[
function CNpcMediator.ACK_TASK_DATA2( self )     --09.12弃用
    print("npcMediator图标设置")
    local npcArr = _G.CharacterManager : getNpc()       --获取场景中的npc
    local taskData = _G.g_CTaskNewDataProxy :getMainTask()
    if npcArr == nil or taskData == nil then
        return
    end
    print("任务状态", taskData.state )

    local bValue = false
    if taskData.beginNpc == taskData.endNpc then
        for taskKey, taskValue in pairs( taskData) do
            for npcKey, npcValue in pairs( npcArr) do
                if taskKey == "beginNpc" and tonumber( taskValue) == tonumber( npcValue.m_nID) then
                    npcValue :setIcon( tonumber( taskData.state))
                end
            end
        end
        else
        for taskKey, taskValue in pairs( taskData) do
            for npcKey, npcValue in pairs( npcArr) do
                if taskKey == "beginNpc" and tonumber( taskValue) == tonumber( npcValue.m_nID) then
                    print("设置图标的是beginNpc", npcValue.m_nID, bValue, taskData.state)
                    npcValue :setIcon( taskData.state)

                    for key, value in pairs( npcArr) do
                        print("清除end的图标", value :getIconState())
                        if tonumber( taskData.endNpc) == value.m_nID and value :getIconState() then
                            value :setIcon( nil)
                        end
                    end
                    return

                    elseif taskKey == "endNpc" and tonumber( taskValue) == tonumber( npcValue.m_nID) then
                    print("设置图标的是endNpc", npcValue.m_nID, bValue, taskData.state)
                    npcValue :setIcon( tonumber( taskData.state))

                    for key, value in pairs( npcArr) do
                        print("清除beginNpc的图标", value :getIconState())
                        if tonumber( taskData.beginNpc) == value.m_nID and value :getIconState() then
                            value :setIcon( nil)
                        end
                    end
                    return

                end
            end
        end
    end
end
--]]



