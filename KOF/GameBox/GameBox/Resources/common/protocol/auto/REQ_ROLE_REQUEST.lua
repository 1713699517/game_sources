
require "common/RequestMessage"

-- [1331]请求签到面板 -- 角色 

REQ_ROLE_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_REQUEST
	self:init(0, nil)
end)
