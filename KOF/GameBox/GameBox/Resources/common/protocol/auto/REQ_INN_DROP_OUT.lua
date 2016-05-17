
require "common/RequestMessage"

-- [31250]离队 -- 客栈 

REQ_INN_DROP_OUT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_DROP_OUT
	self:init(1 ,{ 31270,700 })
end)

function REQ_INN_DROP_OUT.serialize(self, writer)
	writer:writeInt16Unsigned(self.partner_id)  -- {伙伴ID}
end

function REQ_INN_DROP_OUT.setArguments(self,partner_id)
	self.partner_id = partner_id  -- {伙伴ID}
end

-- {伙伴ID}
function REQ_INN_DROP_OUT.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_INN_DROP_OUT.getPartnerId(self)
	return self.partner_id
end
