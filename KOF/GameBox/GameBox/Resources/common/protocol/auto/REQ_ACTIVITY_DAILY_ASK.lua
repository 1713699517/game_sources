
require "common/RequestMessage"

-- (手动) -- [30550]请求日常活动次数数据 -- 活动面板 

REQ_ACTIVITY_DAILY_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ACTIVITY_DAILY_ASK
	self:init()
end)
