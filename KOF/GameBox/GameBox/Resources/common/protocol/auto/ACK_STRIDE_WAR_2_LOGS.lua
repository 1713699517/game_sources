
require "common/AcknowledgementMessage"

-- [43556]战报日志信息块 -- 跨服战 

ACK_STRIDE_WAR_2_LOGS = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_STRIDE_WAR_2_LOGS
	self:init()
end)

function ACK_STRIDE_WAR_2_LOGS.deserialize(self, reader)
	self.sid = reader:readInt16Unsigned() -- {玩家服务器ID}
	self.uid = reader:readInt32Unsigned() -- {玩家UID}
	self.name = reader:readUTF() -- {玩家名字}
	self.name_colcor = reader:readInt8Unsigned() -- {玩家名字颜色}
	self.t_sid = reader:readInt16Unsigned() -- {被挑战玩家服务器id}
	self.t_uid = reader:readInt32Unsigned() -- {被挑战玩家Uid}
	self.t_name = reader:readUTF() -- {被挑战玩家名字}
	self.t_name_colcor = reader:readInt8Unsigned() -- {被挑战玩家名字颜色}
	self.res = reader:readInt8Unsigned() -- {结果}
	self.war_id = reader:readInt32Unsigned() -- {战报Id}
end

-- {玩家服务器ID}
function ACK_STRIDE_WAR_2_LOGS.getSid(self)
	return self.sid
end

-- {玩家UID}
function ACK_STRIDE_WAR_2_LOGS.getUid(self)
	return self.uid
end

-- {玩家名字}
function ACK_STRIDE_WAR_2_LOGS.getName(self)
	return self.name
end

-- {玩家名字颜色}
function ACK_STRIDE_WAR_2_LOGS.getNameColcor(self)
	return self.name_colcor
end

-- {被挑战玩家服务器id}
function ACK_STRIDE_WAR_2_LOGS.getTSid(self)
	return self.t_sid
end

-- {被挑战玩家Uid}
function ACK_STRIDE_WAR_2_LOGS.getTUid(self)
	return self.t_uid
end

-- {被挑战玩家名字}
function ACK_STRIDE_WAR_2_LOGS.getTName(self)
	return self.t_name
end

-- {被挑战玩家名字颜色}
function ACK_STRIDE_WAR_2_LOGS.getTNameColcor(self)
	return self.t_name_colcor
end

-- {结果}
function ACK_STRIDE_WAR_2_LOGS.getRes(self)
	return self.res
end

-- {战报Id}
function ACK_STRIDE_WAR_2_LOGS.getWarId(self)
	return self.war_id
end
