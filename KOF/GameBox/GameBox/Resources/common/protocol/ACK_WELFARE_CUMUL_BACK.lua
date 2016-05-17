
require "common/AcknowledgementMessage"

-- [22230]在线奖励数据 -- 福利 

ACK_WELFARE_CUMUL_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WELFARE_CUMUL_BACK
	self:init()
end)

-- {上周累计在线时间}
function ACK_WELFARE_CUMUL_BACK.getLastWeek(self)
	return self.last_week
end

-- {领取状态true:未领过|false:已领}
function ACK_WELFARE_CUMUL_BACK.getRewardLast(self)
	return self.reward_last
end

-- {本周累计在线时间}
function ACK_WELFARE_CUMUL_BACK.getCumulWeek(self)
	return self.cumul_week
end

-- {今日累计在线时间}
function ACK_WELFARE_CUMUL_BACK.getCumulDay(self)
	return self.cumul_day
end

-- {已领取的日累计条件}
function ACK_WELFARE_CUMUL_BACK.getCount1(self)
	return self.count1
end

-- {条件值}
function ACK_WELFARE_CUMUL_BACK.getCondition1(self)
	return self.condition1
end

-- {已领取的黄钻日累计条件}
function ACK_WELFARE_CUMUL_BACK.getCount2(self)
	return self.count2
end

-- {条件值}
function ACK_WELFARE_CUMUL_BACK.getCondition2(self)
	return self.condition2
end
