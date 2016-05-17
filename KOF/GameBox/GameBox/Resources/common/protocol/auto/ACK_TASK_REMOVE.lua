
require "common/AcknowledgementMessage"

-- [3265]从列表中移除任务 -- 任务 

ACK_TASK_REMOVE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TASK_REMOVE
	self:init()
end)

function ACK_TASK_REMOVE.deserialize(self, reader)
	self.id = reader:readInt32Unsigned() -- {任务id}
	self.reason = reader:readInt8Unsigned() -- {任务移除原因（1：完成|2：放弃|）}
end

-- {任务id}
function ACK_TASK_REMOVE.getId(self)
	return self.id
end

-- {任务移除原因（1：完成|2：放弃|）}
function ACK_TASK_REMOVE.getReason(self)
	return self.reason
end
