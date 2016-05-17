
require "common/AcknowledgementMessage"

-- (手动) -- [6070]收到切磋请求 -- 战斗 

ACK_WAR_COMPARE_RECEIVE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_COMPARE_RECEIVE
	self:init()
end)

function ACK_WAR_COMPARE_RECEIVE.deserialize(self, reader)
	self.uid = reader:readInt32Unsigned() -- {请求者Uid}
	self.lv = reader:readInt8Unsigned() -- {请求者等级}
	self.name = reader:readString() -- {请求者名称}
end

-- {请求者Uid}
function ACK_WAR_COMPARE_RECEIVE.getUid(self)
	return self.uid
end

-- {请求者等级}
function ACK_WAR_COMPARE_RECEIVE.getLv(self)
	return self.lv
end

-- {请求者名称}
function ACK_WAR_COMPARE_RECEIVE.getName(self)
	return self.name
end
