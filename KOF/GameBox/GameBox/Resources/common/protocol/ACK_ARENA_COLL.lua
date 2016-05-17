
require "common/AcknowledgementMessage"

-- [23834]战斗数据 -- 封神台 

ACK_ARENA_COLL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_COLL
	self:init()
end)

-- {信息快6020}
function ACK_ARENA_COLL.getColl(self)
	return self.coll
end
