
require "common/AcknowledgementMessage"

-- [45670]个人战绩 -- 活动-阵营战 

ACK_CAMPWAR_SELF_WAR = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_SELF_WAR
	self:init()
end)

function ACK_CAMPWAR_SELF_WAR.deserialize(self, reader)
	self.wins = reader:readInt16Unsigned() -- {战胜总次数}
	self.fails = reader:readInt16Unsigned() -- {战败总次数}
	self.wars_now = reader:readInt8Unsigned() -- {当前连胜次数}
	self.wars_max = reader:readInt8Unsigned() -- {最大连胜次数}
	self.integral = reader:readInt32Unsigned() -- {个人积分}
end

-- {战胜总次数}
function ACK_CAMPWAR_SELF_WAR.getWins(self)
	return self.wins
end

-- {战败总次数}
function ACK_CAMPWAR_SELF_WAR.getFails(self)
	return self.fails
end

-- {当前连胜次数}
function ACK_CAMPWAR_SELF_WAR.getWarsNow(self)
	return self.wars_now
end

-- {最大连胜次数}
function ACK_CAMPWAR_SELF_WAR.getWarsMax(self)
	return self.wars_max
end

-- {个人积分}
function ACK_CAMPWAR_SELF_WAR.getIntegral(self)
	return self.integral
end
