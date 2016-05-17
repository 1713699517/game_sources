
require "common/RequestMessage"

-- [49203]请求放弃任务 -- 日常任务系统 

REQ_DAILY_TASK_DROP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DAILY_TASK_DROP
	self:init(1 ,{ 49201,700 })
end)
