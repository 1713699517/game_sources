
require "common/RequestMessage"

-- (手动) -- [7960]停止挂机 -- 副本 

REQ_COPY_STOP_UP_COPY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_STOP_UP_COPY
	self:init()
end)

function REQ_COPY_STOP_UP_COPY.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_COPY_STOP_UP_COPY.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_COPY_STOP_UP_COPY.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_COPY_STOP_UP_COPY.getCopyId(self)
	return self.copy_id
end
