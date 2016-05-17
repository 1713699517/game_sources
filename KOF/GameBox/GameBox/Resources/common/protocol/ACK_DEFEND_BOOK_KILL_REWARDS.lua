
require "common/AcknowledgementMessage"

-- [21227]击杀掉落 -- 活动-保卫经书 

ACK_DEFEND_BOOK_KILL_REWARDS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_KILL_REWARDS
	self:init()
end)

-- {被击杀的怪物生成Id}
function ACK_DEFEND_BOOK_KILL_REWARDS.getGmid(self)
	return self.gmid
end

-- {数量}
function ACK_DEFEND_BOOK_KILL_REWARDS.getCount(self)
	return self.count
end

-- {物品信息块2001}
function ACK_DEFEND_BOOK_KILL_REWARDS.getRewards(self)
	return self.rewards
end
