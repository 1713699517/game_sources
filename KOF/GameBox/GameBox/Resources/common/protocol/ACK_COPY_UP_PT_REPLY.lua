
require "common/AcknowledgementMessage"

-- (手动) -- [7890]挂机-普通副本返回 -- 副本 

ACK_COPY_UP_PT_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_UP_PT_REPLY
	self:init()
end)

function ACK_COPY_UP_PT_REPLY.deserialize(self, reader)
	self.sum = reader:readInt16Unsigned() -- {挂机次数}
	self.monsters = reader:readInt16Unsigned() -- {每一轮的怪物数}
end

-- {挂机次数}
function ACK_COPY_UP_PT_REPLY.getSum(self)
	return self.sum
end

-- {每一轮的怪物数}
function ACK_COPY_UP_PT_REPLY.getMonsters(self)
	return self.monsters
end
