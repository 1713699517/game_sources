
require "common/RequestMessage"

-- [3680]邀请好友 -- 组队系统 

REQ_TEAM_INVITE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_INVITE
	self:init(0, nil)
end)

function REQ_TEAM_INVITE.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {好友Uid}
	writer:writeInt8Unsigned(self.type)  -- {邀请类型,详见CONST_TEAM_INVITE_*}
end

function REQ_TEAM_INVITE.setArguments(self,uid,type)
	self.uid = uid  -- {好友Uid}
	self.type = type  -- {邀请类型,详见CONST_TEAM_INVITE_*}
end

-- {好友Uid}
function REQ_TEAM_INVITE.setUid(self, uid)
	self.uid = uid
end
function REQ_TEAM_INVITE.getUid(self)
	return self.uid
end

-- {邀请类型,详见CONST_TEAM_INVITE_*}
function REQ_TEAM_INVITE.setType(self, type)
	self.type = type
end
function REQ_TEAM_INVITE.getType(self)
	return self.type
end
