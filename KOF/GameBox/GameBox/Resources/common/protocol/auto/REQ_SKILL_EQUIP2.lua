
require "common/RequestMessage"

-- (手动) -- [6540]装备技能 -- 技能系统 

REQ_SKILL_EQUIP2 = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_EQUIP2
	self:init()
end)

function REQ_SKILL_EQUIP2.serialize(self, writer)
	writer:writeInt16Unsigned(self.equip_pos)  -- {技能装备位置}
	writer:writeInt16Unsigned(self.skill_id)  -- {技能ID(0:卸载)}
end

function REQ_SKILL_EQUIP2.setArguments(self,equip_pos,skill_id)
	self.equip_pos = equip_pos  -- {技能装备位置}
	self.skill_id = skill_id  -- {技能ID(0:卸载)}
end

-- {技能装备位置}
function REQ_SKILL_EQUIP2.setEquipPos(self, equip_pos)
	self.equip_pos = equip_pos
end
function REQ_SKILL_EQUIP2.getEquipPos(self)
	return self.equip_pos
end

-- {技能ID(0:卸载)}
function REQ_SKILL_EQUIP2.setSkillId(self, skill_id)
	self.skill_id = skill_id
end
function REQ_SKILL_EQUIP2.getSkillId(self)
	return self.skill_id
end
