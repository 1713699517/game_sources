
require "common/AcknowledgementMessage"

-- [21150]排行榜数据 -- 活动-保卫经书 

ACK_DEFEND_BOOK_RANK_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_RANK_DATA
	self:init()
end)

function ACK_DEFEND_BOOK_RANK_DATA.deserialize(self, reader)
	self.sid = reader:readInt8Unsigned() -- {服务器ID}
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.name = reader:readString() -- {玩家名字}
	self.harm_hp = reader:readInt32Unsigned() -- {伤害血量}
end

-- {服务器ID}
function ACK_DEFEND_BOOK_RANK_DATA.getSid(self)
	return self.sid
end

-- {玩家Uid}
function ACK_DEFEND_BOOK_RANK_DATA.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_DEFEND_BOOK_RANK_DATA.getName(self)
	return self.name
end

-- {伤害血量}
function ACK_DEFEND_BOOK_RANK_DATA.getHarmHp(self)
	return self.harm_hp
end
