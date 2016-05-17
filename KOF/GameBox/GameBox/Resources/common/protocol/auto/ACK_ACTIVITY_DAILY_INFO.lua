
require "common/AcknowledgementMessage"

-- (手动) -- [30560]日常活动信息快 -- 活动面板 

ACK_ACTIVITY_DAILY_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_DAILY_INFO
	self:init()
end)

function ACK_ACTIVITY_DAILY_INFO.deserialize(self, reader)
	self.id = reader:readInt16Unsigned() -- {活动ID}
	self.arg1 = reader:readInt32Unsigned() -- {参数1}
	self.arg2 = reader:readInt32Unsigned() -- {参数2}
end

-- {活动ID}
function ACK_ACTIVITY_DAILY_INFO.getId(self)
	return self.id
end

-- {参数1}
function ACK_ACTIVITY_DAILY_INFO.getArg1(self)
	return self.arg1
end

-- {参数2}
function ACK_ACTIVITY_DAILY_INFO.getArg2(self)
	return self.arg2
end
