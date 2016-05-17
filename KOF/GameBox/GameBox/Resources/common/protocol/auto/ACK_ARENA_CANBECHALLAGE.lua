
require "common/AcknowledgementMessage"

-- [23821]可以挑战的玩家 -- 逐鹿台 

ACK_ARENA_CANBECHALLAGE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_CANBECHALLAGE
	self:init()
end)

function ACK_ARENA_CANBECHALLAGE.deserialize(self, reader)
	self.sid = reader:readInt16Unsigned() -- {服务器ID}
	self.pro = reader:readInt8Unsigned() -- {玩家职业}
	self.sex = reader:readInt8Unsigned() -- {玩家性别}
	self.lv = reader:readInt16Unsigned() -- {玩家等级}
	self.uid = reader:readInt32Unsigned() -- {玩家UID}
	self.name = reader:readUTF() -- {玩家名字}
	self.ranking = reader:readInt16Unsigned() -- {玩家排名}
	self.win_count = reader:readInt8Unsigned() -- {连胜次数}
	self.surplus = reader:readInt8Unsigned() -- {剩余挑战次数}
	self.power = reader:readInt32Unsigned() -- {战斗力}
end

-- {服务器ID}
function ACK_ARENA_CANBECHALLAGE.getSid(self)
	return self.sid
end

-- {玩家职业}
function ACK_ARENA_CANBECHALLAGE.getPro(self)
	return self.pro
end

-- {玩家性别}
function ACK_ARENA_CANBECHALLAGE.getSex(self)
	return self.sex
end

-- {玩家等级}
function ACK_ARENA_CANBECHALLAGE.getLv(self)
	return self.lv
end

-- {玩家UID}
function ACK_ARENA_CANBECHALLAGE.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_ARENA_CANBECHALLAGE.getName(self)
	return self.name
end

-- {玩家排名}
function ACK_ARENA_CANBECHALLAGE.getRanking(self)
	return self.ranking
end

-- {连胜次数}
function ACK_ARENA_CANBECHALLAGE.getWinCount(self)
	return self.win_count
end

-- {剩余挑战次数}
function ACK_ARENA_CANBECHALLAGE.getSurplus(self)
	return self.surplus
end

-- {战斗力}
function ACK_ARENA_CANBECHALLAGE.getPower(self)
	return self.power
end
