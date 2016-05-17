
require "common/AcknowledgementMessage"

-- (手动) -- [6620]返回该位置技能id -- 技能系统 

ACK_SKILL_SKILL_ID = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_SKILL_ID
	self:init()
end)

function ACK_SKILL_SKILL_ID.deserialize(self, reader)
    
	self.skill_id = reader:readInt32Unsigned() -- {技能id}
    print("ACK_SKILL_SKILL_ID=", self.skill_id)
end

-- {技能id}
function ACK_SKILL_SKILL_ID.getSkillId(self)
	return self.skill_id
end
