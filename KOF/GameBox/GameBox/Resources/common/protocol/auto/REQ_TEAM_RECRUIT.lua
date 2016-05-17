
require "common/RequestMessage"

-- (手动) -- [3690]招募队友 -- 组队系统 

REQ_TEAM_RECRUIT = class(CRequestMessage,function(self)
	self.MsgID = Protocol.REQ_TEAM_RECRUIT
	self:init()
end)
