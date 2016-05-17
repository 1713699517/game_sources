
require "common/RequestMessage"

-- [1260]请求体力值 -- 角色 

REQ_ROLE_ENERGY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_ENERGY
	self:init(1 ,{ 1261,1262,700 })
end)
