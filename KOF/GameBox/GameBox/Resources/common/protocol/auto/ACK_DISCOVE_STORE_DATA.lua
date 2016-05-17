
require "common/AcknowledgementMessage"

-- [57810]数据返回 -- 宝箱探秘 

ACK_DISCOVE_STORE_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DISCOVE_STORE_DATA
	self:init()
end)

function ACK_DISCOVE_STORE_DATA.deserialize(self, reader)
	self.goods_count = reader:readInt16Unsigned() -- {背包剩余数量}
end

-- {背包剩余数量}
function ACK_DISCOVE_STORE_DATA.getGoodsCount(self)
	return self.goods_count
end
