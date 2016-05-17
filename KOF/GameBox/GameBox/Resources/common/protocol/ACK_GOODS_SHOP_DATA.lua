
require "common/AcknowledgementMessage"

-- (手动) -- [2340]随身商店信息 -- 物品/背包 

ACK_GOODS_SHOP_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_SHOP_DATA
	self:init()
end)

function ACK_GOODS_SHOP_DATA.deserialize(self, reader)
	self.time = reader:readInt32Unsigned() -- {刷新剩余时间}
	self.goods_data = reader:readXXXGroup() -- {信息块(2310)}
end

-- {刷新剩余时间}
function ACK_GOODS_SHOP_DATA.getTime(self)
	return self.time
end

-- {信息块(2310)}
function ACK_GOODS_SHOP_DATA.getGoodsData(self)
	return self.goods_data
end
