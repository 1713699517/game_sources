
require "common/AcknowledgementMessage"

-- [23970]领取结果 -- 封神台 

ACK_ARENA_GET_REWARD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_GET_REWARD
	self:init()
end)

function ACK_ARENA_GET_REWARD.deserialize(self, reader)
	self.gold     = reader:readInt32Unsigned() -- {银元}
	self.renown   = reader:readInt32Unsigned() -- {声望}
    self.star     = reader:readInt32Unsigned() -- {星魂}
    self.count    = reader:readInt16Unsigned() -- {物品数量}
    self.data = {}   -- {物品信息块( P_GOODS_XXX1)}
    local icount = 1
    while icount <= self.count do
        self.data[icount].goods_id     = reader:readInt16Unsigned()
        icount = icount +1
    end --while
    
end

-- {银元}
function ACK_ARENA_GET_REWARD.getGold(self)
	return self.gold
end

-- {声望}
function ACK_ARENA_GET_REWARD.getRenown(self)
	return self.renown
end

-- {星魂}
function ACK_ARENA_GET_REWARD.getStar(self)
	return self.star
end

-- {物品数量}
function ACK_ARENA_GET_REWARD.getCount(self)
	return self.count
end

-- {信息块(23971)}
function ACK_ARENA_GET_REWARD.getData(self)
	return self.data
end
