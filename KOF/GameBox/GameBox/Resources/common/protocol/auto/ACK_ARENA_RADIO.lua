
require "common/AcknowledgementMessage"

-- [23850]战果广播 -- 逐鹿台 

ACK_ARENA_RADIO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_RADIO
	self:init()
end)

function ACK_ARENA_RADIO.deserialize(self, reader)
	self.start_time = reader:readInt32Unsigned() -- {挑战开始时间}
	self.type = reader:readInt8Unsigned() -- {广播类型(传闻,竞技场 见常量CONST_CHAT_*)}
	self.event = reader:readInt8Unsigned() -- {事件(排名第一、连赢10次...见常量CONST_ARENA_*)}
	self.t_uid = reader:readInt32Unsigned() -- {挑战玩家uid}
	self.t_name = reader:readUTF() -- {挑战玩家名字}
	self.t_ranking = reader:readInt16Unsigned() -- {挑战玩家排名}
	self.b_uid = reader:readInt32Unsigned() -- {被挑战玩家uid}
	self.b_name = reader:readUTF() -- {被挑战玩家名字}
	self.b_ranking = reader:readInt16Unsigned() -- {被挑战玩家排名}
	self.result = reader:readInt8Unsigned() -- {1:成功  2:失败 3:排名不变}
end

-- {挑战开始时间}
function ACK_ARENA_RADIO.getStartTime(self)
	return self.start_time
end

-- {广播类型(传闻,竞技场 见常量CONST_CHAT_*)}
function ACK_ARENA_RADIO.getType(self)
	return self.type
end

-- {事件(排名第一、连赢10次...见常量CONST_ARENA_*)}
function ACK_ARENA_RADIO.getEvent(self)
	return self.event
end

-- {挑战玩家uid}
function ACK_ARENA_RADIO.getTUid(self)
	return self.t_uid
end

-- {挑战玩家名字}
function ACK_ARENA_RADIO.getTName(self)
	return self.t_name
end

-- {挑战玩家排名}
function ACK_ARENA_RADIO.getTRanking(self)
	return self.t_ranking
end

-- {被挑战玩家uid}
function ACK_ARENA_RADIO.getBUid(self)
	return self.b_uid
end

-- {被挑战玩家名字}
function ACK_ARENA_RADIO.getBName(self)
	return self.b_name
end

-- {被挑战玩家排名}
function ACK_ARENA_RADIO.getBRanking(self)
	return self.b_ranking
end

-- {1:成功  2:失败 3:排名不变}
function ACK_ARENA_RADIO.getResult(self)
	return self.result
end
