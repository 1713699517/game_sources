
require "common/AcknowledgementMessage"

-- [57830]返回物品 -- 宝箱探秘 

ACK_DISCOVE_STORE_GOODS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DISCOVE_STORE_GOODS
	self:init()
end)

function ACK_DISCOVE_STORE_GOODS.deserialize(self, reader)
	self.goods_id = reader:readInt32Unsigned() -- {物品id}
	self.count = reader:readInt32Unsigned() -- {物品数量}
end

-- {物品id}
function ACK_DISCOVE_STORE_GOODS.getGoodsId(self)
	return self.goods_id
end

-- {物品数量}
function ACK_DISCOVE_STORE_GOODS.getCount(self)
	return self.count
end
