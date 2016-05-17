
require "common/RequestMessage"

-- (手动) -- [54210]请求社团BOSS -- 社团BOSS 

REQ_CLAN_BOSS_ASK_ENIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_BOSS_ASK_ENIT
	self:init()
end)
