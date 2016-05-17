
require "common/RequestMessage"

-- (手动) -- [7980]请求副本记录是否同一天 -- 副本 

REQ_COPY_RESET_ASK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_RESET_ASK
	self:init()
end)

function REQ_COPY_RESET_ASK.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_COPY_RESET_ASK.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_COPY_RESET_ASK.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_COPY_RESET_ASK.getCopyId(self)
	return self.copy_id
end
