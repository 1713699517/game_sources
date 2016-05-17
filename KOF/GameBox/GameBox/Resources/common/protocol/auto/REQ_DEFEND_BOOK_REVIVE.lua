
require "common/RequestMessage"

-- [21240]复活 -- 活动-保卫经书 

REQ_DEFEND_BOOK_REVIVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_DEFEND_BOOK_REVIVE
	self:init(0, nil)
end)

function REQ_DEFEND_BOOK_REVIVE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {复活类型 0普通|1金元}
end

function REQ_DEFEND_BOOK_REVIVE.setArguments(self,type)
	self.type = type  -- {复活类型 0普通|1金元}
end

-- {复活类型 0普通|1金元}
function REQ_DEFEND_BOOK_REVIVE.setType(self, type)
	self.type = type
end
function REQ_DEFEND_BOOK_REVIVE.getType(self)
	return self.type
end
