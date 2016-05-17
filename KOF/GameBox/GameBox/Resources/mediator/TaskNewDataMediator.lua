require "mediator/mediator"
require "controller/command"

require "common/MessageProtocol"
require "common/protocol/ACK_TASK_REMOVE"
require "controller/TaskNewDataCommand"

require "controller/NpcCommand"
require "controller/GuideCommand"

CTaskNewDataMediator = class( mediator, function( self, _view)
                             self.m_name  = "CTaskNewDataMediator"
                             self.m_view  = _view
                             
                             print( "\n", self.m_name, " 的view 为", self.m_view )
                             end)

function CTaskNewDataMediator.getView( self)
    return self.m_view
end

function CTaskNewDataMediator.getName( self)
    return self.m_name
end

function CTaskNewDataMediator.processCommand( self, _command)
    
    if _command: getType() == CNetworkCommand.TYPE then
        
        local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()
        
        print( "\n CTaskNewDataMediator.processCommand msgId--->", msgID, "--->", ackMsg, "--->", _command: getType() )
        
        if msgID == _G.Protocol.ACK_TASK_DATA then                  ---3220 返回任务数据
            self :ACK_TASK_DATA( ackMsg )
            local command = CTaskDataUpdataCommand( msgID )
            controller :sendCommand( command )
            
            elseif msgID == _G.Protocol.ACK_TASK_REMOVE then            --3265 从列表中移除任务
            self :ACK_TASK_REMOVE( ackMsg )
            local command = CTaskDataUpdataCommand( msgID )
            controller :sendCommand( command )
            
            --local npcCommand = CNpcDataUpdateCommand( msgID)
            --controller :sendCommand( npcCommand)
        end
        
    end
    
end

--3265 从列表中移除任务
function CTaskNewDataMediator.ACK_TASK_REMOVE( self, _ackMsg)
    if _ackMsg == nil then
        return
    end
    print("移除任务id", _ackMsg :getId())
    print("[3265]从列表中移除任务 id->", _ackMsg :getId(), " 移除原因->", _ackMsg :getReason())
    --CCMessageBox("CTaskNewDataMediator.ACK_TASK_REMOVE", _ackMsg :getId())
    local _vo_data = {}
    _vo_data.id     = _ackMsg :getId()
    _vo_data.reason = _ackMsg :getReason()
    
    self :getView() :removeTaskByData( _vo_data)

    self : TaskEffectsCommandSend(2) --完成任务特效
    
    --local _guideCommand = CGuideTouchCammand( CGuideTouchCammand.TASK_FINISH, _vo_data.id )
    --controller:sendCommand(_guideCommand)
    
    --local roleProperty = _G.g_characterProperty : getMainPlay()
    --roleProperty :setTaskInfo()
    
    --清空该任务对应endnpc头上的图标
    local command = CNpcUpdateCommand( _ackMsg :getId() )
    _G.controller :sendCommand( command )
    
    _G.pCGuideManager:registGuide( _G.Constant.CONST_NEW_GUIDE_COMPLETE_TASK, _vo_data.id )
    _G.pCGuideManager:guideStart(_vo_data.id)
    
end

function CTaskNewDataMediator.TaskEffectsCommandSend(self,value)
    require "controller/TaskEffectsCommand"
    local TaskEffectsCommand = CTaskEffectsCommand(value) -- 1是接受任务 2是完成任务
    controller:sendCommand(TaskEffectsCommand)
end


---3220 返回任务数据
function CTaskNewDataMediator.ACK_TASK_DATA( self, _ackMsg )
    if _ackMsg == nil then
        --CCMessageBox( "发送任务数据为", _ackMsg)
        CCLOG("codeError!!!! 发送任务数据为".. _ackMsg)
        return
    end
    
    print("\n---3220 返回任务数据", _ackMsg :getId(), _ackMsg :getState(), _ackMsg :getTargetType())
    
    local taskDataList = {}
    taskDataList.id          = _ackMsg :getId()      --任务id
    taskDataList.state       = _ackMsg :getState()   --任务状态
    taskDataList.target_type = _ackMsg :getTargetType() --任务类型
    
    taskDataList.copy       = nil               --副本id
    taskDataList.current    = nil               --当前次数
    taskDataList.max        = nil               --最大次数
    
    taskDataList.monster_count  = nil           -- {怪物种数}
    taskDataList.monster_detail = nil           -- {怪物信息}
    
    local nType = tonumber( taskDataList.target_type)
    if nType == 1 then                     --对话任务
        CCLOG("1:完成对话任务解析")
        elseif nType == 2 then
        CCLOG("2:收集怪物")
        elseif nType == 3 then                 --击杀怪物
        CCLOG("3:击杀怪物")
        taskDataList.monster_count  = _ackMsg :getMonsterCount()           --击杀怪物种数
        taskDataList.monster_id     = _ackMsg :getMonsterDetail()          -- {怪物信息}
        
        elseif nType == 4 then
        CCLOG("4:击杀玩家")
        elseif nType == 5 then
        CCLOG("5:问答")
        elseif nType == 6 then                 --其他任务
        CCLOG("6:其他任务")
        elseif nType == 7 then                 --副本任务
        CCLOG("7;副本任务")
        
        taskDataList.copy       = _ackMsg :getCopy()
        taskDataList.current    = _ackMsg :getCurrent()
        taskDataList.max        = _ackMsg :getMax()
    end
    
    --开始初始化
    self :getView() :setInitialized( true )
    self :getView() :setTaskDataList( taskDataList )
    --self :getView() :setMainTask( taskDataList )
    
    --如果当前有追踪任务  更新它
    local mainTask = self :getView() :getMainTask()
    if mainTask ~= nil then
        if tonumber( mainTask.id ) ==  tonumber( taskDataList.id ) then
            self :getView() :setMainTask( taskDataList )
        end
    end
    
    --更新npc图标
    --local command = CNpcUpdateCommand( taskDataList )
    --_G.controller :sendCommand( command )
    --[[
     local testData = self :getView() :getTaskDataList()
     --self :getView() :setMainTask( testData )
     
     for k, v in pairs(  testData) do
     print("接收到的任务数据", k, v.id)
     local taskNode = self :getView() :getTaskDataById( v.id )
     print("taskNodetaskNode", taskNode)
     if taskNode ~= nil then
     --设置当前追踪任务
     local mainTask = self :getView() :getMainTask()
     print( "mainTask", mainTask)
     if mainTask == nil then
     self :getView() :setMainTask( v )
     mainTask = self :getView() :getMainTask()
     end
     print( "mainTask2", mainTask, taskNode.type , mainTask.type)
     
     if tonumber( mainTask.type ) > tonumber( taskNode.type ) then           --主线任务优先
     self :getView() :setMainTask( v )
     elseif tonumber( mainTask.type ) == tonumber( taskNode.type ) and mainTask.state < v.state then --同类型任务下，状态大优先
     self :getView() :setMainTask( v )
     end
     end
     
     for kk, vv in pairs( v) do
     print( kk, vv)
     end
     end
     
     --]]
    
    if taskDataList.state == _G.Constant.CONST_TASK_STATE_FINISHED then
        local _guideCommand = CGuideStepCammand( CGuideStepCammand.STEP_COPY_FULFILL, taskDataList.id )
        controller:sendCommand(_guideCommand)
    end
    
    --------------------------------------
    --[[
     local taskList = _ackMsg :getTaskList()
     
     if #taskList == 0 then
     --CCMessageBox("3220 返回没数据 #_ackMsg :getTaskList()==", #taskList)
        CCLOG("codeError!!!! 3220 返回没数据 #_ackMsg :getTaskList()=="..#taskList)
     end
     
     --开始初始化
     self :getView() :setInitialized( true)
     
     for k, v in pairs( taskList) do
     print(k, v.id, v.state, v.target_type)
     
     local taskNode = self :getView() :getTaskDataById( v.id)
     --if taskNode.type == "1" then       --设置主线id任务
     local mainTask = {}
     mainTask.id     = v.id
     mainTask.state  = v.state
     mainTask.target_type = v.target_type
     print("mainTask==", mainTask)
     self :getView()  :setMainTask( mainTask)
     --end
     
     end
     
     
     if self :getView()  :getInitialized() then
     self :getView()  :setTaskDataList( taskList)
     print("初始化成功,数据＝＝", self :getView() :getTaskDataList())
     
     local taskData = self :getView() :getTaskDataList()
     
     print("target_type==", taskData[1].target_type)
     for k, v in pairs(taskData) do
     print("taskData", k, v)
     end
     
     if taskData[1].target_type == 7 then
     local copyData = {}
     copyData.copy       = _ackMsg :getCopy()
     copyData.current    = _ackMsg :getCurrent()
     copyData.max        = _ackMsg :getMax()
     
     if copyData then
     self :getView() :setCopyList( copyData)
     end
     
     end
     
     end
     --]]
    
    
    
end











