
require "common/RequestMessage"

-- [1310]请求VIP(自己) -- 角色 

REQ_ROLE_VIP_MY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_VIP_MY
	self:init(0, nil)
end)
