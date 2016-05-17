
require "common/AcknowledgementMessage"

-- [6030]释放技能广播 -- 战斗 

ACK_WAR_SKILL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_SKILL
	self:init()
end)

function ACK_WAR_SKILL.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {种族类型见常量(CONST_)}
	self.uid = reader:readInt32Unsigned() -- {伙伴拥有者Uid}
	self.id = reader:readInt32Unsigned() -- {种类ID}
	self.skill_id = reader:readInt16Unsigned() -- {技能ID}
	self.skill_lv = reader:readInt8Unsigned() -- {技能等级}
end

-- {种族类型见常量(CONST_)}
function ACK_WAR_SKILL.getType(self)
	return self.type
end

-- {伙伴拥有者Uid}
function ACK_WAR_SKILL.getUid(self)
	return self.uid
end

-- {种类ID}
function ACK_WAR_SKILL.getId(self)
	return self.id
end

-- {技能ID}
function ACK_WAR_SKILL.getSkillId(self)
	return self.skill_id
end

-- {技能等级}
function ACK_WAR_SKILL.getSkillLv(self)
	return self.skill_lv
end
