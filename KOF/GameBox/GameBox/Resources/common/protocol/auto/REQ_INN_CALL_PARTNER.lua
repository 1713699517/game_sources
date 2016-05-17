
require "common/RequestMessage"

-- [31150]招募伙伴 -- 客栈 

REQ_INN_CALL_PARTNER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_CALL_PARTNER
	self:init(1 ,{ 31270,700 })
end)

function REQ_INN_CALL_PARTNER.serialize(self, writer)
	writer:writeInt16Unsigned(self.partner_id)  -- {伙伴ID}
end

function REQ_INN_CALL_PARTNER.setArguments(self,partner_id)
	self.partner_id = partner_id  -- {伙伴ID}
end

-- {伙伴ID}
function REQ_INN_CALL_PARTNER.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_INN_CALL_PARTNER.getPartnerId(self)
	return self.partner_id
end
