
require "common/RequestMessage"

-- [49204]领取奖励协议 -- 日常任务系统 

REQ_DAILY_TASK_REWARD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DAILY_TASK_REWARD
	self:init(1 ,{ 49201,700 })
end)
