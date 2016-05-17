
require "common/AcknowledgementMessage"

-- [30501]活动状态改变滚屏通知 -- 活动面板 

ACK_ACTIVITY_DATA = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_ACTIVITY_DATA
	self:init()
end)

function ACK_ACTIVITY_DATA.deserialize(self, reader)
	self.active_id = reader:readInt16Unsigned() -- {活动ID}
	self.state = reader:readInt8Unsigned() -- {最新状态}
	self.arg = reader:readInt32Unsigned() -- {参数}
end

-- {活动ID}
function ACK_ACTIVITY_DATA.getActiveId(self)
	return self.active_id
end

-- {最新状态}
function ACK_ACTIVITY_DATA.getState(self)
	return self.state
end

-- {参数}
function ACK_ACTIVITY_DATA.getArg(self)
	return self.arg
end
