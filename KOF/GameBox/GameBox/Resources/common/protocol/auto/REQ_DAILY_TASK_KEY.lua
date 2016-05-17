
require "common/RequestMessage"

-- [49207]一键完成日常任务 -- 日常任务系统 

REQ_DAILY_TASK_KEY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DAILY_TASK_KEY
	self:init(1 ,{ 49201,700 })
end)
