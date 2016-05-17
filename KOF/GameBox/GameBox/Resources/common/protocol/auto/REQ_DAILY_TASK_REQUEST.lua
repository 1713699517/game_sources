
require "common/RequestMessage"

-- [49202]请求任务数据 -- 日常任务系统 

REQ_DAILY_TASK_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DAILY_TASK_REQUEST
	self:init(1 ,{ 49201,700,49206 })
end)
