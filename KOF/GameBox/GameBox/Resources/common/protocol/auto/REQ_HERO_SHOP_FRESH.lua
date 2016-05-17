
require "common/RequestMessage"

-- (手动) -- [39525]手动刷新黑店 -- 英雄副本 

REQ_HERO_SHOP_FRESH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_SHOP_FRESH
	self:init()
end)
