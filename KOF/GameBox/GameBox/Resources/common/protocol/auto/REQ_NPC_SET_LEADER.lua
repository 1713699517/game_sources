
require "common/RequestMessage"

-- [26040]设置队长 -- NPC 

REQ_NPC_SET_LEADER = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_NPC_SET_LEADER
	self:init(0, nil)
end)

function REQ_NPC_SET_LEADER.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {新队长Uid}
end

function REQ_NPC_SET_LEADER.setArguments(self,uid)
	self.uid = uid  -- {新队长Uid}
end

-- {新队长Uid}
function REQ_NPC_SET_LEADER.setUid(self, uid)
	self.uid = uid
end
function REQ_NPC_SET_LEADER.getUid(self)
	return self.uid
end
