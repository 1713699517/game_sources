
require "common/RequestMessage"

-- (手动) -- [39525]手动刷新黑店 -- 取经之路 

REQ_PILROAD_SHOP_FRESH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PILROAD_SHOP_FRESH
	self:init()
end)
