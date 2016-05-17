
require "common/AcknowledgementMessage"

-- [33026]社团日志数据块 -- 社团 

ACK_CLAN_LOGS_MSG = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_CLAN_LOGS_MSG
	self:init()
end)

function ACK_CLAN_LOGS_MSG.deserialize(self, reader)
	self.type = reader:readInt8Unsigned() -- {日志类型| CONST_CLAN_EVENT_XX}
	self.time = reader:readInt32Unsigned() -- {时间戳(s)}
	self.count1 = reader:readInt16Unsigned() -- {string数量}
	self.string_msg = reader:readXXXGroup() -- {string数据块【33027】}
	self.count2 = reader:readInt16Unsigned() -- {int数量}
	self.int_msg = reader:readXXXGroup() -- {int数据块【33028】}
end

-- {日志类型| CONST_CLAN_EVENT_XX}
function ACK_CLAN_LOGS_MSG.getType(self)
	return self.type
end

-- {时间戳(s)}
function ACK_CLAN_LOGS_MSG.getTime(self)
	return self.time
end

-- {string数量}
function ACK_CLAN_LOGS_MSG.getCount1(self)
	return self.count1
end

-- {string数据块【33027】}
function ACK_CLAN_LOGS_MSG.getStringMsg(self)
	return self.string_msg
end

-- {int数量}
function ACK_CLAN_LOGS_MSG.getCount2(self)
	return self.count2
end

-- {int数据块【33028】}
function ACK_CLAN_LOGS_MSG.getIntMsg(self)
	return self.int_msg
end
