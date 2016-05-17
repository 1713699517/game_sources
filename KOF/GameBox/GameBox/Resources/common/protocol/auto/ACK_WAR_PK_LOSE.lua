
require "common/AcknowledgementMessage"

-- [6080]PK结束死亡广播 -- 战斗 

ACK_WAR_PK_LOSE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_PK_LOSE
	self:init()
end)

function ACK_WAR_PK_LOSE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {死亡玩家Uid}
end

-- {死亡玩家Uid}
function ACK_WAR_PK_LOSE.getUid(self)
	return self.uid
end
