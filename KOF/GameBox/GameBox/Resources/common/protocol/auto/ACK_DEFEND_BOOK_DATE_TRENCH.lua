
require "common/AcknowledgementMessage"

-- [21180]战壕玩家信息块 -- 活动-保卫经书 

ACK_DEFEND_BOOK_DATE_TRENCH = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_DEFEND_BOOK_DATE_TRENCH
	self:init()
end)

function ACK_DEFEND_BOOK_DATE_TRENCH.deserialize(self, reader)
	self.sid = reader:readInt16Unsigned() -- {服务器ID}
	self.uid = reader:readInt32Unsigned() -- {玩家UID}
	self.name = reader:readString() -- {角色名}
	self.name_color = reader:readInt16Unsigned() -- {角色名颜色}
	self.lv = reader:readInt16Unsigned() -- {等级}
	self.sex = reader:readInt8Unsigned() -- {性别}
	self.pro = reader:readInt8Unsigned() -- {职业}
end

-- {服务器ID}
function ACK_DEFEND_BOOK_DATE_TRENCH.getSid(self)
	return self.sid
end

-- {玩家UID}
function ACK_DEFEND_BOOK_DATE_TRENCH.getUid(self)
	return self.uid
end

-- {角色名}
function ACK_DEFEND_BOOK_DATE_TRENCH.getName(self)
	return self.name
end

-- {角色名颜色}
function ACK_DEFEND_BOOK_DATE_TRENCH.getNameColor(self)
	return self.name_color
end

-- {等级}
function ACK_DEFEND_BOOK_DATE_TRENCH.getLv(self)
	return self.lv
end

-- {性别}
function ACK_DEFEND_BOOK_DATE_TRENCH.getSex(self)
	return self.sex
end

-- {职业}
function ACK_DEFEND_BOOK_DATE_TRENCH.getPro(self)
	return self.pro
end
