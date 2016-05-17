
require "common/RequestMessage"

-- [37080]玩家死亡 -- 世界BOSS 

REQ_WORLD_BOSS_WAR_DIE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WORLD_BOSS_WAR_DIE
	self:init(1 ,{ 37090,700 })
end)
