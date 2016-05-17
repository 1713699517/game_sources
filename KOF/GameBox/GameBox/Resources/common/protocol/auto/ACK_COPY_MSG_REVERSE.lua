
require "common/AcknowledgementMessage"

-- (手动) -- [7003]副本信息返回块 -- 副本 

ACK_COPY_MSG_REVERSE = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_MSG_REVERSE
	self:init()
end)

function ACK_COPY_MSG_REVERSE.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.is_pass = reader:readInt8Unsigned() -- {是否通关过(1：是 0：否)}
end

-- {副本ID}
function ACK_COPY_MSG_REVERSE.getCopyId(self)
	return self.copy_id
end

-- {是否通关过(1：是 0：否)}
function ACK_COPY_MSG_REVERSE.getIsPass(self)
	return self.is_pass
end
