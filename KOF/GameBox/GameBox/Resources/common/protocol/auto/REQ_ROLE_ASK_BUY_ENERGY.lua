
require "common/RequestMessage"

-- [1263]请求购买体力面板 -- 角色 

REQ_ROLE_ASK_BUY_ENERGY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ROLE_ASK_BUY_ENERGY
	self:init(1 ,{ 1264,700 })
end)
