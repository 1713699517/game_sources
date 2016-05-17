
require "common/RequestMessage"

-- [33220]请求学习帮派技能 -- 社团 

REQ_CLAN_STUDY_SKILL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_STUDY_SKILL
	self:init(0, nil)
end)

function REQ_CLAN_STUDY_SKILL.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {学习类型 接【33215】}
end

function REQ_CLAN_STUDY_SKILL.setArguments(self,type)
	self.type = type  -- {学习类型 接【33215】}
end

-- {学习类型 接【33215】}
function REQ_CLAN_STUDY_SKILL.setType(self, type)
	self.type = type
end
function REQ_CLAN_STUDY_SKILL.getType(self)
	return self.type
end
