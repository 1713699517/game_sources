
require "common/RequestMessage"

-- [46250]刷新魔王副本 -- 魔王副本 

REQ_FIEND_FRESH_COPY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FIEND_FRESH_COPY
	self:init(0 ,{ 46260,700 })
end)

function REQ_FIEND_FRESH_COPY.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_FIEND_FRESH_COPY.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_FIEND_FRESH_COPY.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_FIEND_FRESH_COPY.getCopyId(self)
	return self.copy_id
end
