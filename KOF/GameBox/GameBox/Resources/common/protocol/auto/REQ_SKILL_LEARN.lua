
require "common/RequestMessage"

-- [6525]升级技能 -- 技能系统 

REQ_SKILL_LEARN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_LEARN
	self:init(1 ,{ 6530,700,6545 })
end)

function REQ_SKILL_LEARN.serialize(self, writer)
	writer:writeInt32Unsigned(self.skill_id)  -- {技能id}
	writer:writeInt32Unsigned(self.lv)  -- {当前技能等级}
end

function REQ_SKILL_LEARN.setArguments(self,skill_id,lv)
	self.skill_id = skill_id  -- {技能id}
	self.lv = lv  -- {当前技能等级}
end

-- {技能id}
function REQ_SKILL_LEARN.setSkillId(self, skill_id)
	self.skill_id = skill_id
end
function REQ_SKILL_LEARN.getSkillId(self)
	return self.skill_id
end

-- {当前技能等级}
function REQ_SKILL_LEARN.setLv(self, lv)
	self.lv = lv
end
function REQ_SKILL_LEARN.getLv(self)
	return self.lv
end
