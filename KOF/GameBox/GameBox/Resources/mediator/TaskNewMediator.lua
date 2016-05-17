
require "mediator/mediator"
require "controller/command"
--require "proxy/TaskNewDataProxy"            
require "common/MessageProtocol"

CTaskNewMediator = class( mediator, function( self, _view)
    self.m_name  = "CTaskNewMediator"
    self.m_view  = _view

    print( "\n", self.m_name, " 的的view 为", self.m_view )
end)


function CTaskNewMediator.getName( self)
    return self.m_name
end


function CTaskNewMediator.getView( self)
    return self.m_view
end


function CTaskNewMediator.processCommand( self, _command)
    if _command: getType() == CNetworkCommand.TYPE then
        
    end
    
    
    if _command:getType() == CTaskDataUpdataCommand.TYPE then
        print("CTaskNewMediator.processCommand")
        if _command :getData() == _G.Protocol.ACK_TASK_DATA then
            self:getView() :setTaskNewView()
        end
    end

end



