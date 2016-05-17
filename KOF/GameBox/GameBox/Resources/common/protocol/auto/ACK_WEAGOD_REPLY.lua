
require "common/AcknowledgementMessage"

-- [32020]招财面板返回 -- 财神 

ACK_WEAGOD_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WEAGOD_REPLY
	self:init()
end)

function ACK_WEAGOD_REPLY.deserialize(self, reader)
	self.times = reader:readInt16Unsigned() -- {剩余招财次数}
	self.is_auto = reader:readInt8Unsigned() -- {当前是否自动招财(1:是 0:否)}
	self.auto_gold = reader:readInt32Unsigned() -- {自动招财铜钱}
	self.next_rmb = reader:readInt32Unsigned() -- {}
	self.next_gold = reader:readInt32Unsigned() -- {}
end

-- {剩余招财次数}
function ACK_WEAGOD_REPLY.getTimes(self)
	return self.times
end

-- {当前是否自动招财(1:是 0:否)}
function ACK_WEAGOD_REPLY.getIsAuto(self)
	return self.is_auto
end

-- {自动招财铜钱}
function ACK_WEAGOD_REPLY.getAutoGold(self)
	return self.auto_gold
end

-- {}
function ACK_WEAGOD_REPLY.getNextRmb(self)
	return self.next_rmb
end

-- {}
function ACK_WEAGOD_REPLY.getNextGold(self)
	return self.next_gold
end
