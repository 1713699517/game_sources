
require "common/AcknowledgementMessage"

-- [6530]技能信息 -- 技能系统 

ACK_SKILL_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_INFO
	self:init()
end)

function ACK_SKILL_INFO.deserialize(self, reader)
	self.skill_id = reader:readInt16Unsigned() -- {技能id}
	self.skill_lv = reader:readInt16Unsigned() -- {技能等级}
end

-- {技能id}
function ACK_SKILL_INFO.getSkillId(self)
	return self.skill_id
end

-- {技能等级}
function ACK_SKILL_INFO.getSkillLv(self)
	return self.skill_lv
end
