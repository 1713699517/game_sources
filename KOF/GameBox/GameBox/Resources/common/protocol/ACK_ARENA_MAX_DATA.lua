
require "common/AcknowledgementMessage"

-- [23940]返回最竞技场信息(废除) -- 封神台 

ACK_ARENA_MAX_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_MAX_DATA
	self:init()
end)

-- {竞技场挑战结果信息}
function ACK_ARENA_MAX_DATA.getCount(self)
	return self.count
end

-- {信息块（23850）}
function ACK_ARENA_MAX_DATA.getData(self)
	return self.data
end
