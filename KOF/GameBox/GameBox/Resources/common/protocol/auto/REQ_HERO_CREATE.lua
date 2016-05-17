
require "common/RequestMessage"

-- (手动) -- [39040]创建进入副本 -- 英雄副本 

REQ_HERO_CREATE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_CREATE
	self:init()
end)

function REQ_HERO_CREATE.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本Id}
end

function REQ_HERO_CREATE.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本Id}
end

-- {副本Id}
function REQ_HERO_CREATE.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_HERO_CREATE.getCopyId(self)
	return self.copy_id
end
