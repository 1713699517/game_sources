
require "common/RequestMessage"

-- [43590]请求招募伙伴界面 -- 跨服战 

REQ_STRIDE_PARTNER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_STRIDE_PARTNER
	self:init(0, nil)
end)
