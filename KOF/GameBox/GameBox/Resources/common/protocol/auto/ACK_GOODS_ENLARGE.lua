
require "common/AcknowledgementMessage"

-- [2230]容器扩充成功 -- 物品/背包 

ACK_GOODS_ENLARGE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_ENLARGE
	self:init()
end)

function ACK_GOODS_ENLARGE.deserialize(self, reader)
	self.max = reader:readInt16Unsigned() -- {当前背包最大格子数}
end

-- {当前背包最大格子数}
function ACK_GOODS_ENLARGE.getMax(self)
	return self.max
end
