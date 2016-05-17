
require "common/RequestMessage"

-- [1265]购买体力 -- 角色 

REQ_ROLE_BUY_ENERGY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_BUY_ENERGY
	self:init(1 ,{ 1267,700 })
end)
