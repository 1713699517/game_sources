
require "common/RequestMessage"

-- (手动) -- [3715]队伍阵型交换阵位 -- 组队系统 

REQ_TEAM_SWITCH_ARRAY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_SWITCH_ARRAY
	self:init()
end)

function REQ_TEAM_SWITCH_ARRAY.serialize(self, writer)
	writer:writeInt8Unsigned(self.fpartner_idx)  -- {交换伙伴索引}
	writer:writeInt8Unsigned(self.partner_idx)  -- {被交换伙伴索引}
end

function REQ_TEAM_SWITCH_ARRAY.setArguments(self,fpartner_idx,partner_idx)
	self.fpartner_idx = fpartner_idx  -- {交换伙伴索引}
	self.partner_idx = partner_idx  -- {被交换伙伴索引}
end

-- {交换伙伴索引}
function REQ_TEAM_SWITCH_ARRAY.setFpartnerIdx(self, fpartner_idx)
	self.fpartner_idx = fpartner_idx
end
function REQ_TEAM_SWITCH_ARRAY.getFpartnerIdx(self)
	return self.fpartner_idx
end

-- {被交换伙伴索引}
function REQ_TEAM_SWITCH_ARRAY.setPartnerIdx(self, partner_idx)
	self.partner_idx = partner_idx
end
function REQ_TEAM_SWITCH_ARRAY.getPartnerIdx(self)
	return self.partner_idx
end
