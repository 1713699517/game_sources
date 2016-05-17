
require "common/RequestMessage"

-- [26010]从NPC处滚蛋 -- NPC 

REQ_NPC_SCRAM = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_NPC_SCRAM
	self:init(0, nil)
end)
