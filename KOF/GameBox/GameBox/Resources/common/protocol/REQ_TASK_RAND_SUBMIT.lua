
require "common/RequestMessage"

-- (手动) -- [3408]提交掷骰子任务 -- 任务 

REQ_TASK_RAND_SUBMIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TASK_RAND_SUBMIT
	self:init()
end)
