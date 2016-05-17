
require "common/AcknowledgementMessage"

-- [39505]黑店信息返回 -- 取经之路 

ACK_PILROAD_SHOP_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_PILROAD_SHOP_BACK
	self:init()
end)

-- {剩余时间}
function ACK_PILROAD_SHOP_BACK.getOtime(self)
	return self.otime
end

-- {物品数量}
function ACK_PILROAD_SHOP_BACK.getCount(self)
	return self.count
end

-- {黑店物品信息块(39510)}
function ACK_PILROAD_SHOP_BACK.getMsgxxxshop(self)
	return self.msgxxxshop
end
