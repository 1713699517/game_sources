
require "common/RequestMessage"

-- [6050]邀请PK -- 战斗 

REQ_WAR_PK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_PK
	self:init(0, nil)
end)

function REQ_WAR_PK.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {被邀请人UID}
end

function REQ_WAR_PK.setArguments(self,uid)
	self.uid = uid  -- {被邀请人UID}
end

-- {被邀请人UID}
function REQ_WAR_PK.setUid(self, uid)
	self.uid = uid
end
function REQ_WAR_PK.getUid(self)
	return self.uid
end
