
require "common/AcknowledgementMessage"

-- (手动) -- [7700]进入副本次数更新 -- 副本 

ACK_COPY_UPDATE_TIMES = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_COPY_UPDATE_TIMES
	self:init()
end)

function ACK_COPY_UPDATE_TIMES.deserialize(self, reader)
	self.copy_id = reader:readInt16Unsigned() -- {副本ID}
	self.times = reader:readInt8Unsigned() -- {次数}
end

-- {副本ID}
function ACK_COPY_UPDATE_TIMES.getCopyId(self)
	return self.copy_id
end

-- {次数}
function ACK_COPY_UPDATE_TIMES.getTimes(self)
	return self.times
end
