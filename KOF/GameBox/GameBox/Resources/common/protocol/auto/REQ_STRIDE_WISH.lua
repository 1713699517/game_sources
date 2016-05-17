
require "common/RequestMessage"

-- [43560]许愿 -- 跨服战 

REQ_STRIDE_WISH = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_WISH
	self:init(0, nil)
end)
