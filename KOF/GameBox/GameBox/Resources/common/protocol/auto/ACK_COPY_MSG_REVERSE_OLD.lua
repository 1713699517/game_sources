
require "common/AcknowledgementMessage"

-- [7003]副本信息返回块 -- 副本 

ACK_COPY_MSG_REVERSE_OLD = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_MSG_REVERSE_OLD
	self:init()
end)

function ACK_COPY_MSG_REVERSE_OLD.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.is_pass = reader:readInt8Unsigned() -- {是否通关过(1：是 0：否)}
end

-- {副本ID}
function ACK_COPY_MSG_REVERSE_OLD.getCopyId(self)
	return self.copy_id
end

-- {是否通关过(1：是 0：否)}
function ACK_COPY_MSG_REVERSE_OLD.getIsPass(self)
	return self.is_pass
end
