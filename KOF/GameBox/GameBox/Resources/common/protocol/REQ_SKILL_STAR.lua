
require "common/RequestMessage"

-- (手动) -- [6550]点亮星阵图点 -- 技能/星阵图 

REQ_SKILL_STAR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_STAR
	self:init()
end)

function REQ_SKILL_STAR.serialize(self, writer)
	writer:writeInt16Unsigned(self.star_lv)  -- {星阵图等级}
end

function REQ_SKILL_STAR.setArguments(self,star_lv)
	self.star_lv = star_lv  -- {星阵图等级}
end

-- {星阵图等级}
function REQ_SKILL_STAR.setStarLv(self, star_lv)
	self.star_lv = star_lv
end
function REQ_SKILL_STAR.getStarLv(self)
	return self.star_lv
end
