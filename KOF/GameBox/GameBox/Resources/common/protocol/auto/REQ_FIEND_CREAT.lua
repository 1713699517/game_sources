
require "common/RequestMessage"

-- (手动) -- [46240]创建进入副本 -- 魔王副本 

REQ_FIEND_CREAT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_FIEND_CREAT
	self:init()
end)

function REQ_FIEND_CREAT.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_FIEND_CREAT.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_FIEND_CREAT.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_FIEND_CREAT.getCopyId(self)
	return self.copy_id
end
