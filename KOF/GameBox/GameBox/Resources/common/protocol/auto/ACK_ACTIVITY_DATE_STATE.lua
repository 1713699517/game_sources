
require "common/AcknowledgementMessage"

-- (手动) -- [30600]日期开放活动状态通知 -- 活动面板 

ACK_ACTIVITY_DATE_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_DATE_STATE
	self:init()
end)

function ACK_ACTIVITY_DATE_STATE.deserialize(self, reader)
	self.id = reader:readInt16Unsigned() -- {活动ID}
	self.state = reader:readInt8Unsigned() -- {状态0:关闭|1:开启}
	self.lv = reader:readInt16Unsigned() -- {开发等级条件}
	self.all_time = reader:readInt32Unsigned() -- {活动总时间}
end

-- {活动ID}
function ACK_ACTIVITY_DATE_STATE.getId(self)
	return self.id
end

-- {状态0:关闭|1:开启}
function ACK_ACTIVITY_DATE_STATE.getState(self)
	return self.state
end

-- {开发等级条件}
function ACK_ACTIVITY_DATE_STATE.getLv(self)
	return self.lv
end

-- {活动总时间}
function ACK_ACTIVITY_DATE_STATE.getAllTime(self)
	return self.all_time
end
