
require "common/AcknowledgementMessage"

-- [21145]对怪物累计伤害前10排名 -- 活动-保卫经书 

ACK_DEFEND_BOOK_RANKING = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_RANKING
	self:init()
end)

-- {开启下一级增益需要的伤害值}
function ACK_DEFEND_BOOK_RANKING.getNextHarm(self)
	return self.next_harm
end

-- {数量}
function ACK_DEFEND_BOOK_RANKING.getCount(self)
	return self.count
end

-- {伤害前10排名数据块 [21150]}
function ACK_DEFEND_BOOK_RANKING.getRankDate(self)
	return self.rank_date
end
