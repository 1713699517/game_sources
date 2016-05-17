
require "common/RequestMessage"

-- [6590]请求单个技能信息 -- 技能系统 

REQ_SKILL_ID_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_ID_REQUEST
	self:init()
end)

function REQ_SKILL_ID_REQUEST.serialize(self, writer)
	writer:writeInt32Unsigned(self.skill_id)  -- {技能id}
end

function REQ_SKILL_ID_REQUEST.setArguments(self,skill_id)
	self.skill_id = skill_id  -- {技能id}
end

-- {技能id}
function REQ_SKILL_ID_REQUEST.setSkillId(self, skill_id)
	self.skill_id = skill_id
end
function REQ_SKILL_ID_REQUEST.getSkillId(self)
	return self.skill_id
end
