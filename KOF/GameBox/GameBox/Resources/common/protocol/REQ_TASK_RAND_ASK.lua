
require "common/RequestMessage"

-- (手动) -- [3400]请求掷骰子任务数据 -- 任务 

REQ_TASK_RAND_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TASK_RAND_ASK
	self:init()
end)
