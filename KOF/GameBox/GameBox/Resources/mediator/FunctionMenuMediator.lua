--功能开放缓存的mediator

require "mediator/mediator"
require "controller/command"

require "common/MessageProtocol"
require "common/protocol/ACK_ROLE_SYS_ID"
require "controller/FunctionOpenCommand"

CFunctionMenuMediator = class( mediator, function( self, _view )
	self.m_name = "CFunctionMenuMediator"
	self.m_view = _view

	print("CFunctionMenuMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CFunctionMenuMediator.getView( self )
	-- body
	return self.m_view
end


function CFunctionMenuMediator.getName( self )
	return self.m_name
end


function CFunctionMenuMediator.processCommand( self, _command )

	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()

       
	end
    
    if _command :getType() == CFunctionOpenCommand.TYPE then
        CCLOG("打开右下角的功能按钮")
        if _command :getData() == CFunctionOpenCommand.UPDATE then
            if _G.g_Stage :getScenesType() == _G.Constant.CONST_MAP_TYPE_CITY then
                if _command :getData() == CFunctionOpenCommand.UPDATE then
                    --self :getView() :setMenuStatus( true )
                    self :getView() :setChatStatus()
                end
            end
        end
    end
end

