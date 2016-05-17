
require "common/AcknowledgementMessage"

-- [2327]元宵节活动将会获得的物品索引(0~11) -- 物品/背包 

ACK_GOODS_LANTERN_INDEX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_GOODS_LANTERN_INDEX
	self:init()
end)

function ACK_GOODS_LANTERN_INDEX.deserialize(self, reader)
	self.index = reader:readInt8Unsigned() -- {}
end

-- {}
function ACK_GOODS_LANTERN_INDEX.getIndex(self)
	return self.index
end
