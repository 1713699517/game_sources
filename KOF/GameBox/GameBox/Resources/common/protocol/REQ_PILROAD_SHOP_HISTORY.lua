
require "common/RequestMessage"

-- (手动) -- [39530]请求黑店购买记录 -- 取经之路 

REQ_PILROAD_SHOP_HISTORY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PILROAD_SHOP_HISTORY
	self:init()
end)
