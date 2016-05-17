
require "common/RequestMessage"

-- [54310]退出活动 -- 社团BOSS 

REQ_CLAN_BOSS_ASK_OUT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_BOSS_ASK_OUT
	self:init(0, nil)
end)
