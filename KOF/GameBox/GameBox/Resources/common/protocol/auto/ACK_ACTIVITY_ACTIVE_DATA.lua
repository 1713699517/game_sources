
require "common/AcknowledgementMessage"

-- [30540]活动数据 -- 活动面板 

ACK_ACTIVITY_ACTIVE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_ACTIVE_DATA
	self:init()
end)

function ACK_ACTIVITY_ACTIVE_DATA.deserialize(self, reader)
	self.id = reader:readInt16Unsigned() -- {id}
	self.is_new = reader:readInt8Unsigned() -- {是否为新活动}
	self.start_time = reader:readInt32Unsigned() -- {开启时间}
	self.end_time = reader:readInt32Unsigned() -- {结束时间}
	self.state = reader:readInt8Unsigned() -- {活动状态 |5未开始|4报名|1开启|0关闭}
end

-- {id}
function ACK_ACTIVITY_ACTIVE_DATA.getId(self)
	return self.id
end

-- {是否为新活动}
function ACK_ACTIVITY_ACTIVE_DATA.getIsNew(self)
	return self.is_new
end

-- {开启时间}
function ACK_ACTIVITY_ACTIVE_DATA.getStartTime(self)
	return self.start_time
end

-- {结束时间}
function ACK_ACTIVITY_ACTIVE_DATA.getEndTime(self)
	return self.end_time
end

-- {活动状态 |5未开始|4报名|1开启|0关闭}
function ACK_ACTIVITY_ACTIVE_DATA.getState(self)
	return self.state
end
