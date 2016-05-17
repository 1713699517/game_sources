
require "common/RequestMessage"

-- (手动) -- [39500]请求神秘黑店 -- 英雄副本 

REQ_HERO_SHOP_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_SHOP_ASK
	self:init()
end)
