
require "common/RequestMessage"

-- [36040]开始挑战 -- 三界杀 

REQ_CIRCLE_WAR_START = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_CIRCLE_WAR_START
	self:init(0, nil)
end)

function REQ_CIRCLE_WAR_START.serialize(self, writer)
	writer:writeInt16Unsigned(self.id)  -- {武将ID}
end

function REQ_CIRCLE_WAR_START.setArguments(self,id)
	self.id = id  -- {武将ID}
end

-- {武将ID}
function REQ_CIRCLE_WAR_START.setId(self, id)
	self.id = id
end
function REQ_CIRCLE_WAR_START.getId(self)
	return self.id
end
