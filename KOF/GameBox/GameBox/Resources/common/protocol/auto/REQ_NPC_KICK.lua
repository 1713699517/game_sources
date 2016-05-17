
require "common/RequestMessage"

-- [26070]踢出队员 -- NPC 

REQ_NPC_KICK = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_NPC_KICK
	self:init(0, nil)
end)

function REQ_NPC_KICK.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {队员uid}
end

function REQ_NPC_KICK.setArguments(self,uid)
	self.uid = uid  -- {队员uid}
end

-- {队员uid}
function REQ_NPC_KICK.setUid(self, uid)
	self.uid = uid
end
function REQ_NPC_KICK.getUid(self)
	return self.uid
end
