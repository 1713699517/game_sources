
require "common/AcknowledgementMessage"

-- (手动) -- [7990]副本记录是否同一天返回 -- 副本 

ACK_COPY_RESET_BACK = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_RESET_BACK
	self:init()
end)

function ACK_COPY_RESET_BACK.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.state = reader:readInt8Unsigned() -- {是否同一 天(1：是同一天|0：不是同一天)}
end

-- {副本ID}
function ACK_COPY_RESET_BACK.getCopyId(self)
	return self.copy_id
end

-- {是否同一 天(1：是同一天|0：不是同一天)}
function ACK_COPY_RESET_BACK.getState(self)
	return self.state
end
