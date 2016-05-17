
require "common/RequestMessage"

-- [31170]伙伴出战 -- 客栈 

REQ_INN_WAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_WAR
	self:init(1 ,{ 31270,700 })
end)

function REQ_INN_WAR.serialize(self, writer)
	writer:writeInt16Unsigned(self.partner_id)  -- {伙伴ID}
end

function REQ_INN_WAR.setArguments(self,partner_id)
	self.partner_id = partner_id  -- {伙伴ID}
end

-- {伙伴ID}
function REQ_INN_WAR.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_INN_WAR.getPartnerId(self)
	return self.partner_id
end
