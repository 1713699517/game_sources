
require "common/RequestMessage"

-- [26050]加入队伍 -- NPC 

REQ_NPC_JOIN = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_NPC_JOIN
	self:init(0, nil)
end)

function REQ_NPC_JOIN.serialize(self, writer)
	writer:writeInt32Unsigned(self.uid)  -- {队长Uid}
end

function REQ_NPC_JOIN.setArguments(self,uid)
	self.uid = uid  -- {队长Uid}
end

-- {队长Uid}
function REQ_NPC_JOIN.setUid(self, uid)
	self.uid = uid
end
function REQ_NPC_JOIN.getUid(self)
	return self.uid
end
