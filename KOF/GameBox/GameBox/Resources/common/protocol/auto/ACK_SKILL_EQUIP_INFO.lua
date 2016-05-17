
require "common/AcknowledgementMessage"

-- [6545]装备技能信息 -- 技能系统 

ACK_SKILL_EQUIP_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_EQUIP_INFO
	self:init()
end)

function ACK_SKILL_EQUIP_INFO.deserialize(self, reader)
	self.equip_pos = reader:readInt16Unsigned() -- {技能装备位置}
	self.skill_id = reader:readInt32Unsigned() -- {技能ID(0:没装备)}
	self.skill_lv = reader:readInt16Unsigned() -- {技能Lv}
end

-- {技能装备位置}
function ACK_SKILL_EQUIP_INFO.getEquipPos(self)
	return self.equip_pos
end

-- {技能ID(0:没装备)}
function ACK_SKILL_EQUIP_INFO.getSkillId(self)
	return self.skill_id
end

-- {技能Lv}
function ACK_SKILL_EQUIP_INFO.getSkillLv(self)
	return self.skill_lv
end
