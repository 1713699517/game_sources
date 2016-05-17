
require "common/AcknowledgementMessage"

-- [23832]封神台开始广播 -- 逐鹿台 

ACK_ARENA_STRAT = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_STRAT
	self:init()
end)
