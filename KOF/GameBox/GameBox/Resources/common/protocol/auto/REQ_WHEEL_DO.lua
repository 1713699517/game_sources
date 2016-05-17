
require "common/RequestMessage"

-- [46030]请求玩转盘 -- 幸运大转盘 

REQ_WHEEL_DO = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WHEEL_DO
	self:init(0, nil)
end)
