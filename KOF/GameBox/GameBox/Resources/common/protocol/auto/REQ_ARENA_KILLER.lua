
require "common/RequestMessage"

-- [23920]请求封神台排行榜 -- 逐鹿台 

REQ_ARENA_KILLER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARENA_KILLER
	self:init(1 ,{ 23930,700 })
end)
