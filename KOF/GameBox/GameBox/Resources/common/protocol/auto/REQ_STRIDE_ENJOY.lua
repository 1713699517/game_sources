
require "common/RequestMessage"

-- [43510]请求跨服战 -- 跨服战 

REQ_STRIDE_ENJOY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_ENJOY
	self:init(0, nil)
end)
