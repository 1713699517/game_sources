
require "common/AcknowledgementMessage"

-- [21165]阵营积分数据_新 -- 活动-保卫经书 

ACK_DEFEND_BOOK_CAMP_INTEGRAL_N = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_CAMP_INTEGRAL_N
	self:init()
end)

function ACK_DEFEND_BOOK_CAMP_INTEGRAL_N.deserialize(self, reader)
	self.camp_human = reader:readInt32Unsigned() -- {阵营积分--人}
	self.camp_god = reader:readInt32Unsigned() -- {阵营积分--仙}
	self.camp_devil = reader:readInt32Unsigned() -- {阵营积分--魔}
end

-- {阵营积分--人}
function ACK_DEFEND_BOOK_CAMP_INTEGRAL_N.getCampHuman(self)
	return self.camp_human
end

-- {阵营积分--仙}
function ACK_DEFEND_BOOK_CAMP_INTEGRAL_N.getCampGod(self)
	return self.camp_god
end

-- {阵营积分--魔}
function ACK_DEFEND_BOOK_CAMP_INTEGRAL_N.getCampDevil(self)
	return self.camp_devil
end
