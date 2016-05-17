
require "common/AcknowledgementMessage"

-- [33145]成员数据信息块 -- 社团 

ACK_CLAN_MEMBER_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_MEMBER_MSG
	self:init()
end)

function ACK_CLAN_MEMBER_MSG.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.name = reader:readString() -- {玩家名字}
	self.name_color = reader:readInt8Unsigned() -- {玩家名字颜色}
	self.lv = reader:readInt16Unsigned() -- {玩家等级}
	self.pro = reader:readInt8Unsigned() -- {职业}
	self.post = reader:readInt8Unsigned() -- {职位}
	self.today_gx = reader:readInt32Unsigned() -- {今日贡献}
	self.all_gx = reader:readInt32Unsigned() -- {总贡献}
	self.time = reader:readInt32Unsigned() -- {离线时间(s) 1表示在线}
end

-- {玩家Uid}
function ACK_CLAN_MEMBER_MSG.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_CLAN_MEMBER_MSG.getName(self)
	return self.name
end

-- {玩家名字颜色}
function ACK_CLAN_MEMBER_MSG.getNameColor(self)
	return self.name_color
end

-- {玩家等级}
function ACK_CLAN_MEMBER_MSG.getLv(self)
	return self.lv
end

-- {职业}
function ACK_CLAN_MEMBER_MSG.getPro(self)
	return self.pro
end

-- {职位}
function ACK_CLAN_MEMBER_MSG.getPost(self)
	return self.post
end

-- {今日贡献}
function ACK_CLAN_MEMBER_MSG.getTodayGx(self)
	return self.today_gx
end

-- {总贡献}
function ACK_CLAN_MEMBER_MSG.getAllGx(self)
	return self.all_gx
end

-- {离线时间(s) 1表示在线}
function ACK_CLAN_MEMBER_MSG.getTime(self)
	return self.time
end
