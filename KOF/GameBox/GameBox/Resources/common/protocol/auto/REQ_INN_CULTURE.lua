
require "common/RequestMessage"

-- (手动) -- [31130]培养伙伴 -- 客栈 

REQ_INN_CULTURE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_INN_CULTURE
	self:init()
end)

function REQ_INN_CULTURE.serialize(self, writer)
	writer:writeInt16Unsigned(self.partner_id)  -- {伙伴ID}
	writer:writeInt8Unsigned(self.type)  -- {1:元宝 0:银币}
end

function REQ_INN_CULTURE.setArguments(self,partner_id,type)
	self.partner_id = partner_id  -- {伙伴ID}
	self.type = type  -- {1:元宝 0:银币}
end

-- {伙伴ID}
function REQ_INN_CULTURE.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_INN_CULTURE.getPartnerId(self)
	return self.partner_id
end

-- {1:元宝 0:银币}
function REQ_INN_CULTURE.setType(self, type)
	self.type = type
end
function REQ_INN_CULTURE.getType(self)
	return self.type
end
