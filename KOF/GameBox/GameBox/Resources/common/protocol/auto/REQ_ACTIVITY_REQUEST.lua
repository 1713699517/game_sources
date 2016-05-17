
require "common/RequestMessage"

-- [30510]请求活动数据 -- 活动面板 

REQ_ACTIVITY_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ACTIVITY_REQUEST
	self:init(1 ,{ 30520,700 })
end)
