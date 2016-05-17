
require "common/AcknowledgementMessage"

-- [7950]挂机物品信息块 -- 副本 

ACK_COPY_UP_GOODS_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_UP_GOODS_GROUP
	self:init()
end)

-- {物品ID}
function ACK_COPY_UP_GOODS_GROUP.getGoodsId(self)
	return self.goods_id
end

-- {物品数量}
function ACK_COPY_UP_GOODS_GROUP.getGoodsNum(self)
	return self.goods_num
end
