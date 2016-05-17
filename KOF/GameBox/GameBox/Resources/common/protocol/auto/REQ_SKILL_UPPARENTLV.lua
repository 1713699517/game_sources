
require "common/RequestMessage"

-- [6555]请求学习技能 -- 技能系统 

REQ_SKILL_UPPARENTLV = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_UPPARENTLV
	self:init(1 ,{ 6560,700 })
end)

function REQ_SKILL_UPPARENTLV.serialize(self, writer)
	writer:writeInt32Unsigned(self.parentid)  -- {伙伴id}
	writer:writeInt32Unsigned(self.skill_id)  -- {技能id}
	writer:writeInt32Unsigned(self.lv)  -- {当前技能等级}
end

function REQ_SKILL_UPPARENTLV.setArguments(self,parentid,skill_id,lv)
	self.parentid = parentid  -- {伙伴id}
	self.skill_id = skill_id  -- {技能id}
	self.lv = lv  -- {当前技能等级}
end

-- {伙伴id}
function REQ_SKILL_UPPARENTLV.setParentid(self, parentid)
	self.parentid = parentid
end
function REQ_SKILL_UPPARENTLV.getParentid(self)
	return self.parentid
end

-- {技能id}
function REQ_SKILL_UPPARENTLV.setSkillId(self, skill_id)
	self.skill_id = skill_id
end
function REQ_SKILL_UPPARENTLV.getSkillId(self)
	return self.skill_id
end

-- {当前技能等级}
function REQ_SKILL_UPPARENTLV.setLv(self, lv)
	self.lv = lv
end
function REQ_SKILL_UPPARENTLV.getLv(self)
	return self.lv
end
