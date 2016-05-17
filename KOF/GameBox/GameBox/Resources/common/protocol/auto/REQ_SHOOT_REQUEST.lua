
require "common/RequestMessage"

-- [51210]请求每日一箭面板 -- 每日一箭 

REQ_SHOOT_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SHOOT_REQUEST
	self:init(1 ,{ 51220,700 })
end)
