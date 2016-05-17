
require "common/AcknowledgementMessage"

-- [1160]角色任务开放系统 -- 角色 

ACK_ROLE_OPEN_SYS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_OPEN_SYS
	self:init()
end)

function ACK_ROLE_OPEN_SYS.deserialize(self, reader)
	self.task_id = reader:readInt32Unsigned() -- {任务ID（见常量：CONST_SYS_TASK_ID_*）}
end

-- {任务ID（见常量：CONST_SYS_TASK_ID_*）}
function ACK_ROLE_OPEN_SYS.getTaskId(self)
	return self.task_id
end
