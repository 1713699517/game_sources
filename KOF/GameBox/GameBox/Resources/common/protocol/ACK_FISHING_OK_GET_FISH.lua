
require "common/AcknowledgementMessage"

-- [18045]收取成功 -- 活动-钓鱼达人 

ACK_FISHING_OK_GET_FISH = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_FISHING_OK_GET_FISH
	self:init()
end)

-- {收取的浮漂编号}
function ACK_FISHING_OK_GET_FISH.getNum(self)
	return self.num
end

-- {鱼的品阶常量CONST_FISHING_FISH_TYPE_XXX}
function ACK_FISHING_OK_GET_FISH.getFishType(self)
	return self.fish_type
end

-- {数量}
function ACK_FISHING_OK_GET_FISH.getCount(self)
	return self.count
end

-- {包裹物品信息块：2001}
function ACK_FISHING_OK_GET_FISH.getRewards(self)
	return self.rewards
end
