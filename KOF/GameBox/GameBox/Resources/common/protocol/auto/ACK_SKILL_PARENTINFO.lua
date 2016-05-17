
require "common/AcknowledgementMessage"

-- [6560]伙伴技能信息 -- 技能系统 

ACK_SKILL_PARENTINFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_PARENTINFO
	self:init()
end)

function ACK_SKILL_PARENTINFO.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家uid|0:自己}
	self.parentid = reader:readInt32Unsigned() -- {伙伴id}
	self.skill_id = reader:readInt32Unsigned() -- {技能id}
	self.skill_lv = reader:readInt32Unsigned() -- {技能等级}
end

-- {玩家uid|0:自己}
function ACK_SKILL_PARENTINFO.getUid(self)
	return self.uid
end

-- {伙伴id}
function ACK_SKILL_PARENTINFO.getParentid(self)
	return self.parentid
end

-- {技能id}
function ACK_SKILL_PARENTINFO.getSkillId(self)
	return self.skill_id
end

-- {技能等级}
function ACK_SKILL_PARENTINFO.getSkillLv(self)
	return self.skill_lv
end
