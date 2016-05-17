
require "common/AcknowledgementMessage"

-- [52270]神器商品信息块 -- 神器 

ACK_MAGIC_EQUIP_SHOP_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_MAGIC_EQUIP_SHOP_MSG
	self:init()
end)

function ACK_MAGIC_EQUIP_SHOP_MSG.deserialize(self, reader)
	self.id = reader:readInt32Unsigned() -- {id}
	self.type = reader:readInt8Unsigned() -- {价格类型}
	self.price = reader:readInt8Unsigned() -- {价格}
end

-- {id}
function ACK_MAGIC_EQUIP_SHOP_MSG.getId(self)
	return self.id
end

-- {价格类型}
function ACK_MAGIC_EQUIP_SHOP_MSG.getType(self)
	return self.type
end

-- {价格}
function ACK_MAGIC_EQUIP_SHOP_MSG.getPrice(self)
	return self.price
end
