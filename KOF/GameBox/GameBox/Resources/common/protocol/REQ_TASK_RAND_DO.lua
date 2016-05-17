
require "common/RequestMessage"

-- (手动) -- [3406]请求掷骰子 -- 任务 

REQ_TASK_RAND_DO = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TASK_RAND_DO
	self:init()
end)
