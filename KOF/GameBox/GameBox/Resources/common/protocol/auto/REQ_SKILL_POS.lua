
require "common/RequestMessage"

-- (手动) -- [6610]单个技能位置信息 -- 技能系统 

REQ_SKILL_POS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKILL_POS
	self:init()
end)

function REQ_SKILL_POS.serialize(self, writer)
	writer:writeInt16Unsigned(self.pos)  -- {技能位置}
end

function REQ_SKILL_POS.setArguments(self,pos)
	self.pos = pos  -- {技能位置}
end

-- {技能位置}
function REQ_SKILL_POS.setPos(self, pos)
	self.pos = pos
end
function REQ_SKILL_POS.getPos(self)
	return self.pos
end
