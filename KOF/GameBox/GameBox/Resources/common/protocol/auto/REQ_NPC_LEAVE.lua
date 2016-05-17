
require "common/RequestMessage"

-- [26060]退出队伍 -- NPC 

REQ_NPC_LEAVE = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_NPC_LEAVE
	self:init(0, nil)
end)
