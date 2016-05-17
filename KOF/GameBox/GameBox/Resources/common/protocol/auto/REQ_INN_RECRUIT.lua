
require "common/RequestMessage"

-- (手动) -- [31150]招募伙伴 -- 客栈 

REQ_INN_RECRUIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_RECRUIT
	self:init()
end)

function REQ_INN_RECRUIT.serialize(self, writer)
	writer:writeInt16Unsigned(self.partner_id)  -- {招募伙伴ID}
end

function REQ_INN_RECRUIT.setArguments(self,partner_id)
	self.partner_id = partner_id  -- {招募伙伴ID}
end

-- {招募伙伴ID}
function REQ_INN_RECRUIT.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_INN_RECRUIT.getPartnerId(self)
	return self.partner_id
end
