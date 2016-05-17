
require "common/RequestMessage"

-- [44650]请求挑战伙伴 -- 阎王殿 

REQ_KINGHELL_ASK_PARTNER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_KINGHELL_ASK_PARTNER
	self:init(0, nil)
end)
