
require "common/RequestMessage"

-- [40540]复活 -- 天宫之战 

REQ_SKYWAR_REVIVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_SKYWAR_REVIVE
	self:init(0, nil)
end)

function REQ_SKYWAR_REVIVE.serialize(self, writer)
	writer:writeInt8Unsigned(self.type)  -- {复活类型(0:正常复活|1:金元复活)}
end

function REQ_SKYWAR_REVIVE.setArguments(self,type)
	self.type = type  -- {复活类型(0:正常复活|1:金元复活)}
end

-- {复活类型(0:正常复活|1:金元复活)}
function REQ_SKYWAR_REVIVE.setType(self, type)
	self.type = type
end
function REQ_SKYWAR_REVIVE.getType(self)
	return self.type
end
