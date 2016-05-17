
require "common/AcknowledgementMessage"

-- [54808]各种倒计时 -- 格斗之王 

ACK_WRESTLE_TIME = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_TIME
	self:init()
end)

function ACK_WRESTLE_TIME.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {0:预赛进行中|2:决赛进行中|3：决赛结束,可以竞猜的状态|4：争霸赛进行中}
	self.start_time = reader:readInt32Unsigned() -- {开始时间（秒数）}
	self.end_time = reader:readInt32Unsigned() -- {结束时间（秒数）}
end

-- {0:预赛进行中|2:决赛进行中|3：决赛结束,可以竞猜的状态|4：争霸赛进行中}
function ACK_WRESTLE_TIME.getState(self)
	return self.state
end

-- {开始时间（秒数）}
function ACK_WRESTLE_TIME.getStartTime(self)
	return self.start_time
end

-- {结束时间（秒数）}
function ACK_WRESTLE_TIME.getEndTime(self)
	return self.end_time
end
