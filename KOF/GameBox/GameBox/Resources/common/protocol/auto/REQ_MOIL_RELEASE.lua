
require "common/RequestMessage"

-- [35100]释放苦工 -- 苦工 

REQ_MOIL_RELEASE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_MOIL_RELEASE
	self:init(0, nil)
end)

function REQ_MOIL_RELEASE.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {苦工uid}
end

function REQ_MOIL_RELEASE.setArguments(self,uid)
	self.uid = uid  -- {苦工uid}
end

-- {苦工uid}
function REQ_MOIL_RELEASE.setUid(self, uid)
	self.uid = uid
end
function REQ_MOIL_RELEASE.getUid(self)
	return self.uid
end
