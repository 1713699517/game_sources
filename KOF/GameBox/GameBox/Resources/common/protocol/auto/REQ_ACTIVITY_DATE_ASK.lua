
require "common/RequestMessage"

-- (手动) -- [30610]请求日期活动状态数据 -- 活动面板 

REQ_ACTIVITY_DATE_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ACTIVITY_DATE_ASK
	self:init()
end)
