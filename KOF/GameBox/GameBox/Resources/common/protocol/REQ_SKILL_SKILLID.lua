
require "common/RequestMessage"

-- [6530]请求技能id -- 技能系统 

REQ_SKILL_SKILLID = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_SKILLID
	self:init()
end)

function REQ_SKILL_SKILLID.serialize(self, writer)
	writer:writeInt32(self.skill_id)  -- {技能id}
end

function REQ_SKILL_SKILLID.setArguments(self,skill_id)
	self.skill_id = skill_id  -- {技能id}
end

-- {技能id}
function REQ_SKILL_SKILLID.setSkillId(self, skill_id)
	self.skill_id = skill_id
end
function REQ_SKILL_SKILLID.getSkillId(self)
	return self.skill_id
end
