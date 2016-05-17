
require "common/RequestMessage"

-- [54220]请求开启社团BOSS -- 社团BOSS 

REQ_CLAN_BOSS_START_BOSS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CLAN_BOSS_START_BOSS
	self:init(1 ,{ 54235,54240,54250,700 })
end)
