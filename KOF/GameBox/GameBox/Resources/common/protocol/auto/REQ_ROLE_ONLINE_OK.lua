
require "common/RequestMessage"

-- [1350]领取 -- 角色 

REQ_ROLE_ONLINE_OK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_ONLINE_OK
	self:init(0, nil)
end)
