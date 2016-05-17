
require "common/RequestMessage"

-- (手动) -- [39500]请求神秘黑店 -- 取经之路 

REQ_PILROAD_SHOP_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PILROAD_SHOP_ASK
	self:init()
end)
