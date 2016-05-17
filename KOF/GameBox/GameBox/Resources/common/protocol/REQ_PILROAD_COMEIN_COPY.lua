
require "common/RequestMessage"

-- (手动) -- [39030]进入战役 -- 取经之路 

REQ_PILROAD_COMEIN_COPY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PILROAD_COMEIN_COPY
	self:init()
end)

function REQ_PILROAD_COMEIN_COPY.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_PILROAD_COMEIN_COPY.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_PILROAD_COMEIN_COPY.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_PILROAD_COMEIN_COPY.getCopyId(self)
	return self.copy_id
end
