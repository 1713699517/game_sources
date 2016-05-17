
require "common/RequestMessage"

-- (手动) -- [6521]切换技能 -- 技能/星阵图 

REQ_SKILL_EQUIP_SWAP = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_EQUIP_SWAP
	self:init()
end)

function REQ_SKILL_EQUIP_SWAP.serialize(self, writer)
	writer:writeInt16Unsigned(self.skill_id)  -- {技能ID}
end

function REQ_SKILL_EQUIP_SWAP.setArguments(self,skill_id)
	self.skill_id = skill_id  -- {技能ID}
end

-- {技能ID}
function REQ_SKILL_EQUIP_SWAP.setSkillId(self, skill_id)
	self.skill_id = skill_id
end
function REQ_SKILL_EQUIP_SWAP.getSkillId(self)
	return self.skill_id
end
