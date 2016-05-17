
require "common/AcknowledgementMessage"

-- [24000]领取倒计时 -- 逐鹿台 

ACK_ARENA_REWARD_TIMES = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_REWARD_TIMES
	self:init()
end)

function ACK_ARENA_REWARD_TIMES.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {1:可领取 0:不可领取}
	self.times = reader:readInt32Unsigned() -- {领取奖励倒计时}
	self.gold = reader:readInt32Unsigned() -- {金币}
	self.renoe = reader:readInt32Unsigned() -- {声望}
end

-- {1:可领取 0:不可领取}
function ACK_ARENA_REWARD_TIMES.getType(self)
	return self.type
end

-- {领取奖励倒计时}
function ACK_ARENA_REWARD_TIMES.getTimes(self)
	return self.times
end

-- {金币}
function ACK_ARENA_REWARD_TIMES.getGold(self)
	return self.gold
end

-- {声望}
function ACK_ARENA_REWARD_TIMES.getRenoe(self)
	return self.renoe
end
