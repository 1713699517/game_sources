
require "common/AcknowledgementMessage"

-- [33342]社团战个人排名数据块 -- 社团 

ACK_CLAN_PERSONAL_BANK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_PERSONAL_BANK
	self:init()
end)

-- {玩家uid}
function ACK_CLAN_PERSONAL_BANK.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_CLAN_PERSONAL_BANK.getName(self)
	return self.name
end

-- {所属社团名字}
function ACK_CLAN_PERSONAL_BANK.getClan(self)
	return self.clan
end

-- {连胜数}
function ACK_CLAN_PERSONAL_BANK.getKill(self)
	return self.kill
end

-- {个人排名}
function ACK_CLAN_PERSONAL_BANK.getRankP(self)
	return self.rank_p
end
