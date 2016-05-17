
require "common/AcknowledgementMessage"

-- [33085]入帮申请玩家信息块 -- 社团 

ACK_CLAN_USER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_USER_DATA
	self:init()
end)

function ACK_CLAN_USER_DATA.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.name = reader:readString() -- {玩家名字}
	self.name_color = reader:readInt8Unsigned() -- {玩家名字颜色}
	self.lv = reader:readInt16Unsigned() -- {等级}
	self.pro = reader:readInt8Unsigned() -- {职业}
	self.time = reader:readInt32Unsigned() -- {申请时间戳(s)}
end

-- {玩家Uid}
function ACK_CLAN_USER_DATA.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_CLAN_USER_DATA.getName(self)
	return self.name
end

-- {玩家名字颜色}
function ACK_CLAN_USER_DATA.getNameColor(self)
	return self.name_color
end

-- {等级}
function ACK_CLAN_USER_DATA.getLv(self)
	return self.lv
end

-- {职业}
function ACK_CLAN_USER_DATA.getPro(self)
	return self.pro
end

-- {申请时间戳(s)}
function ACK_CLAN_USER_DATA.getTime(self)
	return self.time
end
