
require "common/AcknowledgementMessage"

-- [6525]技能等级类型信息块 -- 技能系统 

ACK_SKILL_MSG_SKILL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_MSG_SKILL
	self:init()
end)

function ACK_SKILL_MSG_SKILL.deserialize(self, reader)
	self.lv_type = reader:readInt8Unsigned() -- {0:1级|1:20级别|2:50级别|3:70级}
	self.count = reader:readInt16Unsigned() -- {技能id数量}
	self.skill_id = reader:readInt32Unsigned() -- {技能id}
end

-- {0:1级|1:20级别|2:50级别|3:70级}
function ACK_SKILL_MSG_SKILL.getLvType(self)
	return self.lv_type
end

-- {技能id数量}
function ACK_SKILL_MSG_SKILL.getCount(self)
	return self.count
end

-- {技能id}
function ACK_SKILL_MSG_SKILL.getSkillId(self)
	return self.skill_id
end
