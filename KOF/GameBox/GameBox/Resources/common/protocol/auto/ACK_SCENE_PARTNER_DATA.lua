
require "common/AcknowledgementMessage"

-- [5055]地图伙伴数据 -- 场景 

ACK_SCENE_PARTNER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SCENE_PARTNER_DATA
	self:init()
end)

function ACK_SCENE_PARTNER_DATA.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {所属玩家Uid}
	self.partner_id = reader:readInt16Unsigned() -- {伙伴ID}
	self.partner_lv = reader:readInt16Unsigned() -- {伙伴等级}
	self.team_id = reader:readInt32Unsigned() -- {队伍ID}
	self.hp_now = reader:readInt32Unsigned() -- {当前血量}
	self.hp_max = reader:readInt32Unsigned() -- {最大血量}
end

-- {所属玩家Uid}
function ACK_SCENE_PARTNER_DATA.getUid(self)
	return self.uid
end

-- {伙伴ID}
function ACK_SCENE_PARTNER_DATA.getPartnerId(self)
	return self.partner_id
end

-- {伙伴等级}
function ACK_SCENE_PARTNER_DATA.getPartnerLv(self)
	return self.partner_lv
end

-- {队伍ID}
function ACK_SCENE_PARTNER_DATA.getTeamId(self)
	return self.team_id
end

-- {当前血量}
function ACK_SCENE_PARTNER_DATA.getHpNow(self)
	return self.hp_now
end

-- {最大血量}
function ACK_SCENE_PARTNER_DATA.getHpMax(self)
	return self.hp_max
end
