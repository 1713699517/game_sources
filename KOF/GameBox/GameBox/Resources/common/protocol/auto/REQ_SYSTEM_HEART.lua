
require "common/RequestMessage"

-- [501]角色心跳 -- 系统 

REQ_SYSTEM_HEART = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SYSTEM_HEART
	self:init(0, nil)
end)
