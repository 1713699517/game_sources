
require "common/RequestMessage"

-- (手动) -- [39530]请求黑店购买记录 -- 英雄副本 

REQ_HERO_SHOP_HISTORY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_SHOP_HISTORY
	self:init()
end)
