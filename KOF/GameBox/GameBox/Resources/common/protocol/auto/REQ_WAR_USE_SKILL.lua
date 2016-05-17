
require "common/RequestMessage"

-- [6040]释放技能 -- 战斗 

REQ_WAR_USE_SKILL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_USE_SKILL
	self:init(0, nil)
end)

function REQ_WAR_USE_SKILL.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {种族类型见常量(CONST_)}
	writer:writeInt32Unsigned(self.id)  -- {玩家/伙伴ID}
	writer:writeInt16Unsigned(self.skill_id)  -- {技能ID}
	writer:writeInt8Unsigned(self.skill_lv)  -- {技能等级}
end

function REQ_WAR_USE_SKILL.setArguments(self,type,id,skill_id,skill_lv)
	self.type = type  -- {种族类型见常量(CONST_)}
	self.id = id  -- {玩家/伙伴ID}
	self.skill_id = skill_id  -- {技能ID}
	self.skill_lv = skill_lv  -- {技能等级}
end

-- {种族类型见常量(CONST_)}
function REQ_WAR_USE_SKILL.setType(self, type)
	self.type = type
end
function REQ_WAR_USE_SKILL.getType(self)
	return self.type
end

-- {玩家/伙伴ID}
function REQ_WAR_USE_SKILL.setId(self, id)
	self.id = id
end
function REQ_WAR_USE_SKILL.getId(self)
	return self.id
end

-- {技能ID}
function REQ_WAR_USE_SKILL.setSkillId(self, skill_id)
	self.skill_id = skill_id
end
function REQ_WAR_USE_SKILL.getSkillId(self)
	return self.skill_id
end

-- {技能等级}
function REQ_WAR_USE_SKILL.setSkillLv(self, skill_lv)
	self.skill_lv = skill_lv
end
function REQ_WAR_USE_SKILL.getSkillLv(self)
	return self.skill_lv
end
