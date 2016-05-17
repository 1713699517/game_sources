
require "common/RequestMessage"

-- [44720]请求阎王元神 -- 阎王殿 

REQ_KINGHELL_ASK_YUANS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_KINGHELL_ASK_YUANS
	self:init(0, nil)
end)
