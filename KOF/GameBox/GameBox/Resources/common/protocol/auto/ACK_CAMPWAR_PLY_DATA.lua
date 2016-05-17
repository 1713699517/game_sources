
require "common/AcknowledgementMessage"

-- [45655]连胜玩家信息块 -- 活动-阵营战 

ACK_CAMPWAR_PLY_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CAMPWAR_PLY_DATA
	self:init()
end)

function ACK_CAMPWAR_PLY_DATA.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.name = reader:readString() -- {名字}
	self.name_color = reader:readInt8Unsigned() -- {名字颜色}
	self.sex = reader:readInt8Unsigned() -- {性别}
	self.pro = reader:readInt8Unsigned() -- {职业}
	self.count = reader:readInt16Unsigned() -- {连胜次数}
end

-- {玩家uid}
function ACK_CAMPWAR_PLY_DATA.getUid(self)
	return self.uid
end

-- {名字}
function ACK_CAMPWAR_PLY_DATA.getName(self)
	return self.name
end

-- {名字颜色}
function ACK_CAMPWAR_PLY_DATA.getNameColor(self)
	return self.name_color
end

-- {性别}
function ACK_CAMPWAR_PLY_DATA.getSex(self)
	return self.sex
end

-- {职业}
function ACK_CAMPWAR_PLY_DATA.getPro(self)
	return self.pro
end

-- {连胜次数}
function ACK_CAMPWAR_PLY_DATA.getCount(self)
	return self.count
end
