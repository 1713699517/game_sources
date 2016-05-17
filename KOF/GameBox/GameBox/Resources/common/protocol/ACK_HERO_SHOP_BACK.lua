
require "common/AcknowledgementMessage"

-- [39505]黑店信息返回 -- 英雄副本 

ACK_HERO_SHOP_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_HERO_SHOP_BACK
	self:init()
end)

function ACK_HERO_SHOP_BACK.deserialize(self, reader)
	self.otime = reader:readInt32Unsigned() -- {剩余时间}
	self.count = reader:readInt16Unsigned() -- {物品数量}
	self.msgxxxshop = reader:readXXXGroup() -- {黑店物品信息块(39510)}
end

-- {剩余时间}
function ACK_HERO_SHOP_BACK.getOtime(self)
	return self.otime
end

-- {物品数量}
function ACK_HERO_SHOP_BACK.getCount(self)
	return self.count
end

-- {黑店物品信息块(39510)}
function ACK_HERO_SHOP_BACK.getMsgxxxshop(self)
	return self.msgxxxshop
end
