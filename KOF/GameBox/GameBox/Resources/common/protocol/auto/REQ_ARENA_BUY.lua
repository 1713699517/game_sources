
require "common/RequestMessage"

-- [23860]购买挑战次数 -- 逐鹿台 

REQ_ARENA_BUY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARENA_BUY
	self:init(1 ,{ 23870,700 })
end)
