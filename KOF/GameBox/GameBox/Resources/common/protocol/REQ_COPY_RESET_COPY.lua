
require "common/RequestMessage"

-- (手动) -- [7999]重置副本 -- 副本 

REQ_COPY_RESET_COPY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_COPY_RESET_COPY
	self:init()
end)

function REQ_COPY_RESET_COPY.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID(副本重置)}
end

function REQ_COPY_RESET_COPY.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID(副本重置)}
end

-- {副本ID(副本重置)}
function REQ_COPY_RESET_COPY.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_COPY_RESET_COPY.getCopyId(self)
	return self.copy_id
end
