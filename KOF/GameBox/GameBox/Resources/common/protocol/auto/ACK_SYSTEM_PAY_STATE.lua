
require "common/AcknowledgementMessage"

-- [840]充值查询结果返回 -- 系统 

ACK_SYSTEM_PAY_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SYSTEM_PAY_STATE
	self:init()
end)

function ACK_SYSTEM_PAY_STATE.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {充值权限 ?CONST_FALSE 不可充值| ?CONST_TRUE 可充值}
end

-- {充值权限 ?CONST_FALSE 不可充值| ?CONST_TRUE 可充值}
function ACK_SYSTEM_PAY_STATE.getState(self)
	return self.state
end
