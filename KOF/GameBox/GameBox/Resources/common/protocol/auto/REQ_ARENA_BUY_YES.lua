
require "common/RequestMessage"

-- [23880]确定购买 -- 逐鹿台 

REQ_ARENA_BUY_YES = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARENA_BUY_YES
	self:init(1 ,{ 23890,700 })
end)
