
require "common/RequestMessage"

-- [43511]请求巅峰之战 -- 跨服战 

REQ_STRIDE_SUPERIOR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_SUPERIOR
	self:init(0, nil)
end)
