
require "common/AcknowledgementMessage"

-- [1150]返回角色任务已开放系统 -- 角色 

ACK_ROLE_SYS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_SYS
	self:init()
end)

-- {数量}
function ACK_ROLE_SYS.getCount(self)
	return self.count
end

-- {系统ID（见常量：CONST_SYS_TASK_ID_*）}
function ACK_ROLE_SYS.getTaskId(self)
	return self.task_id
end
