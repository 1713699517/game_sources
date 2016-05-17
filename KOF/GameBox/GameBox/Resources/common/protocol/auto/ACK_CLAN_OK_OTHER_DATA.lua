
require "common/AcknowledgementMessage"

-- [33023]返加帮派基础数据2 -- 社团 

ACK_CLAN_OK_OTHER_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_OTHER_DATA
	self:init()
end)

function ACK_CLAN_OK_OTHER_DATA.deserialize(self, reader)
	self.master_uid = reader:readInt32Unsigned() -- {帮主uid}
	self.master_name = reader:readString() -- {帮主名字}
	self.master_name_color = reader:readInt8Unsigned() -- {帮主名字颜色}
	self.master_lv = reader:readInt16Unsigned() -- {帮主等级}
	self.member_contribute = reader:readInt32Unsigned() -- {个人贡献值}
	self.member_power = reader:readInt8Unsigned() -- {个人权限等级}
	self.clan_all_contribute = reader:readInt32Unsigned() -- {帮派总贡献值}
	self.clan_contribute = reader:readInt32Unsigned() -- {升级所需贡献}
	self.clan_broadcast = reader:readUTF() -- {帮派公告}
end

-- {帮主uid}
function ACK_CLAN_OK_OTHER_DATA.getMasterUid(self)
	return self.master_uid
end

-- {帮主名字}
function ACK_CLAN_OK_OTHER_DATA.getMasterName(self)
	return self.master_name
end

-- {帮主名字颜色}
function ACK_CLAN_OK_OTHER_DATA.getMasterNameColor(self)
	return self.master_name_color
end

-- {帮主等级}
function ACK_CLAN_OK_OTHER_DATA.getMasterLv(self)
	return self.master_lv
end

-- {个人贡献值}
function ACK_CLAN_OK_OTHER_DATA.getMemberContribute(self)
	return self.member_contribute
end

-- {个人权限等级}
function ACK_CLAN_OK_OTHER_DATA.getMemberPower(self)
	return self.member_power
end

-- {帮派总贡献值}
function ACK_CLAN_OK_OTHER_DATA.getClanAllContribute(self)
	return self.clan_all_contribute
end

-- {升级所需贡献}
function ACK_CLAN_OK_OTHER_DATA.getClanContribute(self)
	return self.clan_contribute
end

-- {帮派公告}
function ACK_CLAN_OK_OTHER_DATA.getClanBroadcast(self)
	return self.clan_broadcast
end
