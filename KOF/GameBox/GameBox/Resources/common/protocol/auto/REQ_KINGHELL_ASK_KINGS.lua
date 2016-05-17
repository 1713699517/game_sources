
require "common/RequestMessage"

-- [44610]请求阎王列表 -- 阎王殿 

REQ_KINGHELL_ASK_KINGS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_KINGHELL_ASK_KINGS
	self:init(0, nil)
end)
