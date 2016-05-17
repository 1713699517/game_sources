
require "common/RequestMessage"

-- [54280]玩家死亡 -- 社团BOSS 

REQ_CLAN_BOSS_DIED = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_BOSS_DIED
	self:init(0, nil)
end)
