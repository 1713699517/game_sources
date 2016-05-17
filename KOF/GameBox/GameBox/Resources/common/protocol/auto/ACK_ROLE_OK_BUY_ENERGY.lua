
require "common/AcknowledgementMessage"

-- [1267]购买精力成功 -- 角色 

ACK_ROLE_OK_BUY_ENERGY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_OK_BUY_ENERGY
	self:init()
end)
