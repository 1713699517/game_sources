require "mediator/mediator"
require "controller/command"
require "common/MessageProtocol"
require "controller/TaskDialogCommand"
require "controller/TaskNewDataCommand"

CTaskDialogMediator = class( mediator, function( self, _view)
    self.m_name  = "CTaskDialogMediator"
    self.m_view  = _view

    print( "\n", self.m_name, " 的的view 为", self.m_view )
end)


function CTaskDialogMediator.getName( self)
    return self.m_name
end


function CTaskDialogMediator.getView( self)
    return self.m_view
end


function CTaskDialogMediator.processCommand( self, _command)
    if _command: getType() == CNetworkCommand.TYPE then
        local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()
        
    end
    
    if _command :getType() == CTaskDataUpdataCommand.TYPE then
        print("CTaskDialogMediator.processCommand", _command :getData())
        if _command :getData() == _G.Protocol.ACK_TASK_DATA then
            --CCMessageBox("务数据更新", "任务数据更新")
            self :getView() :setUpdateView( )
        end
    end
    
    if _command :getType() == CTaskDialogUpdateCommand.TYPE then
       CCLOG( "CTaskDialogMediator.processCommand--> ".._command :getData() )
        if _command :getData() == CTaskDialogUpdateCommand.GOTO_SHOPPING  then
           -- CCMessageBox("去商城", _command :getData())
            CCLOG("去商城")
            
        elseif _command :getData() == CTaskDialogUpdateCommand.GOTO_HOUSE  then
            --CCMessageBox("去客栈", _command :getData())
            CCLOG("去客栈")
                    elseif _command :getData() == CTaskDialogUpdateCommand.GOTO_TASK  then
            --CCMessageBox("去任务", _command :getData())
            CCLOG("去任务")
        end
    end
end

--[[
 CTaskDialogUpdateCommand.GOTO_SHOPPING  = "goto_shopping"           --去商城
 CTaskDialogUpdateCommand.GOTO_HOUSE     = "goto_house"              --去客栈
 CTaskDialogUpdateCommand.GOTO_TASK      = "goto_task"               --去任务
 ]]
