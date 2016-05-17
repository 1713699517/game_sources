
require "common/AcknowledgementMessage"

-- [6520]技能数据 -- 技能/星阵图 

ACK_SKILL_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_DATA
	self:init()
end)

-- {数据}
function ACK_SKILL_DATA.getCount(self)
	return self.count
end

-- {技能ID}
function ACK_SKILL_DATA.getSkillId(self)
	return self.skill_id
end

-- {是否已学习0:否1:是}
function ACK_SKILL_DATA.getIsLevel(self)
	return self.is_level
end
