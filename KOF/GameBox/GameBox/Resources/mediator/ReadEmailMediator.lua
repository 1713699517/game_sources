require "mediator/mediator"
require "controller/command"

require "common/MessageProtocol"
require "model/VO_EmailModel"
require "controller/EmailCommand"

CReadEmailMediator = class( mediator, function( self, _view )
	self.m_name = "CReadEmailMediator"
	self.m_view = _view

	print("CReadEmailMediator注册", self.m_name, " 的view为 ", self.m_view)
end)


function CReadEmailMediator.getView( self )
	-- body
	return self.m_view
end


function CReadEmailMediator.getName( self )
	return self.m_name
end


function CReadEmailMediator.processCommand( self, _command )
    print("CReadEmailMediator.processCommand", _command :getType())
	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()

        --CCLOG("CReadEmailMediator.processCommand")
        if msgID == _G.Protocol["ACK_MAIL_INFO"] then
            self :ACK_MAIL_INFO( ackMsg)
            
        end
        
	end

    if _command :getType() == CEmailUpdataCommand.TYPE then
        if _command :getData() == CEmailUpdataCommand.RECEIVE then
            
            self :getView() :setReceiveView( _G.Constant.CONST_MAIL_ACCESSORY_YES)
        end
    end
	--判断需要处理的type self:getView()
end

function CReadEmailMediator.ACK_MAIL_INFO( self, _ackMsg)
    print("CReadEmailMediator.ACK_MAIL_INFO", _ackMsg :getMailId())
    
    local vo_data = VO_EmailModel()
    
    vo_data :setMailId( _ackMsg :getMailId())
    vo_data :setSendUid( _ackMsg :getSendUid())
    vo_data :setState( _ackMsg :getState())
    vo_data :setPick( _ackMsg :getPick())
    vo_data :setContent( _ackMsg :getContent())
    vo_data :setCountV( _ackMsg :getCountV())
    vo_data :setVgoodsMsg( _ackMsg :getVgoodsMsg())
    vo_data :setCountU( _ackMsg :getCountU())
    vo_data :setUgoodsMsg( _ackMsg :getUgoodsMsg())
    
    -- self:getView()
    self :getView() :pushData( vo_data)
    
    local command = CEmailCommand( _ackMsg :getMailId())
    controller :sendCommand( command)
    
    -- 通知
end



