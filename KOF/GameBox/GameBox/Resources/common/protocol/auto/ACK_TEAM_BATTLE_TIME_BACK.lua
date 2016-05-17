
require "common/AcknowledgementMessage"

-- (手动) -- [3685]战役剩余奖励次数返回 -- 组队系统 

ACK_TEAM_BATTLE_TIME_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TEAM_BATTLE_TIME_BACK
	self:init()
end)

function ACK_TEAM_BATTLE_TIME_BACK.deserialize(self, reader)
	self.sid = reader:readInt16Unsigned() -- {服务器Id}
	self.uid = reader:readInt32Unsigned() -- {玩家Uid}
	self.times = reader:readInt8Unsigned() -- {战役次数}
end

-- {服务器Id}
function ACK_TEAM_BATTLE_TIME_BACK.getSid(self)
	return self.sid
end

-- {玩家Uid}
function ACK_TEAM_BATTLE_TIME_BACK.getUid(self)
	return self.uid
end

-- {战役次数}
function ACK_TEAM_BATTLE_TIME_BACK.getTimes(self)
	return self.times
end
