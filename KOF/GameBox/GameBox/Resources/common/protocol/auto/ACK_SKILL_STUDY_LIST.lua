
require "common/AcknowledgementMessage"

-- (手动) -- [6540]已经学习技能列表信息块 -- 技能系统 

ACK_SKILL_STUDY_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_STUDY_LIST
	self:init()
end)

function ACK_SKILL_STUDY_LIST.deserialize(self, reader)
	self.skill_id = reader:readInt32Unsigned() -- {技能id}
	self.now_lv = reader:readInt32Unsigned() -- {当前强化等级}
end

-- {技能id}
function ACK_SKILL_STUDY_LIST.getSkillId(self)
	return self.skill_id
end

-- {当前强化等级}
function ACK_SKILL_STUDY_LIST.getNowLv(self)
	return self.now_lv
end
