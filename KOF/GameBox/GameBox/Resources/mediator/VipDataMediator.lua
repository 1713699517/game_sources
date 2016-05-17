--vip缓存
require "mediator/mediator"
require "controller/command"
require "model/VO_VipUIModel"
require "common/MessageProtocol"

CVipDataMediator = class( mediator, function( self, _view )
	self.m_name = "CVipDataMediator"
	self.m_view = _view

	print("CVipDataMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CVipDataMediator.getView( self )
	-- body
	return self.m_view
end


function CVipDataMediator.getName( self )
	return self.m_name
end


function CVipDataMediator.processCommand( self, _command )

	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()

        if msgID == _G.Protocol["ACK_ROLE_LV_MY"] then
            self :ACK_ROLE_LV_MY( ackMsg)
        end
	end
    
end


function CVipDataMediator.ACK_ROLE_LV_MY( self, _ackMsg )
    print("CVipMediator.ACK_ROLE_LV_MY", _ackMsg :getLv())
    if _ackMsg :getLv() or _ackMsg :getVipUp() then
        local vo_data = VO_VipUIModel()
        vo_data :setLv( _ackMsg :getLv())
        vo_data :setVipUp( _ackMsg :getVipUp())
        
        if vo_data then
            self :getView() :setServerView( vo_data)
        end
    end
end