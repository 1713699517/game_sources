
require "common/RequestMessage"

-- (手动) -- [3630]踢出队员 -- 组队系统 

REQ_TEAM_KICK_TEAM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_KICK_TEAM
	self:init()
end)

function REQ_TEAM_KICK_TEAM.serialize(self, writer)
	writer:writeInt16Unsigned(self.sid)  -- {队员Sid}
	writer:writeInt32Unsigned(self.uid)  -- {队员Uid}
end

function REQ_TEAM_KICK_TEAM.setArguments(self,sid,uid)
	self.sid = sid  -- {队员Sid}
	self.uid = uid  -- {队员Uid}
end

-- {队员Sid}
function REQ_TEAM_KICK_TEAM.setSid(self, sid)
	self.sid = sid
end
function REQ_TEAM_KICK_TEAM.getSid(self)
	return self.sid
end

-- {队员Uid}
function REQ_TEAM_KICK_TEAM.setUid(self, uid)
	self.uid = uid
end
function REQ_TEAM_KICK_TEAM.getUid(self)
	return self.uid
end
