
require "common/AcknowledgementMessage"

-- (手动) -- [3215]清空客户端任务数据缓存 -- 任务 

ACK_TASK_CLEAR = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TASK_CLEAR
	self:init()
end)
