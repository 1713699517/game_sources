
require "common/RequestMessage"

-- [30610]请求活跃度数据 -- 活动面板 

REQ_ACTIVITY_ASK_LINK_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ACTIVITY_ASK_LINK_DATA
	self:init(1 ,{ 30620,700 })
end)
