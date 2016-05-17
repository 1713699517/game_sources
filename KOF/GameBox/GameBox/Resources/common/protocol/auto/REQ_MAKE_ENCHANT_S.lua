
require "common/RequestMessage"

-- [2610]请求附魔 -- 物品/打造/强化 

REQ_MAKE_ENCHANT_S = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MAKE_ENCHANT_S
	self:init(1 ,{ 2620,700 })
end)
