
require "common/AcknowledgementMessage"

-- [21225]玩家死亡 -- 活动-保卫经书 

ACK_DEFEND_BOOK_KILL_PLAYERS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_KILL_PLAYERS
	self:init()
end)

function ACK_DEFEND_BOOK_KILL_PLAYERS.deserialize(self, reader)
	self.num = reader:readInt16Unsigned() -- {元宝复活次数}
	self.rmb = reader:readInt8Unsigned() -- {玩家复活需消耗的元宝数}
	self.time = reader:readInt8Unsigned() -- {复活CD}
end

-- {元宝复活次数}
function ACK_DEFEND_BOOK_KILL_PLAYERS.getNum(self)
	return self.num
end

-- {玩家复活需消耗的元宝数}
function ACK_DEFEND_BOOK_KILL_PLAYERS.getRmb(self)
	return self.rmb
end

-- {复活CD}
function ACK_DEFEND_BOOK_KILL_PLAYERS.getTime(self)
	return self.time
end
