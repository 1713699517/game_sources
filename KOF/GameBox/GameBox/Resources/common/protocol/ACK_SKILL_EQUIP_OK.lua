
require "common/AcknowledgementMessage"

-- (手动) -- [6522]切换成功 -- 技能/星阵图 

ACK_SKILL_EQUIP_OK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_EQUIP_OK
	self:init()
end)

function ACK_SKILL_EQUIP_OK.deserialize(self, reader)
	self.skill_id = reader:readInt16Unsigned() -- {技能ID}
end

-- {技能ID}
function ACK_SKILL_EQUIP_OK.getSkillId(self)
	return self.skill_id
end
