
require "common/AcknowledgementMessage"

-- [46032]转盘索引 -- 幸运大转盘 

ACK_WHEEL_IDX = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WHEEL_IDX
	self:init()
end)

function ACK_WHEEL_IDX.deserialize(self, reader)
	self.idx = reader:readInt16Unsigned() -- {索引}
end

-- {索引}
function ACK_WHEEL_IDX.getIdx(self)
	return self.idx
end
