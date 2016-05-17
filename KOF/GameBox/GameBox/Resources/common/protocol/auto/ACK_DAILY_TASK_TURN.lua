
require "common/AcknowledgementMessage"

-- [49206]日常任务当前轮次 -- 日常任务系统 

ACK_DAILY_TASK_TURN = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DAILY_TASK_TURN
	self:init()
end)

function ACK_DAILY_TASK_TURN.deserialize(self, reader)
	self.turn = reader:readInt16Unsigned() -- {日常任务当前轮次}
end

-- {日常任务当前轮次}
function ACK_DAILY_TASK_TURN.getTurn(self)
	return self.turn
end
