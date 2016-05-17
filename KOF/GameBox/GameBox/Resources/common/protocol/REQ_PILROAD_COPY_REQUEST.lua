
require "common/RequestMessage"

-- (手动) -- [39020]请求战役信息 -- 取经之路 

REQ_PILROAD_COPY_REQUEST = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PILROAD_COPY_REQUEST
	self:init()
end)

function REQ_PILROAD_COPY_REQUEST.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_PILROAD_COPY_REQUEST.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_PILROAD_COPY_REQUEST.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_PILROAD_COPY_REQUEST.getCopyId(self)
	return self.copy_id
end
