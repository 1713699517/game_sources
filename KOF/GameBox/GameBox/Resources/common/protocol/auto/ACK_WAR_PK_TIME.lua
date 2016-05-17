
require "common/AcknowledgementMessage"

-- [6061]PK时间 -- 战斗 

ACK_WAR_PK_TIME = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_WAR_PK_TIME
	self:init()
end)

function ACK_WAR_PK_TIME.deserialize(self, reader)
	self.start_time = reader:readInt32Unsigned() -- {开始时间}
	self.end_time = reader:readInt32Unsigned() -- {结束时间}
end

-- {开始时间}
function ACK_WAR_PK_TIME.getStartTime(self)
	return self.start_time
end

-- {结束时间}
function ACK_WAR_PK_TIME.getEndTime(self)
	return self.end_time
end
