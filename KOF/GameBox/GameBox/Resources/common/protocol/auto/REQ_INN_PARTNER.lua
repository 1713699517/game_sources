
require "common/RequestMessage"

-- (手动) -- [31170]进入客栈请求伙伴列表 -- 客栈 

REQ_INN_PARTNER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_PARTNER
	self:init()
end)
