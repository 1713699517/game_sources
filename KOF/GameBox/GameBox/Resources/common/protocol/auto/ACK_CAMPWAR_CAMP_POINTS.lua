
require "common/AcknowledgementMessage"

-- [45640]阵营积分数据 -- 活动-阵营战 

ACK_CAMPWAR_CAMP_POINTS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_CAMP_POINTS
	self:init()
end)

function ACK_CAMPWAR_CAMP_POINTS.deserialize(self, reader)
	self.camp_human = reader:readInt32Unsigned() -- {阵营积分--人}
	self.camp_god = reader:readInt32Unsigned() -- {阵营积分--仙}
end

-- {阵营积分--人}
function ACK_CAMPWAR_CAMP_POINTS.getCampHuman(self)
	return self.camp_human
end

-- {阵营积分--仙}
function ACK_CAMPWAR_CAMP_POINTS.getCampGod(self)
	return self.camp_god
end
