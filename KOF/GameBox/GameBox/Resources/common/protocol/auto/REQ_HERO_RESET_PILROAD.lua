
require "common/RequestMessage"

-- (手动) -- [39036]重置取经之路(单人模式) -- 英雄副本 

REQ_HERO_RESET_PILROAD = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_HERO_RESET_PILROAD
	self:init()
end)

function REQ_HERO_RESET_PILROAD.serialize(self, writer)
	writer:writeInt16Unsigned(self.copy_id)  -- {战役Id(单人模式)}
end

function REQ_HERO_RESET_PILROAD.setArguments(self,copy_id)
	self.copy_id = copy_id  -- {战役Id(单人模式)}
end

-- {战役Id(单人模式)}
function REQ_HERO_RESET_PILROAD.setCopyId(self, copy_id)
	self.copy_id = copy_id
end
function REQ_HERO_RESET_PILROAD.getCopyId(self)
	return self.copy_id
end
