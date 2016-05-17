
require "common/AcknowledgementMessage"

-- (手动) -- [54820]玩家对阵情况 -- 格斗之王 

ACK_WRESTLE_PLAYER_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WRESTLE_PLAYER_GROUP
	self:init()
end)

function ACK_WRESTLE_PLAYER_GROUP.deserialize(self, reader)
	self.war_state = reader:readInt8Unsigned() -- {0:战败|1:战胜}
	self.uid = reader:readInt32Unsigned() -- {玩家的uid}
	self.touid = reader:readInt32Unsigned() -- {对方玩家的uid}
end

-- {0:战败|1:战胜}
function ACK_WRESTLE_PLAYER_GROUP.getWarState(self)
	return self.war_state
end

-- {玩家的uid}
function ACK_WRESTLE_PLAYER_GROUP.getUid(self)
	return self.uid
end

-- {对方玩家的uid}
function ACK_WRESTLE_PLAYER_GROUP.getTouid(self)
	return self.touid
end
