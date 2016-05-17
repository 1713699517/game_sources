require "mediator/mediator"
require "common/MessageProtocol"
require "controller/PayCheckCommand"
require "proxy/PayCheckProxy"

CPayCheckMediator = class(mediator, function(self, _view)
	self.name = "CPayCheckMediator"
	self.view = _view
end)

function CPayCheckMediator.getView(self)
	return self.view
end

function CPayCheckMediator.processCommand( self, _command )
	if _command:getType() == CNetworkCommand.TYPE then
		local msgID  = _command:getProtocolID()
		local ackMsg = _command:getAckMessage()

		if msgID == _G.Protocol["ACK_SYSTEM_PAY_STATE"] then
            self :ACK_SYSTEM_PAY_STATE( ackMsg )
			return false
		end

	end
    
    if CPayCheckCommand.TYPE == _command :getType() then
        if _command :getData() == CPayCheckCommand.ASK then
            self :request()
        end
    end
	return false
end

function CPayCheckMediator.ACK_SYSTEM_PAY_STATE( self, _ackMsg)
    -- {充值权限 ?CONST_FALSE 0 不可充值| ?CONST_TRUE 可充值 1}
    print("_ackMsg_ackMsg", _ackMsg:getState())
    if _ackMsg :getState() == _G.Constant.CONST_FALSE then
        --CCMessageBox("不可充值", _ackMsg :getState())
    elseif _ackMsg :getState() == _G.Constant.CONST_TRUE then
        CRechargeScene:setRechargeData("isFirst","FALSE")
        self :getView() :pushRechargeTips()
    elseif _ackMsg :getState() == 2 then
        --首次充值
        CRechargeScene:setRechargeData("isFirst","TRUE")
        self :getView() :pushRechargeTips()
    end
    
end

function CPayCheckMediator.request( self )
    require "common/protocol/auto/REQ_SYSTEM_PAY_CHECK"
    local msg = REQ_SYSTEM_PAY_CHECK()
    CNetwork :send( msg )
    print("查询是否可充值")
end