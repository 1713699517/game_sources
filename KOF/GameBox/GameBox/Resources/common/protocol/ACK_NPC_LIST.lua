
require "common/AcknowledgementMessage"

-- [26005]队伍列表 -- NPC 

ACK_NPC_LIST = class(CAcknowledgementMessage,function(self)
	self.MsgID = Protocol.ACK_NPC_LIST
	self:init()
end)

-- {队伍数量}
function ACK_NPC_LIST.getCount(self)
	return self.count
end

-- {队长Uid}
function ACK_NPC_LIST.getUid(self)
	return self.uid
end

-- {队长名}
function ACK_NPC_LIST.getName(self)
	return self.name
end
