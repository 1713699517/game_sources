
require "common/RequestMessage"

-- [5150]玩家死亡 -- 场景 

REQ_SCENE_DIE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SCENE_DIE
	self:init(0, nil)
end)
