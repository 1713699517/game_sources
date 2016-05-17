
require "common/AcknowledgementMessage"

-- [46010]奖励物品数据块 -- 幸运大转盘 

ACK_WHEEL_XXX1 = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WHEEL_XXX1
	self:init()
end)

function ACK_WHEEL_XXX1.deserialize(self, reader)
	self.idx = reader:readInt16Unsigned() -- {索引}
	self.gid = reader:readInt16Unsigned() -- {物品ID}
	self.count = reader:readInt16Unsigned() -- {数量}
end

-- {索引}
function ACK_WHEEL_XXX1.getIdx(self)
	return self.idx
end

-- {物品ID}
function ACK_WHEEL_XXX1.getGid(self)
	return self.gid
end

-- {数量}
function ACK_WHEEL_XXX1.getCount(self)
	return self.count
end
