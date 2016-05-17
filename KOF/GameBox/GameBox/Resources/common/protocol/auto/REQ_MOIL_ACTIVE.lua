
require "common/RequestMessage"

-- [35050]互动 -- 苦工 

REQ_MOIL_ACTIVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_ACTIVE
	self:init(0, nil)
end)

function REQ_MOIL_ACTIVE.serialize(self, writer)
	writer:writeInt8Unsigned(self.active_id)  -- {互动Id}
	writer:writeInt32Unsigned(self.uid)  -- {苦工uid}
end

function REQ_MOIL_ACTIVE.setArguments(self,active_id,uid)
	self.active_id = active_id  -- {互动Id}
	self.uid = uid  -- {苦工uid}
end

-- {互动Id}
function REQ_MOIL_ACTIVE.setActiveId(self, active_id)
	self.active_id = active_id
end
function REQ_MOIL_ACTIVE.getActiveId(self)
	return self.active_id
end

-- {苦工uid}
function REQ_MOIL_ACTIVE.setUid(self, uid)
	self.uid = uid
end
function REQ_MOIL_ACTIVE.getUid(self)
	return self.uid
end
