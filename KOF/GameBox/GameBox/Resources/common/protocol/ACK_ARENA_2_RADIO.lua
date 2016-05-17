
require "common/AcknowledgementMessage"

-- (手动) -- [23851]战果广播(新) -- 封神台 

ACK_ARENA_2_RADIO = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ARENA_2_RADIO
	self:init()
end)

function ACK_ARENA_2_RADIO.deserialize(self, reader)
	self.start_time = reader:readInt32Unsigned() -- {挑战开始时间}
	self.type = reader:readInt8Unsigned() -- {广播类型(传闻,竞技场 见常量CONST_CHAT_*)}
	self.event = reader:readInt8Unsigned() -- {事件(排名第一、连赢10次...见常量CONST_ARENA_*)}
	self.t_sid = reader:readInt16Unsigned() -- {挑战服务器ID}
	self.t_uid = reader:readInt32Unsigned() -- {挑战玩家uid}
	self.t_name = reader:readUTF() -- {挑战玩家名字}
	self.t_ranking = reader:readInt16Unsigned() -- {挑战玩家排名}
	self.b_sid = reader:readInt16Unsigned() -- {被挑战服务器ID}
	self.b_uid = reader:readInt32Unsigned() -- {被挑战玩家uid}
	self.b_name = reader:readUTF() -- {被挑战玩家名字}
	self.b_ranking = reader:readInt16Unsigned() -- {被挑战玩家排名}
	self.result = reader:readInt8Unsigned() -- {1:成功 2:失败 3:排名不变}
	self.id = reader:readInt32Unsigned() -- {战报ID}
end

-- {挑战开始时间}
function ACK_ARENA_2_RADIO.getStartTime(self)
	return self.start_time
end

-- {广播类型(传闻,竞技场 见常量CONST_CHAT_*)}
function ACK_ARENA_2_RADIO.getType(self)
	return self.type
end

-- {事件(排名第一、连赢10次...见常量CONST_ARENA_*)}
function ACK_ARENA_2_RADIO.getEvent(self)
	return self.event
end

-- {挑战服务器ID}
function ACK_ARENA_2_RADIO.getTSid(self)
	return self.t_sid
end

-- {挑战玩家uid}
function ACK_ARENA_2_RADIO.getTUid(self)
	return self.t_uid
end

-- {挑战玩家名字}
function ACK_ARENA_2_RADIO.getTName(self)
	return self.t_name
end

-- {挑战玩家排名}
function ACK_ARENA_2_RADIO.getTRanking(self)
	return self.t_ranking
end

-- {被挑战服务器ID}
function ACK_ARENA_2_RADIO.getBSid(self)
	return self.b_sid
end

-- {被挑战玩家uid}
function ACK_ARENA_2_RADIO.getBUid(self)
	return self.b_uid
end

-- {被挑战玩家名字}
function ACK_ARENA_2_RADIO.getBName(self)
	return self.b_name
end

-- {被挑战玩家排名}
function ACK_ARENA_2_RADIO.getBRanking(self)
	return self.b_ranking
end

-- {1:成功 2:失败 3:排名不变}
function ACK_ARENA_2_RADIO.getResult(self)
	return self.result
end

-- {战报ID}
function ACK_ARENA_2_RADIO.getId(self)
	return self.id
end
