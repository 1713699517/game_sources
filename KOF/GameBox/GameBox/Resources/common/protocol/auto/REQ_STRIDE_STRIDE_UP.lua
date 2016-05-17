
require "common/RequestMessage"

-- [43650]购买越级挑战 -- 跨服战 

REQ_STRIDE_STRIDE_UP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_STRIDE_UP
	self:init(0, nil)
end)
