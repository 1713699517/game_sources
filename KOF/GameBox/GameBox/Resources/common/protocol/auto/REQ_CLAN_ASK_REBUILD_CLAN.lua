
require "common/RequestMessage"

-- [33050]请求创建帮派 -- 社团 

REQ_CLAN_ASK_REBUILD_CLAN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_REBUILD_CLAN
	self:init(1 ,{ 33060,700 })
end)

function REQ_CLAN_ASK_REBUILD_CLAN.serialize(self, writer)
	writer:writeString(self.clan_name)  -- {帮派名字}
end

function REQ_CLAN_ASK_REBUILD_CLAN.setArguments(self,clan_name)
	self.clan_name = clan_name  -- {帮派名字}
end

-- {帮派名字}
function REQ_CLAN_ASK_REBUILD_CLAN.setClanName(self, clan_name)
	self.clan_name = clan_name
end
function REQ_CLAN_ASK_REBUILD_CLAN.getClanName(self)
	return self.clan_name
end
