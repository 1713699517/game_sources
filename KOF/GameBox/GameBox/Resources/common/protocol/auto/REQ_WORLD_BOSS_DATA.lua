
require "common/RequestMessage"

-- [37010]请求世界boss数据 -- 世界BOSS 

REQ_WORLD_BOSS_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WORLD_BOSS_DATA
	self:init(1 ,{ 37053,37020,37060,700 })
end)
