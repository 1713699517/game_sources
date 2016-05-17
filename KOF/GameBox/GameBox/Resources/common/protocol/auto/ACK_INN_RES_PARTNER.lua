
require "common/AcknowledgementMessage"

-- [31270]离队/归队结果 -- 客栈 

ACK_INN_RES_PARTNER = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_INN_RES_PARTNER
	self:init()
end)

function ACK_INN_RES_PARTNER.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {1:归队成功0:离队成功,2出战成功,3 休息成功 4 招募成功}
	self.partner_id = reader:readInt16Unsigned() -- {伙伴ID}
end

-- {1:归队成功0:离队成功,2出战成功,3 休息成功 4 招募成功}
function ACK_INN_RES_PARTNER.getType(self)
	return self.type
end

-- {伙伴ID}
function ACK_INN_RES_PARTNER.getPartnerId(self)
	return self.partner_id
end
