
require "common/RequestMessage"

-- [54270]请求豉舞【54260】 -- 社团BOSS 

REQ_CLAN_BOSS_ASK_INCITE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_BOSS_ASK_INCITE
	self:init(0, nil)
end)
