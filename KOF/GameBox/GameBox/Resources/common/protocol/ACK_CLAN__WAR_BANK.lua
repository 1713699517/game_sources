
require "common/AcknowledgementMessage"

-- [33341]社团战社团排名数据块 -- 社团 

ACK_CLAN__WAR_BANK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN__WAR_BANK
	self:init()
end)

-- {社团id}
function ACK_CLAN__WAR_BANK.getClanId(self)
	return self.clan_id
end

-- {社团名字}
function ACK_CLAN__WAR_BANK.getClanName(self)
	return self.clan_name
end

-- {}
function ACK_CLAN__WAR_BANK.getRankC(self)
	return self.rank_c
end
