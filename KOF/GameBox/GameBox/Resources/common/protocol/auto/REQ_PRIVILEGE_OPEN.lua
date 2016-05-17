
require "common/RequestMessage"

-- [53230]开通新手特权 -- 新手特权 

REQ_PRIVILEGE_OPEN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PRIVILEGE_OPEN
	self:init(0, nil)
end)
