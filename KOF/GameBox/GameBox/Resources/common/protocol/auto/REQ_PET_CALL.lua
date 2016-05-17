
require "common/RequestMessage"

-- [22850]召唤式神 -- 宠物 

REQ_PET_CALL = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_PET_CALL
	self:init(1 ,{ 22860,700 })
end)

function REQ_PET_CALL.serialize(self, writer)
	writer:writeInt16Unsigned(self.id)  -- {式神id}
end

function REQ_PET_CALL.setArguments(self,id)
	self.id = id  -- {式神id}
end

-- {式神id}
function REQ_PET_CALL.setId(self, id)
	self.id = id
end
function REQ_PET_CALL.getId(self)
	return self.id
end
