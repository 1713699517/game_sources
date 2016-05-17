
require "common/AcknowledgementMessage"

-- [45650]连胜榜数据 -- 活动-阵营战 

ACK_CAMPWAR_WINNING_STREAK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_WINNING_STREAK
	self:init()
end)

-- {数量}
function ACK_CAMPWAR_WINNING_STREAK.getCount(self)
	return self.count
end

-- {连胜玩家信息块【45655】}
function ACK_CAMPWAR_WINNING_STREAK.getPlyData(self)
	return self.ply_data
end
