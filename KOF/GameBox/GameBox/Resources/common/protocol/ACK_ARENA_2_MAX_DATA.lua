
require "common/AcknowledgementMessage"

-- [23941]最新封神台战报(新) -- 封神台 

ACK_ARENA_2_MAX_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_2_MAX_DATA
	self:init()
end)

-- {数量}
function ACK_ARENA_2_MAX_DATA.getCount(self)
	return self.count
end

-- {信息块（23851）}
function ACK_ARENA_2_MAX_DATA.getData(self)
	return self.data
end
