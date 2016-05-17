
require "common/RequestMessage"

-- (手动) -- [7750]重新进入副本 -- 副本 

REQ_COPY_RECREAT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_RECREAT
	self:init()
end)

function REQ_COPY_RECREAT.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_COPY_RECREAT.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_COPY_RECREAT.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_COPY_RECREAT.getCopyId(self)
	return self.copy_id
end
