
require "common/RequestMessage"

-- [5155]伙伴死亡 -- 场景 

REQ_SCENE_DIE_PARTNER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_DIE_PARTNER
	self:init(0, nil)
end)

function REQ_SCENE_DIE_PARTNER.serialize(self, writer)
	writer:writeInt32Unsigned(self.partner_id)  -- {伙伴ID}
end

function REQ_SCENE_DIE_PARTNER.setArguments(self,partner_id)
	self.partner_id = partner_id  -- {伙伴ID}
end

-- {伙伴ID}
function REQ_SCENE_DIE_PARTNER.setPartnerId(self, partner_id)
	self.partner_id = partner_id
end
function REQ_SCENE_DIE_PARTNER.getPartnerId(self)
	return self.partner_id
end
