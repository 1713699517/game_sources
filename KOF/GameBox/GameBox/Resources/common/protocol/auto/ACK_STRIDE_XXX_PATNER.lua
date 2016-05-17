
require "common/AcknowledgementMessage"

-- [43552]伙伴块 -- 跨服战 

ACK_STRIDE_XXX_PATNER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_XXX_PATNER
	self:init()
end)

function ACK_STRIDE_XXX_PATNER.deserialize(self, reader)
	self.partner_id = reader:readInt32Unsigned() -- {伙伴ID}
end

-- {伙伴ID}
function ACK_STRIDE_XXX_PATNER.getPartnerId(self)
	return self.partner_id
end
