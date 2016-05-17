
require "common/AcknowledgementMessage"

-- (手动) -- [1252]购买成功 -- 角色 

ACK_ROLE_BUY_SP_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_BUY_SP_OK
	self:init()
end)
