
require "common/RequestMessage"

-- [31260]归队 -- 客栈 

REQ_INN_ENJOY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_ENJOY
	self:init(1 ,{ 31270,700 })
end)

function REQ_INN_ENJOY.serialize(self, writer)
	writer:writeInt16Unsigned(self.partner_id)  -- {伙伴ID}
end

function REQ_INN_ENJOY.setArguments(self,partner_id)
	self.partner_id = partner_id  -- {伙伴ID}
end

-- {伙伴ID}
function REQ_INN_ENJOY.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_INN_ENJOY.getPartnerId(self)
	return self.partner_id
end
