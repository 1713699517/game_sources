
require "common/RequestMessage"

-- [10710]请求称号列表 -- 称号 

REQ_TITLE_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TITLE_REQUEST
	self:init(1 ,{ 10730，700 })
end)
