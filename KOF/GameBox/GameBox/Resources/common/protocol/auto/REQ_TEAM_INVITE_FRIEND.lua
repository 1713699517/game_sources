
require "common/RequestMessage"

-- (手动) -- [3720]邀请好友组队 -- 组队系统 

REQ_TEAM_INVITE_FRIEND = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_INVITE_FRIEND
	self:init()
end)

function REQ_TEAM_INVITE_FRIEND.serialize(self, writer)
	writer:writeInt16Unsigned(self.sid)  -- {好友Sid}
	writer:writeInt32Unsigned(self.uid)  -- {好友Uid}
end

function REQ_TEAM_INVITE_FRIEND.setArguments(self,sid,uid)
	self.sid = sid  -- {好友Sid}
	self.uid = uid  -- {好友Uid}
end

-- {好友Sid}
function REQ_TEAM_INVITE_FRIEND.setSid(self, sid)
	self.sid = sid
end
function REQ_TEAM_INVITE_FRIEND.getSid(self)
	return self.sid
end

-- {好友Uid}
function REQ_TEAM_INVITE_FRIEND.setUid(self, uid)
	self.uid = uid
end
function REQ_TEAM_INVITE_FRIEND.getUid(self)
	return self.uid
end
