
require "common/AcknowledgementMessage"

-- [40539]玩家惩罚时间状态 -- 天宫之战 

ACK_SKYWAR_STATE_PUNISH = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_SKYWAR_STATE_PUNISH
	self:init()
end)

function ACK_SKYWAR_STATE_PUNISH.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {玩家uid}
	self.punish = reader:readInt32Unsigned() -- {0:无惩罚|惩罚到期时间戳}
end

-- {玩家uid}
function ACK_SKYWAR_STATE_PUNISH.getUid(self)
	return self.uid
end

-- {0:无惩罚|惩罚到期时间戳}
function ACK_SKYWAR_STATE_PUNISH.getPunish(self)
	return self.punish
end
