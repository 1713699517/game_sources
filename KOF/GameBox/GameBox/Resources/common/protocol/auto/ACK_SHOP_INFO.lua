
require "common/AcknowledgementMessage"

-- [34501]店铺物品信息块 -- 商城 

ACK_SHOP_INFO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOP_INFO
	self:init()
end)

function ACK_SHOP_INFO.deserialize(self, reader)
	self.idx = reader:readInt16Unsigned() -- {物品数据索引}
	self.msg = reader:readXXXGroup() -- {信息块2001}
	self.type = reader:readInt8Unsigned() -- {价格类型}
	self.s_price = reader:readInt32Unsigned() -- {物品现价}
	self.v_price = reader:readInt32Unsigned() -- {物品vip价格}
	self.total_remaider_num = reader:readInt16Unsigned() -- {剩余总数量}
	self.goods_num = reader:readInt16Unsigned() -- {兑换物品数量}
end

-- {物品数据索引}
function ACK_SHOP_INFO.getIdx(self)
	return self.idx
end

-- {信息块2001}
function ACK_SHOP_INFO.getMsg(self)
	return self.msg
end

-- {价格类型}
function ACK_SHOP_INFO.getType(self)
	return self.type
end

-- {物品现价}
function ACK_SHOP_INFO.getSPrice(self)
	return self.s_price
end

-- {物品vip价格}
function ACK_SHOP_INFO.getVPrice(self)
	return self.v_price
end

-- {剩余总数量}
function ACK_SHOP_INFO.getTotalRemaiderNum(self)
	return self.total_remaider_num
end

-- {兑换物品数量}
function ACK_SHOP_INFO.getGoodsNum(self)
	return self.goods_num
end
