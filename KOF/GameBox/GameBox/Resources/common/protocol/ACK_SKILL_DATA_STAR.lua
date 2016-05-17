
require "common/AcknowledgementMessage"

-- [6540]返回数据 -- 技能/星阵图 

ACK_SKILL_DATA_STAR = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKILL_DATA_STAR
	self:init()
end)

-- {当前星魂值}
function ACK_SKILL_DATA_STAR.getStarValue(self)
	return self.star_value
end

-- {职业}
function ACK_SKILL_DATA_STAR.getPro(self)
	return self.pro
end

-- {数量}
function ACK_SKILL_DATA_STAR.getCount(self)
	return self.count
end

-- {星阵图等级}
function ACK_SKILL_DATA_STAR.getStarLv(self)
	return self.star_lv
end
