
require "common/AcknowledgementMessage"

-- (手动) -- [23950]每日竞技场排行榜奖励 -- 逐鹿台 

ACK_ARENA_RANK_REWARD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_RANK_REWARD
	self:init()
end)

function ACK_ARENA_RANK_REWARD.deserialize(self, reader)
	self.gold = reader:readInt32Unsigned() -- {银元}
	self.renown = reader:readInt32Unsigned() -- {声望}
end

-- {银元}
function ACK_ARENA_RANK_REWARD.getGold(self)
	return self.gold
end

-- {声望}
function ACK_ARENA_RANK_REWARD.getRenown(self)
	return self.renown
end
