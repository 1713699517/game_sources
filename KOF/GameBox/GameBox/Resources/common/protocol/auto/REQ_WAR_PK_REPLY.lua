
require "common/RequestMessage"

-- [6070]邀请回复 -- 战斗 

REQ_WAR_PK_REPLY = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_WAR_PK_REPLY
	self:init(0, nil)
end)

function REQ_WAR_PK_REPLY.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {邀请人UID}
	writer:writeInt8Unsigned(self.res)  -- {1:同意0:失败}
end

function REQ_WAR_PK_REPLY.setArguments(self,uid,res)
	self.uid = uid  -- {邀请人UID}
	self.res = res  -- {1:同意0:失败}
end

-- {邀请人UID}
function REQ_WAR_PK_REPLY.setUid(self, uid)
	self.uid = uid
end
function REQ_WAR_PK_REPLY.getUid(self)
	return self.uid
end

-- {1:同意0:失败}
function REQ_WAR_PK_REPLY.setRes(self, res)
	self.res = res
end
function REQ_WAR_PK_REPLY.getRes(self)
	return self.res
end
