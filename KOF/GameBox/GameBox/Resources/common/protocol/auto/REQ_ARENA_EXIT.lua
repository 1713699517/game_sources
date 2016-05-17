
require "common/RequestMessage"

-- [23900]退出封神台 -- 逐鹿台 

REQ_ARENA_EXIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARENA_EXIT
	self:init(1 ,{ 23910,700 })
end)
