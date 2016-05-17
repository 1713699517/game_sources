
require "common/RequestMessage"

-- [40536]请求战斗 -- 天宫之战 

REQ_SKYWAR_FIGHT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKYWAR_FIGHT
	self:init(0, nil)
end)

function REQ_SKYWAR_FIGHT.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {玩家uid(0:守城大将|其他玩家uid)}
end

function REQ_SKYWAR_FIGHT.setArguments(self,uid)
	self.uid = uid  -- {玩家uid(0:守城大将|其他玩家uid)}
end

-- {玩家uid(0:守城大将|其他玩家uid)}
function REQ_SKYWAR_FIGHT.setUid(self, uid)
	self.uid = uid
end
function REQ_SKYWAR_FIGHT.getUid(self)
	return self.uid
end
