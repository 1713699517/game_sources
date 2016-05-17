
require "common/AcknowledgementMessage"

-- [23835]挑战奖励 -- 逐鹿台 

ACK_ARENA_WAR_REWARD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_WAR_REWARD
	self:init()
end)

function ACK_ARENA_WAR_REWARD.deserialize(self, reader)
	self.res = reader:readInt8Unsigned() -- {结果0：失败1：成功}
	self.gold = reader:readInt32Unsigned() -- {获得银元}
	self.renown = reader:readInt32Unsigned() -- {获得声望}
end

-- {结果0：失败1：成功}
function ACK_ARENA_WAR_REWARD.getRes(self)
	return self.res
end

-- {获得银元}
function ACK_ARENA_WAR_REWARD.getGold(self)
	return self.gold
end

-- {获得声望}
function ACK_ARENA_WAR_REWARD.getRenown(self)
	return self.renown
end
