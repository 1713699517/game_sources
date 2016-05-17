
require "common/RequestMessage"

-- [37110]复活 -- 世界BOSS 

REQ_WORLD_BOSS_REVIVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WORLD_BOSS_REVIVE
	self:init(0 ,{ 37120,700 })
end)

function REQ_WORLD_BOSS_REVIVE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {1:立即复活 0:复活}
end

function REQ_WORLD_BOSS_REVIVE.setArguments(self,type)
	self.type = type  -- {1:立即复活 0:复活}
end

-- {1:立即复活 0:复活}
function REQ_WORLD_BOSS_REVIVE.setType(self, type)
	self.type = type
end
function REQ_WORLD_BOSS_REVIVE.getType(self)
	return self.type
end
