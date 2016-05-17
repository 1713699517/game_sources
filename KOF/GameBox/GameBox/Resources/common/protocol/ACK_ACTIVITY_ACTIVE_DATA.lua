
require "common/AcknowledgementMessage"

-- [30540]活动数据 -- 活动面板 

ACK_ACTIVITY_ACTIVE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_ACTIVE_DATA
	self:init()
end)

function ACK_ACTIVITY_ACTIVE_DATA.deserialize(self, reader)
	self.id         = reader:readInt16Unsigned() -- {活动ID}
	self.is_new     = reader:readInt8Unsigned()  -- {是否为新活动}
	self.start_time = reader:readInt32Unsigned() -- {开户时间}
	self.end_time   = reader:readInt32Unsigned() -- {结束时间}
	self.state      = reader:readInt8Unsigned()  -- {活动状态 4报名|3提前通知|2提前入场|1开启|0关闭|5进行中}
    print("活动数据,ID:"..self.id.."时间范围:"..self.start_time.."/"..self.end_time.."状态:"..self.state)
end

-- {数量}
function ACK_ACTIVITY_ACTIVE_DATA.getId(self)
	return self.id
end

-- {是否为新活动}
function ACK_ACTIVITY_ACTIVE_DATA.getIsNew(self)
	return self.is_new
end

-- {开户时间}
function ACK_ACTIVITY_ACTIVE_DATA.getStartTime(self)
	return self.start_time
end

-- {结束时间}
function ACK_ACTIVITY_ACTIVE_DATA.getEndTime(self)
	return self.end_time
end

-- {活动状态 4报名|3提前通知|2提前入场|1开启|0关闭|5进行中}
function ACK_ACTIVITY_ACTIVE_DATA.getState(self)
	return self.state
end
