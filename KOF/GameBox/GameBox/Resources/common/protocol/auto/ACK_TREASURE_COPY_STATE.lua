
require "common/AcknowledgementMessage"

-- [47320]副本开启状态 -- 珍宝阁系统 

ACK_TREASURE_COPY_STATE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TREASURE_COPY_STATE
	self:init()
end)

function ACK_TREASURE_COPY_STATE.deserialize(self, reader)
	self.state = reader:readInt8Unsigned() -- {1:副本开启状态|0:关闭}
end

-- {1:副本开启状态|0:关闭}
function ACK_TREASURE_COPY_STATE.getState(self)
	return self.state
end
