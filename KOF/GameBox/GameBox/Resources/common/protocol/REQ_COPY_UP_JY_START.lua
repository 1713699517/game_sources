
require "common/RequestMessage"

-- (手动) -- [7880]挂机-精英副本开始挂机 -- 副本 

REQ_COPY_UP_JY_START = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_UP_JY_START
	self:init()
end)

function REQ_COPY_UP_JY_START.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_COPY_UP_JY_START.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_COPY_UP_JY_START.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_COPY_UP_JY_START.getCopyId(self)
	return self.copy_id
end
