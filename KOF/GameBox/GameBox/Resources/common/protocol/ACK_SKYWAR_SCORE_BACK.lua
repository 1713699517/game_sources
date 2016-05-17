
require "common/AcknowledgementMessage"

-- [40552]天宫之战积分数据返回 -- 天宫之战 

ACK_SKYWAR_SCORE_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_SCORE_BACK
	self:init()
end)

-- {社团积分排行数量}
function ACK_SKYWAR_SCORE_BACK.getCount1(self)
	return self.count1
end

-- {社团积分数据块40560}
function ACK_SKYWAR_SCORE_BACK.getMsgXxx1(self)
	return self.msg_xxx1
end

-- {玩家积分排行数量}
function ACK_SKYWAR_SCORE_BACK.getCount2(self)
	return self.count2
end

-- {玩家积分数据块40562}
function ACK_SKYWAR_SCORE_BACK.getMsgXxx2(self)
	return self.msg_xxx2
end
