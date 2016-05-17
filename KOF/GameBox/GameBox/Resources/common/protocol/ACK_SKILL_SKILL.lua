
require "common/AcknowledgementMessage"

-- [6525]技能等级类型信息块 -- 技能系统 

ACK_SKILL_SKILL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_SKILL
	self:init()
end)

function ACK_SKILL_SKILL.deserialize(self, reader)
	self.lv_type = reader:readInt8Unsigned() -- {0:1级|1:20级别|2:50级别|3:70级}
	self.skill_one_id = reader:readInt32Unsigned() -- {技能一id}
	self.skill_two_id = reader:readInt32Unsigned() -- {技能二id}
	self.skill_three_id = reader:readInt32Unsigned() -- {技能三id}
end

-- {0:1级|1:20级别|2:50级别|3:70级}
function ACK_SKILL_SKILL.getLvType(self)
	return self.lv_type
end

-- {技能一id}
function ACK_SKILL_SKILL.getSkillOneId(self)
	return self.skill_one_id
end

-- {技能二id}
function ACK_SKILL_SKILL.getSkillTwoId(self)
	return self.skill_two_id
end

-- {技能三id}
function ACK_SKILL_SKILL.getSkillThreeId(self)
	return self.skill_three_id
end
