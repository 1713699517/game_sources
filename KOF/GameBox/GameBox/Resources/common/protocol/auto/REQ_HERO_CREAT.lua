
require "common/RequestMessage"

-- (手动) -- [39040]创建进入副本 -- 英雄副本 

REQ_HERO_CREAT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_CREAT
	self:init()
end)

function REQ_HERO_CREAT.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {副本ID}
end

function REQ_HERO_CREAT.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {副本ID}
end

-- {副本ID}
function REQ_HERO_CREAT.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_HERO_CREAT.getCopyId(self)
	return self.copy_id
end
