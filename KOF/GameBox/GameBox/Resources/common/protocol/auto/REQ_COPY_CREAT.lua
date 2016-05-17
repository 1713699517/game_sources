
require "common/RequestMessage"

-- [7030]创建进入副本 -- 副本 

REQ_COPY_CREAT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_CREAT
	self:init(0 ,{ 5030,700 })
end)

function REQ_COPY_CREAT.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_COPY_CREAT.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_COPY_CREAT.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_COPY_CREAT.getCopyId(self)
	return self.copy_id
end
