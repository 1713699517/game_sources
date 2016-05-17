
require "common/RequestMessage"

-- [54300]请求复活 -- 社团BOSS 

REQ_CLAN_BOSS_ASK_RELIVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_BOSS_ASK_RELIVE
	self:init(1 ,{ 54305,700 })
end)
