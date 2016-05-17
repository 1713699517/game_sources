
require "common/AcknowledgementMessage"

-- (手动) -- [34502]店铺物品信息块 -- 商城 

ACK_SHOP_INFO_NEW = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SHOP_INFO_NEW
	self:init()
end)

function ACK_SHOP_INFO_NEW.deserialize(self, reader)
	self.idx = reader:readInt16Unsigned() -- {物品数据索引}
	self.state = reader:readInt8Unsigned() -- {1:可以购买|0:不可购买}
	self.msg = reader:readXXXGroup() -- {信息块2001}
	self.type = reader:readInt8Unsigned() -- {价格类型}
	self.s_price = reader:readInt32Unsigned() -- {物品现价}
	self.v_price = reader:readInt32Unsigned() -- {物品vip价格}
	self.etra_type = reader:readInt8Unsigned() -- {拓展类型|0:此字段无效}
	self.etra_value = reader:readInt16Unsigned() -- {拓展类型值}
end

-- {物品数据索引}
function ACK_SHOP_INFO_NEW.getIdx(self)
	return self.idx
end

-- {1:可以购买|0:不可购买}
function ACK_SHOP_INFO_NEW.getState(self)
	return self.state
end

-- {信息块2001}
function ACK_SHOP_INFO_NEW.getMsg(self)
	return self.msg
end

-- {价格类型}
function ACK_SHOP_INFO_NEW.getType(self)
	return self.type
end

-- {物品现价}
function ACK_SHOP_INFO_NEW.getSPrice(self)
	return self.s_price
end

-- {物品vip价格}
function ACK_SHOP_INFO_NEW.getVPrice(self)
	return self.v_price
end

-- {拓展类型|0:此字段无效}
function ACK_SHOP_INFO_NEW.getEtraType(self)
	return self.etra_type
end

-- {拓展类型值}
function ACK_SHOP_INFO_NEW.getEtraValue(self)
	return self.etra_value
end
