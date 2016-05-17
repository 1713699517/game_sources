
require "common/RequestMessage"

-- [49205]vip刷新次数 -- 日常任务系统 

REQ_DAILY_TASK_VIP_REFRESH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DAILY_TASK_VIP_REFRESH
	self:init(1 ,{ 49201,700,49206 })
end)
