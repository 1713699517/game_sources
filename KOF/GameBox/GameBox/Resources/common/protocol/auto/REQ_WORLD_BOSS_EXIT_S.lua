
require "common/RequestMessage"

-- [37100]退出世界BOSS -- 世界BOSS 

REQ_WORLD_BOSS_EXIT_S = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WORLD_BOSS_EXIT_S
	self:init(0, nil)
end)
