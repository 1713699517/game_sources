
require "common/RequestMessage"

-- [830]查询是否可充值 -- 系统 

REQ_SYSTEM_PAY_CHECK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYSTEM_PAY_CHECK
	self:init(0.5 ,{ 840,700 })
end)
