
require "common/RequestMessage"

-- (手动) -- [3670]选择上阵伙伴 -- 组队系统 

REQ_TEAM_CHOICE_PARTNER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_CHOICE_PARTNER
	self:init()
end)

function REQ_TEAM_CHOICE_PARTNER.serialize(self, writer)
	writer:writeInt32Unsigned(self.new_partner_id)  -- {新伙伴ID}
	writer:writeInt32Unsigned(self.old_partner_id)  -- {旧伙伴ID}
end

function REQ_TEAM_CHOICE_PARTNER.setArguments(self,new_partner_id,old_partner_id)
	self.new_partner_id = new_partner_id  -- {新伙伴ID}
	self.old_partner_id = old_partner_id  -- {旧伙伴ID}
end

-- {新伙伴ID}
function REQ_TEAM_CHOICE_PARTNER.setNewPartnerId(self, new_partner_id)
	self.new_partner_id = new_partner_id
end
function REQ_TEAM_CHOICE_PARTNER.getNewPartnerId(self)
	return self.new_partner_id
end

-- {旧伙伴ID}
function REQ_TEAM_CHOICE_PARTNER.setOldPartnerId(self, old_partner_id)
	self.old_partner_id = old_partner_id
end
function REQ_TEAM_CHOICE_PARTNER.getOldPartnerId(self)
	return self.old_partner_id
end
