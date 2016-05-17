
require "common/RequestMessage"

-- (手动) -- [23990]竞技场战报展示 -- 逐鹿台 

REQ_ARENA_WAR_DATA = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_ARENA_WAR_DATA
	self:init()
end)

function REQ_ARENA_WAR_DATA.serialize(self, writer)
	writer:writeInt16Unsigned(self.id)  -- {展示ID}
end

function REQ_ARENA_WAR_DATA.setArguments(self,id)
	self.id = id  -- {展示ID}
end

-- {展示ID}
function REQ_ARENA_WAR_DATA.setId(self, id)
	self.id = id
end
function REQ_ARENA_WAR_DATA.getId(self)
	return self.id
end
