
require "common/RequestMessage"

-- (手动) -- [3404]请求放弃掷骰子任务 -- 任务 

REQ_TASK_RAND_DROP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TASK_RAND_DROP
	self:init()
end)
