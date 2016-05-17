
require "common/AcknowledgementMessage"

-- (手动) -- [7900]挂机-精英副本返回 -- 副本 

ACK_COPY_UP_JY_REPLY = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_UP_JY_REPLY
	self:init()
end)

function ACK_COPY_UP_JY_REPLY.deserialize(self, reader)
	self.nowtimes = reader:readInt16Unsigned() -- {当前战斗次数(怪物组数)}
	self.sumtimes = reader:readInt16Unsigned() -- {总共战斗次数(怪物组数)}
end

-- {当前战斗次数(怪物组数)}
function ACK_COPY_UP_JY_REPLY.getNowtimes(self)
	return self.nowtimes
end

-- {总共战斗次数(怪物组数)}
function ACK_COPY_UP_JY_REPLY.getSumtimes(self)
	return self.sumtimes
end
