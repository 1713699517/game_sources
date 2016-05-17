
require "common/RequestMessage"

-- [23810]进入封神台 -- 逐鹿台 

REQ_ARENA_JOIN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARENA_JOIN
	self:init(1 ,{ 23820,700 })
end)
