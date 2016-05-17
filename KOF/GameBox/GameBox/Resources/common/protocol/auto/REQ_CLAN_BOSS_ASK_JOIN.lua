
require "common/RequestMessage"

-- [54230]请求参加社团BOSS -- 社团BOSS 

REQ_CLAN_BOSS_ASK_JOIN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_BOSS_ASK_JOIN
	self:init(0, nil)
end)
