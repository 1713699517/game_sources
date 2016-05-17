
require "common/AcknowledgementMessage"

-- [2310]商店数据返回 -- 物品/背包 

ACK_GOODS_SHOP_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_SHOP_BACK
	self:init()
end)

function ACK_GOODS_SHOP_BACK.deserialize(self, reader)
	self.price_type   = reader:readInt8Unsigned()  -- {价格类型}
	self.count        = reader:readInt16Unsigned() -- {物品数量}
    
    local i = 1
    self.msgxxx = {}
    while i <= self.count do
        self.msgxxx = {}
        self.msgxxx[i].id     = reader:readInt32Unsigned() -- {物品ID}
        self.msgxxx[i].price  = reader:readInt32Unsigned() -- {物品价格}
        i = i + 1
    end
	
end

-- {价格类型}
function ACK_GOODS_SHOP_BACK.getPriceType(self)
	return self.price_type
end

-- {数量}
function ACK_GOODS_SHOP_BACK.getCount(self)
	return self.count
end

-- {商店物品信息块2301}
function ACK_GOODS_SHOP_BACK.getMsgxxx(self)
	return self.msgxxx
end
