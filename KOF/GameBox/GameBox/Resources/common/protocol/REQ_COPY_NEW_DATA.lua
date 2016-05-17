
require "common/RequestMessage"

-- (手动) -- [7760]请求新的精英副本数据 -- 副本 

REQ_COPY_NEW_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_NEW_DATA
	self:init()
end)

function REQ_COPY_NEW_DATA.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本id}
end

function REQ_COPY_NEW_DATA.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本id}
end

-- {副本id}
function REQ_COPY_NEW_DATA.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_COPY_NEW_DATA.getCopyId(self)
	return self.copy_id
end
