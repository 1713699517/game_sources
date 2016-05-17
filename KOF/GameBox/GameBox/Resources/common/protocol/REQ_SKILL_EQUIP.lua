
require "common/RequestMessage"

-- [6540]装备技能 -- 技能系统 

REQ_SKILL_EQUIP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_EQUIP
	self:init()
end)

function REQ_SKILL_EQUIP.serialize(self, writer)
	writer:writeInt16Unsigned(self.equip_pos)  -- {技能装备位置}
	writer:writeInt32Unsigned(self.skill_id)  -- {技能ID(0:卸载)}
end

function REQ_SKILL_EQUIP.setArguments(self,equip_pos,skill_id)
	self.equip_pos = equip_pos  -- {技能装备位置}
	self.skill_id = skill_id  -- {技能ID(0:卸载)}
end

-- {技能装备位置}
function REQ_SKILL_EQUIP.setEquipPos(self, equip_pos)
	self.equip_pos = equip_pos
end
function REQ_SKILL_EQUIP.getEquipPos(self)
	return self.equip_pos
end

-- {技能ID(0:卸载)}
function REQ_SKILL_EQUIP.setSkillId(self, skill_id)
	self.skill_id = skill_id
end
function REQ_SKILL_EQUIP.getSkillId(self)
	return self.skill_id
end
