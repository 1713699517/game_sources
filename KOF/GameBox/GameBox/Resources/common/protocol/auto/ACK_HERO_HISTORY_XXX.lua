
require "common/AcknowledgementMessage"

-- (手动) -- [39540]购买记录信息块 -- 英雄副本 

ACK_HERO_HISTORY_XXX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_HISTORY_XXX
	self:init()
end)

function ACK_HERO_HISTORY_XXX.deserialize(self, reader)
	self.uname = reader:readString() -- {玩家名称}
	self.goods_id = reader:readInt32Unsigned() -- {物品Id}
	self.count = reader:readInt16Unsigned() -- {物品数量}
end

-- {玩家名称}
function ACK_HERO_HISTORY_XXX.getUname(self)
	return self.uname
end

-- {物品Id}
function ACK_HERO_HISTORY_XXX.getGoodsId(self)
	return self.goods_id
end

-- {物品数量}
function ACK_HERO_HISTORY_XXX.getCount(self)
	return self.count
end
