
require "common/RequestMessage"

-- [24010]清除CD时间 -- 逐鹿台 

REQ_ARENA_CLEAN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARENA_CLEAN
	self:init(1 ,{ 24020,700 })
end)
