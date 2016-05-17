
require "common/RequestMessage"

-- [57801]请求面板 -- 宝箱探秘 

REQ_DISCOVE_STORE_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DISCOVE_STORE_ASK
	self:init(0, nil)
end)
