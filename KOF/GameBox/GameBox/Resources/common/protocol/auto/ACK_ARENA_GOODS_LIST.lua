
require "common/AcknowledgementMessage"

-- [23971]获得物品id列表 -- 逐鹿台 

ACK_ARENA_GOODS_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_GOODS_LIST
	self:init()
end)

function ACK_ARENA_GOODS_LIST.deserialize(self, reader)
	self.goods_id = reader:readInt16Unsigned() -- {物品ID}
end

-- {物品ID}
function ACK_ARENA_GOODS_LIST.getGoodsId(self)
	return self.goods_id
end
