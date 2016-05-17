
require "common/RequestMessage"

-- [37150]金元购买 -- 世界BOSS 

REQ_WORLD_BOSS_RMB_ATTR = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WORLD_BOSS_RMB_ATTR
	self:init(1 ,{ 37160,37130,700 })
end)

function REQ_WORLD_BOSS_RMB_ATTR.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {0:查看消耗信息1:确认购买}
end

function REQ_WORLD_BOSS_RMB_ATTR.setArguments(self,type)
	self.type = type  -- {0:查看消耗信息1:确认购买}
end

-- {0:查看消耗信息1:确认购买}
function REQ_WORLD_BOSS_RMB_ATTR.setType(self, type)
	self.type = type
end
function REQ_WORLD_BOSS_RMB_ATTR.getType(self)
	return self.type
end
