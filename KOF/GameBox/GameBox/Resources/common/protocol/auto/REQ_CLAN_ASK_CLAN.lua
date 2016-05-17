
require "common/RequestMessage"

-- [33010]请求帮派面板 -- 社团 

REQ_CLAN_ASK_CLAN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_ASK_CLAN
	self:init(1 ,{ 33020,33023,33025,700 })
end)

function REQ_CLAN_ASK_CLAN.serialize(self, writer)
	writer:writeInt32Unsigned(self.clan_id)  -- {0 查看自己帮派【33020，33023，33025】| ID 查看指定帮派【33020，33023】}
end

function REQ_CLAN_ASK_CLAN.setArguments(self,clan_id)
	self.clan_id = clan_id  -- {0 查看自己帮派【33020，33023，33025】| ID 查看指定帮派【33020，33023】}
end

-- {0 查看自己帮派【33020，33023，33025】| ID 查看指定帮派【33020，33023】}
function REQ_CLAN_ASK_CLAN.setClanId(self, clan_id)
	self.clan_id = clan_id
end
function REQ_CLAN_ASK_CLAN.getClanId(self)
	return self.clan_id
end
