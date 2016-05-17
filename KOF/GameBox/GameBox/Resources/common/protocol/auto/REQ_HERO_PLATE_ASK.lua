
require "common/RequestMessage"

-- (手动) -- [39555]请求文牒 -- 英雄副本 

REQ_HERO_PLATE_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_PLATE_ASK
	self:init()
end)
