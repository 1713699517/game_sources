
require "common/AcknowledgementMessage"

-- [21160]阵营积分数据 -- 活动-保卫经书 

ACK_DEFEND_BOOK_CAMP_INTEGRAL = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_CAMP_INTEGRAL
	self:init()
end)

function ACK_DEFEND_BOOK_CAMP_INTEGRAL.deserialize(self, reader)
	self.camp_human = reader:readInt16Unsigned() -- {阵营积分--人}
	self.camp_god = reader:readInt16Unsigned() -- {阵营积分--仙}
	self.camp_devil = reader:readInt16Unsigned() -- {阵营积分--魔}
end

-- {阵营积分--人}
function ACK_DEFEND_BOOK_CAMP_INTEGRAL.getCampHuman(self)
	return self.camp_human
end

-- {阵营积分--仙}
function ACK_DEFEND_BOOK_CAMP_INTEGRAL.getCampGod(self)
	return self.camp_god
end

-- {阵营积分--魔}
function ACK_DEFEND_BOOK_CAMP_INTEGRAL.getCampDevil(self)
	return self.camp_devil
end
