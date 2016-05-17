
require "common/AcknowledgementMessage"

-- [18015]请求界面成功 -- 活动-钓鱼达人 

ACK_FISHING_OK_FISHING = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FISHING_OK_FISHING
	self:init()
end)

-- {需花费的银元数量}
function ACK_FISHING_OK_FISHING.getGoldPay(self)
	return self.gold_pay
end

-- {剩余垂钓时间}
function ACK_FISHING_OK_FISHING.getTime(self)
	return self.time
end

-- {数量}
function ACK_FISHING_OK_FISHING.getCount(self)
	return self.count
end

-- {可收取鱼数据块【18017】}
function ACK_FISHING_OK_FISHING.getFishdata(self)
	return self.fishdata
end
