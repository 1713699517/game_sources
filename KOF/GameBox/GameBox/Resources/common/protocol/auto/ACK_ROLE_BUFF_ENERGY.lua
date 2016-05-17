
require "common/AcknowledgementMessage"

-- [1262]额外赠送精力 -- 角色 

ACK_ROLE_BUFF_ENERGY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ROLE_BUFF_ENERGY
	self:init()
end)

function ACK_ROLE_BUFF_ENERGY.deserialize(self, reader)
	self.buff_value = reader:readInt32Unsigned() -- {buff值}
end

-- {buff值}
function ACK_ROLE_BUFF_ENERGY.getBuffValue(self)
	return self.buff_value
end
