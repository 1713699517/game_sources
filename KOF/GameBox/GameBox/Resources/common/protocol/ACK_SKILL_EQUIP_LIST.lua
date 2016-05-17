
require "common/AcknowledgementMessage"

-- [6548]装备技能信息列表 -- 技能系统 

ACK_SKILL_EQUIP_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_EQUIP_LIST
	self:init()
end)

function ACK_SKILL_EQUIP_LIST.deserialize(self, reader)
	self.skill_id = reader:readInt32Unsigned() -- {技能id}
	self.skill_pos = reader:readInt8Unsigned() -- {装备位置}
end

-- {技能id}
function ACK_SKILL_EQUIP_LIST.getSkillId(self)
	return self.skill_id
end

-- {装备位置}
function ACK_SKILL_EQUIP_LIST.getSkillPos(self)
	return self.skill_pos
end
