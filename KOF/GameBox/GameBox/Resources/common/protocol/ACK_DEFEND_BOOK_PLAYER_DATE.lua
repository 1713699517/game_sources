
require "common/AcknowledgementMessage"

-- [21175]单个防守圈玩家数据 -- 活动-保卫经书 

ACK_DEFEND_BOOK_PLAYER_DATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_PLAYER_DATE
	self:init()
end)

-- {防守圈编号：1-9}
function ACK_DEFEND_BOOK_PLAYER_DATE.getTrenchNum(self)
	return self.trench_num
end

-- {数量}
function ACK_DEFEND_BOOK_PLAYER_DATE.getCount(self)
	return self.count
end

-- {防守圈内玩家信息块【21180】}
function ACK_DEFEND_BOOK_PLAYER_DATE.getDataPalyer(self)
	return self.data_palyer
end
