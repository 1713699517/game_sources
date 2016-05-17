
require "common/RequestMessage"

-- (手动) -- [3410]快速完成掷骰子任务 -- 任务 

REQ_TASK_RAND_FINISH_FAST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TASK_RAND_FINISH_FAST
	self:init()
end)
