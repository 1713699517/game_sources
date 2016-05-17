
require "common/AcknowledgementMessage"

-- [7050]副本时间同步(待删除) -- 副本 

ACK_COPY_TIME_UPDATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_TIME_UPDATE
	self:init()
end)

function ACK_COPY_TIME_UPDATE.deserialize(self, reader)
	self.time = reader:readInt32Unsigned() -- {时间}
end

-- {时间}
function ACK_COPY_TIME_UPDATE.getTime(self)
	return self.time
end
