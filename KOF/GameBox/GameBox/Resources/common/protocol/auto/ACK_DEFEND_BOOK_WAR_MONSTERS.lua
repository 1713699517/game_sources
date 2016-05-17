
require "common/AcknowledgementMessage"

-- [21223]战斗怪物更新 -- 活动-保卫经书 

ACK_DEFEND_BOOK_WAR_MONSTERS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_WAR_MONSTERS
	self:init()
end)

function ACK_DEFEND_BOOK_WAR_MONSTERS.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {击杀类型 见常量CONST_DEFEND_BOOK_KILL_TYPE}
	self.gmid = reader:readInt32Unsigned() -- {被击杀的怪物Id}
	self.time = reader:readInt8Unsigned() -- {下一波怪物刷新时间}
end

-- {击杀类型 见常量CONST_DEFEND_BOOK_KILL_TYPE}
function ACK_DEFEND_BOOK_WAR_MONSTERS.getType(self)
	return self.type
end

-- {被击杀的怪物Id}
function ACK_DEFEND_BOOK_WAR_MONSTERS.getGmid(self)
	return self.gmid
end

-- {下一波怪物刷新时间}
function ACK_DEFEND_BOOK_WAR_MONSTERS.getTime(self)
	return self.time
end
