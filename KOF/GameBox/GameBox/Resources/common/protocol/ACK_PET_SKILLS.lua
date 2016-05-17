
require "common/AcknowledgementMessage"

-- [22825]技能信息块 -- 宠物 

ACK_PET_SKILLS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PET_SKILLS
	self:init()
end)

function ACK_PET_SKILLS.deserialize(self, reader)
	self.count = reader:readInt16Unsigned() -- {已开通技能数量}
	self.skill_id = reader:readInt16Unsigned() -- {已开通技能id}
end

-- {已开通技能数量}
function ACK_PET_SKILLS.getCount(self)
	return self.count
end

-- {已开通技能id}
function ACK_PET_SKILLS.getSkillId(self)
	return self.skill_id
end
