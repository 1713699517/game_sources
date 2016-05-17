
require "common/AcknowledgementMessage"

-- [33315]帮派活动面板数据块 -- 社团 

ACK_CLAN_ACTIVE_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_ACTIVE_MSG
	self:init()
end)

function ACK_CLAN_ACTIVE_MSG.deserialize(self, reader)
	self.active_id = reader:readInt16Unsigned() -- {活动ID}
	self.limite_clanlv = reader:readInt8Unsigned() -- {帮派等级限制}
	self.times = reader:readInt8Unsigned() -- {已使用次数}
	self.all_times = reader:readInt8Unsigned() -- {总计可使用次数}
	self.state = reader:readInt8Unsigned() -- {活动状态 0待开| 1已开| 2结束}
end

-- {活动ID}
function ACK_CLAN_ACTIVE_MSG.getActiveId(self)
	return self.active_id
end

-- {帮派等级限制}
function ACK_CLAN_ACTIVE_MSG.getLimiteClanlv(self)
	return self.limite_clanlv
end

-- {已使用次数}
function ACK_CLAN_ACTIVE_MSG.getTimes(self)
	return self.times
end

-- {总计可使用次数}
function ACK_CLAN_ACTIVE_MSG.getAllTimes(self)
	return self.all_times
end

-- {活动状态 0待开| 1已开| 2结束}
function ACK_CLAN_ACTIVE_MSG.getState(self)
	return self.state
end
