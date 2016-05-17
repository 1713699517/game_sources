
require "common/RequestMessage"

-- [31180]伙伴出战休息 -- 客栈 

REQ_INN_NTE_WAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_NTE_WAR
	self:init(1 ,{ 31270,700 })
end)

function REQ_INN_NTE_WAR.serialize(self, writer)
	writer:writeInt16Unsigned(self.partner_id)  -- {伙伴ID}
end

function REQ_INN_NTE_WAR.setArguments(self,partner_id)
	self.partner_id = partner_id  -- {伙伴ID}
end

-- {伙伴ID}
function REQ_INN_NTE_WAR.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_INN_NTE_WAR.getPartnerId(self)
	return self.partner_id
end
