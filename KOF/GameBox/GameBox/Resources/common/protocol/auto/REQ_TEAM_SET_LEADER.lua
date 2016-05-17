
require "common/RequestMessage"

-- [3640]设置新队长 -- 组队系统 

REQ_TEAM_SET_LEADER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_SET_LEADER
	self:init(0 ,{ 3580,700 })
end)

function REQ_TEAM_SET_LEADER.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {新队长Uid}
end

function REQ_TEAM_SET_LEADER.setArguments(self,uid)
	self.uid = uid  -- {新队长Uid}
end

-- {新队长Uid}
function REQ_TEAM_SET_LEADER.setUid(self, uid)
	self.uid = uid
end
function REQ_TEAM_SET_LEADER.getUid(self)
	return self.uid
end
