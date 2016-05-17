
require "common/AcknowledgementMessage"

-- [33020]返加帮派基础数据1 -- 社团 

ACK_CLAN_OK_CLAN_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_OK_CLAN_DATA
	self:init()
end)

function ACK_CLAN_OK_CLAN_DATA.deserialize(self, reader)
	self.clan_id = reader:readInt32Unsigned() -- {帮派ID}
	self.clan_name = reader:readString() -- {帮派名字}
	self.clan_lv = reader:readInt8Unsigned() -- {帮派等级}
	self.clan_rank = reader:readInt16Unsigned() -- {帮派排名}
	self.clan_members = reader:readInt16Unsigned() -- {帮派当前成员数}
	self.clan_all_members = reader:readInt16Unsigned() -- {帮派成员上限数}
end

-- {帮派ID}
function ACK_CLAN_OK_CLAN_DATA.getClanId(self)
	return self.clan_id
end

-- {帮派名字}
function ACK_CLAN_OK_CLAN_DATA.getClanName(self)
	return self.clan_name
end

-- {帮派等级}
function ACK_CLAN_OK_CLAN_DATA.getClanLv(self)
	return self.clan_lv
end

-- {帮派排名}
function ACK_CLAN_OK_CLAN_DATA.getClanRank(self)
	return self.clan_rank
end

-- {帮派当前成员数}
function ACK_CLAN_OK_CLAN_DATA.getClanMembers(self)
	return self.clan_members
end

-- {帮派成员上限数}
function ACK_CLAN_OK_CLAN_DATA.getClanAllMembers(self)
	return self.clan_all_members
end
