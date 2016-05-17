
require "common/AcknowledgementMessage"

-- [38015]目标数据信息块 -- 目标任务 

ACK_TARGET_MSG_GROUP = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_TARGET_MSG_GROUP
	self:init()
end)

function ACK_TARGET_MSG_GROUP.deserialize(self, reader)
	self.serial = reader:readInt16Unsigned() -- {目标序号}
	self.state = reader:readInt8Unsigned() -- {目标状态}
end

-- {目标序号}
function ACK_TARGET_MSG_GROUP.getSerial(self)
	return self.serial
end

-- {目标状态}
function ACK_TARGET_MSG_GROUP.getState(self)
	return self.state
end
