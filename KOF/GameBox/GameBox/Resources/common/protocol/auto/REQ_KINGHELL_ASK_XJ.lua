
require "common/RequestMessage"

-- [44670]请求伙伴心经列表 -- 阎王殿 

REQ_KINGHELL_ASK_XJ = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_KINGHELL_ASK_XJ
	self:init(0, nil)
end)
