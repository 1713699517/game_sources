
require "common/RequestMessage"

-- [26080]解散队伍 -- NPC 

REQ_NPC_DISMISS = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_NPC_DISMISS
	self:init(0, nil)
end)
