
require "common/RequestMessage"

-- [3630]踢出队员 -- 组队系统 

REQ_TEAM_KICK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_KICK
	self:init(0 ,{ 3580,700 })
end)

function REQ_TEAM_KICK.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {队员Uid}
end

function REQ_TEAM_KICK.setArguments(self,uid)
	self.uid = uid  -- {队员Uid}
end

-- {队员Uid}
function REQ_TEAM_KICK.setUid(self, uid)
	self.uid = uid
end
function REQ_TEAM_KICK.getUid(self)
	return self.uid
end
