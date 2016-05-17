require "mediator/mediator"
require "controller/command"

require "common/MessageProtocol"
require "model/VO_EmailModel"
require "controller/EmailCommand"

CEmailMediator = class( mediator, function( self, _view )
          self.m_name = "CEmailMediator"
          self.m_view = _view
          
          print("CEmailMediator注册", self.m_name, " 的view为 ", self.m_view)
          end)


function CEmailMediator.getView( self )
	-- body
	return self.m_view
end


function CEmailMediator.getName( self )
	return self.m_name
end


function CEmailMediator.processCommand( self, _command )
    
	if _command :getType() == CNetworkCommand.TYPE then
		local msgID     = _command :getProtocolID()
        local ackMsg    = _command :getAckMessage()
        
        --CCLOG("CEmailMediator.processCommand")
        if msgID == _G.Protocol["ACK_MAIL_LIST"] then           --请求列表成功 [8512]
        	self :ACK_MAIL_LIST( ackMsg)
            
                    
        elseif msgID == _G.Protocol["ACK_MAIL_OK_PICK"] then    -- 提取物品成功 [8552]
            self :ACK_MAIL_OK_PICK( ackMsg)

        elseif msgID == _G.Protocol["ACK_MAIL_OK_DEL"] then     --邮件移出 [8562]
            self :ACK_MAIL_OK_DEL( ackMsg)
        end
	end
     --elseif msgID == _G.Protocol["ACK_MAIL_OK_SEND"] then    -- (手动) -- [8532]发送邮件成功 -- 邮件\
    
    if _command :getType() == CEmailCommand.TYPE then
        if _command :getData() ~= nil then
            self :getView() :updateView( _command :getData())
        end
    end
    
    
    return false
end

function CEmailMediator.ACK_MAIL_LIST( self, _ackMsg )
	-- body
    print("CEmailMediator.ACK_MAIL_LIST", _ackMsg :getBoxtype())
	local vo_data = VO_EmailModel()

    --vo_data :setInited( true)       --开始初始化数据
    
	vo_data :setBoxtype( _ackMsg :getBoxtype())
	vo_data :setCount( _ackMsg :getCount())
	vo_data :setModels( _ackMsg :getModels())

	--当前界面更新数据
    if _ackMsg :getCount() >= 0 then
        self :getView() :pushData( vo_data)
    end 
	--通知,下发最新数据
	--local _msgCommand = CEmailUpdataCommand( vo_data)
	--controller :sendCommand( _msgCommand)

end

function CEmailMediator.ACK_MAIL_OK_PICK( self, _ackMsg)        --8552
    print("CEmailMediator.ACK_MAIL_OK_PICK 8552", _ackMsg :getCount())
    
    if _ackMsg :getCount() <= 0 then
        return
    end
    
    local vo_data = {}
    vo_data.count = _ackMsg :getCount()
    vo_data.id_msg = _ackMsg :getIdMsg()
    
    if vo_data == nil then
        return
    end
    self :getView() :setLabel( vo_data)
    
    local command = CEmailUpdataCommand( CEmailUpdataCommand.RECEIVE )
    controller :sendCommand( command)
end

function CEmailMediator.ACK_MAIL_OK_DEL( self, _ackMsg)
    print("CEmailMediator.ACK_MAIL_OK_DEL 8562(含8563)", _ackMsg: getCount())
    
    local vo_data = VO_EmailModel()

    vo_data :set8562Count( _ackMsg: getCount())
    
    if vo_data :get8562Count() >= 0 then
        vo_data :set8562Data( _ackMsg: getData())
        
        self :getView() :setDelView( vo_data)
    end
    
end













